// controllers/asistencia.controllers.js
import { pool } from "../../db_conection.js";

// === OBTENER TODAS LAS JORNADAS CON CONTADOR DE MARCAS ===
export const obtenerJornadas = async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT 
        j.id_jornada,
        j.fecha,
        j.creado_el,
        j.estado,
        COUNT(d.id_detalle) AS total_marcas
      FROM jornadas_asistencia j
      LEFT JOIN detalle_asistencia d ON j.id_jornada = d.id_jornada
      GROUP BY j.id_jornada
      ORDER BY j.fecha DESC
    `);
    res.json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error al obtener jornadas" });
  }
};


// AL FINAL del archivo
export const eliminarJornada = async (req, res) => {
  try {
    const { id_jornada } = req.params;
    const [result] = await pool.query("DELETE FROM jornadas_asistencia WHERE id_jornada = ?", [id_jornada]);
    if (result.affectedRows === 0) return res.status(404).json({ message: "Jornada no encontrada" });
    res.json({ message: "Jornada eliminada correctamente" });
  } catch (error) {
    res.status(500).json({ message: "Error al eliminar jornada" });
  }
};

// === CREAR JORNADA CON FECHA LOCAL DE NICARAGUA (UTC-6) ===
export const crearJornada = async (req, res) => {
  try {
    let { fecha } = req.body;



    
    // FORZAR ZONA HORARIA DE NICARAGUA (UTC-6, sin horario de verano)
    if (!fecha) {
      const now = new Date();
      const nicaraguaOffset = -6 * 60; // UTC-6 en minutos
      const localDate = new Date(now.getTime() + nicaraguaOffset * 60 * 1000);
      fecha = localDate.toISOString().split("T")[0]; // YYYY-MM-DD
    }

    const [result] = await pool.query(
      `INSERT IGNORE INTO jornadas_asistencia (fecha) VALUES (?)`,
      [fecha]
    );

    if (result.affectedRows === 0) {
      return res.status(200).json({ message: "Jornada ya existía", fecha });
    }
    res.status(201).json({ message: "Jornada creada", fecha });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error al crear jornada" });
  }
};
// CERRAR JORNADA
export const cerrarJornada = async (req, res) => {
  try {
    const { id_jornada } = req.params;
    await pool.query("UPDATE jornadas_asistencia SET estado = 'cerrada' WHERE id_jornada = ?", [id_jornada]);
    res.json({ message: "Jornada cerrada correctamente" });
  } catch (error) {
    res.status(500).json({ message: "Error al cerrar jornada" });
  }
};


// === OBTENER DETALLE DE UN DÍA (CORREGIDO PARA NUNCA FALLAR) ===
export const obtenerDetalleJornada = async (req, res) => {
  try {
    const { id_jornada } = req.params;

    const [rows] = await pool.query(`
      SELECT 
        d.id_detalle,
        d.id_empleado,
        COALESCE(e.nombre, 'Empleado') AS nombre,
        COALESCE(e.apellido, 'Sin Apellido') AS apellido,
        e.foto,
        d.hora_entrada,
        d.hora_salida,
        d.horas_trabajadas
      FROM detalle_asistencia d
      LEFT JOIN Empleado e ON d.id_empleado = e.id_empleado
      WHERE d.id_jornada = ?
      ORDER BY e.apellido, e.nombre
    `, [id_jornada]);

    res.json(rows);
  } catch (error) {
    console.error("Error en obtenerDetalleJornada:", error);
    res.status(500).json({ message: "Error al cargar detalle", error: error.message });
  }
};



// === MARCAR ENTRADA AHORA ===
export const marcarEntrada = async (req, res) => {
  try {
    const { id_jornada, id_empleado } = req.body;

    if (!id_jornada || !id_empleado) {
      return res.status(400).json({ message: "Faltan datos: id_jornada o id_empleado" });
    }

    // Verificar duplicado
    const [existe] = await pool.query(
      "SELECT id_detalle FROM detalle_asistencia WHERE id_jornada = ? AND id_empleado = ?",
      [id_jornada, id_empleado]
    );

    if (existe.length > 0) {
      return res.status(400).json({ message: "Este empleado ya marcó entrada hoy" });
    }

    const ahora = new Date();
    const [result] = await pool.query(
      "INSERT INTO detalle_asistencia (id_jornada, id_empleado, hora_entrada) VALUES (?, ?, ?)",
      [id_jornada, id_empleado, ahora]
    );

    res.json({ 
      message: "Entrada marcada correctamente",
      id_detalle: result.insertId,
      hora_entrada: ahora
    });

  } catch (error) {
    console.error("Error en marcarEntrada backend:", error);
    res.status(500).json({ message: "Error interno del servidor" });
  }
};

// === MARCAR SALIDA AHORA + CALCULAR HORAS ===
export const marcarSalida = async (req, res) => {
  try {
    const { id_detalle } = req.params;
    const ahora = new Date();

    // Obtener entrada
    const [entrada] = await pool.query(
      `SELECT hora_entrada FROM detalle_asistencia WHERE id_detalle = ?`,
      [id_detalle]
    );
    if (entrada.length === 0 || !entrada[0].hora_entrada) {
      return res.status(400).json({ message: "No hay entrada registrada" });
    }

    const horaEntrada = new Date(entrada[0].hora_entrada);
    let horasTrabajadas = (ahora - horaEntrada) / (1000 * 60 * 60);

    // Si cruzó medianoche (más de 20 horas), ajustar
    if (horasTrabajadas > 20) {
      horasTrabajadas = (ahora - horaEntrada + 24 * 60 * 60 * 1000) / (1000 * 60 * 60);
    }

    await pool.query(
      `UPDATE detalle_asistencia 
       SET hora_salida = ?, horas_trabajadas = ? 
       WHERE id_detalle = ?`,
      [ahora, parseFloat(horasTrabajadas.toFixed(4)), id_detalle]
    );

    res.json({ 
      message: "Salida marcada", 
      hora_salida: ahora,
      horas_trabajadas: parseFloat(horasTrabajadas.toFixed(4))
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error al marcar salida" });
  }
};

// === ELIMINAR MARCA ===
export const eliminarDetalle = async (req, res) => {
  try {
    const { id_detalle } = req.params;
    const [result] = await pool.query(
      `DELETE FROM detalle_asistencia WHERE id_detalle = ?`,
      [id_detalle]
    );
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Marca no encontrada" });
    }
    res.json({ message: "Marca eliminada" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error al eliminar" });
  }
};