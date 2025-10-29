import { pool } from "../../db_conection.js";

// Obtener todos los turnos
export const obtenerTurnos = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Turnos");
    res.json(result);
  } catch (error) {
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
    const { id_empleado, fecha, hora_inicio, hora_fin, tipo } = req.body;
    const [result] = await pool.query(
      "INSERT INTO Turnos (id_empleado, fecha, hora_inicio, hora_fin, tipo_turno) VALUES (?, ?, ?, ?, ?)",
      [id_empleado, fecha, hora_inicio, hora_fin, tipo]
    );
    res.json({ id: result.insertId, id_empleado, fecha, hora_inicio, hora_fin, tipo });
  } catch (error) {
    return res.status(500).json({ message: "Error al crear turno" });
  }
};

// Eliminar un turno
export const eliminarTurno = async (req, res) => {
  try {
    const [result] = await pool.query("DELETE FROM Turnos WHERE id_turno = ?", [req.params.id_turno]);
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Turno no encontrado" });
    res.json({ message: "Turno eliminado correctamente" });
  } catch (error) {
    return res.status(500).json({ message: "Error al eliminar turno" });
  }
};

// Actualizar un turno (PUT)
export const actualizarTurno = async (req, res) => {
  try {
    const { id_empleado, fecha, hora_inicio, hora_fin, tipo } = req.body;
    const [result] = await pool.query(
      "UPDATE Turnos SET id_empleado = ?, fecha = ?, hora_inicio = ?, hora_fin = ?, tipo_turno = ? WHERE id_turno = ?",
      [id_empleado, fecha, hora_inicio, hora_fin, tipo, req.params.id_turno]
    );
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Turno no encontrado" });
    res.json({ message: "Turno actualizado correctamente" });
  } catch (error) {
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
