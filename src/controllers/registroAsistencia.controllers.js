import { pool } from "../../db_conection.js";

export const obtenerRegistrosAsistencia = async (req, res) => {
  try {
    const [result] = await pool.query(`
      SELECT r.id_registro, r.id_empleado, r.id_turno, r.fecha, r.hora_entrada, r.hora_salida, r.horas_trabajadas,
             e.nombre, e.apellido, e.foto
      FROM RegistroAsistencia r
      JOIN Empleado e ON r.id_empleado = e.id_empleado
    `);
    res.json(result);
  } catch (error) {
    return res.status(500).json({ message: "Error al obtener registros de asistencia", error: error.message });
  }
};



// Obtener un registro por ID con datos del empleado
export const obtenerRegistroAsistencia = async (req, res) => {
  try {
    const [result] = await pool.query(`
      SELECT r.id_registro, r.id_empleado, r.id_turno, r.fecha, r.hora_entrada, r.hora_salida, r.horas_trabajadas,
             e.nombre, e.apellido, e.foto
      FROM RegistroAsistencia r
      JOIN Empleado e ON r.id_empleado = e.id_empleado
      WHERE r.id_registro = ?
    `, [req.params.id_registro]);

    if (result.length <= 0)
      return res.status(404).json({ message: "Registro de asistencia no encontrado" });

    res.json(result[0]);
  } catch (error) {
    return res.status(500).json({ message: "Error al obtener registro de asistencia", error: error.message });
  }
};

// Crear un nuevo registro de asistencia
export const crearRegistroAsistencia = async (req, res) => {
  try {
    const { id_empleado, id_turno, fecha, hora_entrada, hora_salida } = req.body;

    if (!id_empleado || !id_turno || !fecha || !hora_entrada || !hora_salida) {
      return res.status(400).json({ message: "Todos los campos son obligatorios" });
    }

    // Validar que el empleado exista
    const [empleadoExist] = await pool.query(
      "SELECT id_empleado FROM Empleado WHERE id_empleado = ?",
      [id_empleado]
    );
    if (empleadoExist.length === 0) {
      return res.status(400).json({ message: "El empleado no existe" });
    }

    // Validar que el turno exista
    const [turnoExist] = await pool.query(
      "SELECT id_turno FROM Turnos WHERE id_turno = ?",
      [id_turno]
    );
    if (turnoExist.length === 0) {
      return res.status(400).json({ message: "El turno no existe" });
    }

    // Calcular horas trabajadas
    const entrada = new Date(`1970-01-01T${hora_entrada}:00`);
    const salida = new Date(`1970-01-01T${hora_salida}:00`);
    let horas_trabajadas = (salida - entrada) / (1000 * 60 * 60);
    if (horas_trabajadas < 0) horas_trabajadas += 24;

    const [result] = await pool.query(
      "INSERT INTO RegistroAsistencia (id_empleado, id_turno, fecha, hora_entrada, hora_salida, horas_trabajadas) VALUES (?, ?, ?, ?, ?, ?)",
      [id_empleado, id_turno, fecha, hora_entrada, hora_salida, horas_trabajadas]
    );

    res.json({
      id: result.insertId,
      id_empleado,
      id_turno,
      fecha,
      hora_entrada,
      hora_salida,
      horas_trabajadas,
    });
  } catch (error) {
    console.error("Error al crear registro de asistencia:", error);
    return res.status(500).json({ message: "Error al crear registro de asistencia", error: error.message });
  }
};

// Eliminar un registro
export const eliminarRegistroAsistencia = async (req, res) => {
  try {
    const [result] = await pool.query(
      "DELETE FROM RegistroAsistencia WHERE id_registro = ?",
      [req.params.id_registro]
    );
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Registro de asistencia no encontrado" });

    res.json({ message: "Registro de asistencia eliminado correctamente" });
  } catch (error) {
    return res.status(500).json({ message: "Error al eliminar registro de asistencia", error: error.message });
  }
};

// Actualizar un registro de asistencia
export const actualizarRegistroAsistencia = async (req, res) => {
  try {
    const { id_empleado, id_turno, fecha, hora_entrada, hora_salida } = req.body;

    if (!id_empleado || !id_turno || !fecha) {
      return res.status(400).json({ message: "Faltan campos obligatorios (empleado, turno o fecha)" });
    }

    const fechaFormateada = fecha.includes('T') ? fecha.split('T')[0] : fecha;

    let horas_trabajadas = null;
    if (hora_entrada && hora_salida) {
      const inicio = new Date(`1970-01-01T${hora_entrada}`);
      const fin = new Date(`1970-01-01T${hora_salida}`);
      const diferencia = (fin - inicio) / (1000 * 60 * 60);
      horas_trabajadas = diferencia > 0 ? parseFloat(diferencia.toFixed(2)) : 0;
    }

    const [result] = await pool.query(
      `UPDATE RegistroAsistencia 
       SET id_empleado = ?, id_turno = ?, fecha = ?, hora_entrada = ?, hora_salida = ?, horas_trabajadas = ?
       WHERE id_registro = ?`,
      [id_empleado, id_turno, fechaFormateada, hora_entrada, hora_salida, horas_trabajadas, req.params.id_registro]
    );

    if (result.affectedRows <= 0) {
      return res.status(404).json({ message: "Registro de asistencia no encontrado" });
    }

    res.json({ message: "Registro de asistencia actualizado correctamente" });
  } catch (error) {
    console.error("Error al actualizar registro de asistencia:", error);
    return res.status(500).json({ message: error.message, stack: error.stack });
  }
};

// Actualización parcial (PATCH)
export const patchRegistroAsistencia = async (req, res) => {
  try {
    const campos = req.body;
    const [result] = await pool.query(
      "UPDATE RegistroAsistencia SET ? WHERE id_registro = ?",
      [campos, req.params.id_registro]
    );
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Registro de asistencia no encontrado" });

    res.json({ message: "Registro de asistencia actualizado parcialmente" });
  } catch (error) {
    return res.status(500).json({ message: "Error en actualización parcial de registro de asistencia", error: error.message });
  }
};
