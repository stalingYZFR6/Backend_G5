import { pool } from "../../db_conection.js";

// Obtener todos los turnos (con nombre del empleado)
export const obtenerTurnos = async (req, res) => {
  try {
    const [result] = await pool.query(`
      SELECT 
        t.id_turno,
        t.id_empleado,
        e.nombre AS nombre_empleado,
        e.apellido AS apellido_empleado,
        t.fecha,
        t.hora_inicio,
        t.hora_fin,
        t.tipo_turno
      FROM Turnos t
      INNER JOIN Empleado e ON t.id_empleado = e.id_empleado
      ORDER BY t.fecha DESC
    `);
    res.json(result);
  } catch (error) {
    console.error("Error al obtener turnos:", error);
    return res.status(500).json({ message: "Error al obtener turnos" });
  }
};


// Obtener un turno por ID
export const obtenerTurno = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Turnos WHERE id_turno = ?", [req.params.id_turno]);
    if (result.length <= 0)
      return res.status(404).json({ message: "Turno no encontrado" });
    res.json(result[0]);
  } catch (error) {
    return res.status(500).json({ message: "Error al obtener turno" });
  }
};

// Crear un nuevo turno
export const crearTurno = async (req, res) => {
  try {
    const { id_empleado, fecha, hora_inicio, hora_fin, tipo_turno } = req.body;
    const [result] = await pool.query(
      "INSERT INTO Turnos (id_empleado, fecha, hora_inicio, hora_fin, tipo_turno) VALUES (?, ?, ?, ?, ?)",
      [id_empleado, fecha, hora_inicio, hora_fin, tipo_turno]
    );
    res.json({ id: result.insertId, id_empleado, fecha, hora_inicio, hora_fin, tipo_turno });
  } catch (error) {
    return res.status(500).json({ message: "Error al crear turno" });
  }
};

// Eliminar un turno
  export const eliminarTurno = async (req, res) => {
    try {
      const [result] = await pool.query(
        "DELETE FROM Turnos WHERE id_turno = ?",
        [req.params.id_turno]
      );

      if (result.affectedRows <= 0)
        return res.status(404).json({ message: "Turno no encontrado" });

      res.json({ message: "Turno eliminado correctamente" });
    } catch (error) {
      console.error("Error al eliminar turno:", error); // Muestra en consola
      return res.status(500).json({
        message: "Error al eliminar turno",
        error: error.message,    // Devuelve el error verdadero al frontend
      });
    }
  };

  // Actualizar un turno (PUT)
  export const actualizarTurno = async (req, res) => {
    try {
      const { id_empleado, fecha, hora_inicio, hora_fin, tipo_turno } = req.body;

      const [result] = await pool.query(
        `UPDATE Turnos 
        SET id_empleado = ?, fecha = ?, hora_inicio = ?, hora_fin = ?, tipo_turno = ? 
        WHERE id_turno = ?`,
        [id_empleado, fecha, hora_inicio, hora_fin, tipo_turno, req.params.id_turno]
      );

      if (result.affectedRows <= 0) {
        return res.status(404).json({ message: "Turno no encontrado" });
      }

      res.json({ message: "Turno actualizado correctamente" });
    } catch (error) {
      console.error("Error al actualizar turno:", error);
      return res.status(500).json({ message: "Error al actualizar turno" });
    }
  };


// Actualización parcial (PATCH)
export const patchTurno = async (req, res) => {
  try {
    const campos = req.body;
    const [result] = await pool.query("UPDATE Turnos SET ? WHERE id_turno = ?", [campos, req.params.id_turno]);
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Turno no encontrado" });
    res.json({ message: "Turno actualizado parcialmente" });
  } catch (error) {
    return res.status(500).json({ message: "Error en actualización parcial de turno" });
  }
};
