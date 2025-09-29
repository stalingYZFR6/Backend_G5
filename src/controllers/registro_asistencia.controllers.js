import { pool } from "../../db_conection.js";

// Obtener todos los registros de asistencia
export const obtenerRegistrosAsistencia = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Registro_Asistencia");
    res.json(result);
  } catch (error) {
    return res.status(500).json({ message: "Error al obtener registros de asistencia" });
  }
};

// Obtener un registro por ID
export const obtenerRegistroAsistencia = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Registro_Asistencia WHERE id_registro = ?", [req.params.id_registro]);
    if (result.length <= 0)
      return res.status(404).json({ message: "Registro de asistencia no encontrado" });
    res.json(result[0]);
  } catch (error) {
    return res.status(500).json({ message: "Error al obtener registro de asistencia" });
  }
};

// Crear un nuevo registro
export const crearRegistroAsistencia = async (req, res) => {
  try {
    const { id_empleado, fecha, hora_entrada, hora_salida } = req.body;
    const [result] = await pool.query(
      "INSERT INTO Registro_Asistencia (id_empleado, fecha, hora_entrada, hora_salida) VALUES (?, ?, ?, ?)",
      [id_empleado, fecha, hora_entrada, hora_salida]
    );
    res.json({ id: result.insertId, id_empleado, fecha, hora_entrada, hora_salida });
  } catch (error) {
    return res.status(500).json({ message: "Error al crear registro de asistencia" });
  }
};

// Eliminar un registro
export const eliminarRegistroAsistencia = async (req, res) => {
  try {
    const [result] = await pool.query("DELETE FROM Registro_Asistencia WHERE id_registro = ?", [req.params.id_registro]);
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Registro de asistencia no encontrado" });
    res.json({ message: "Registro de asistencia eliminado correctamente" });
  } catch (error) {
    return res.status(500).json({ message: "Error al eliminar registro de asistencia" });
  }
};

// Actualizar un registro (PUT)
export const actualizarRegistroAsistencia = async (req, res) => {
  try {
    const { id_empleado, fecha, hora_entrada, hora_salida } = req.body;
    const [result] = await pool.query(
      "UPDATE Registro_Asistencia SET id_empleado = ?, fecha = ?, hora_entrada = ?, hora_salida = ? WHERE id_registro = ?",
      [id_empleado, fecha, hora_entrada, hora_salida, req.params.id_registro]
    );
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Registro de asistencia no encontrado" });
    res.json({ message: "Registro de asistencia actualizado correctamente" });
  } catch (error) {
    return res.status(500).json({ message: "Error al actualizar registro de asistencia" });
  }
};

// Actualización parcial (PATCH)
export const patchRegistroAsistencia = async (req, res) => {
  try {
    const campos = req.body;
    const [result] = await pool.query("UPDATE Registro_Asistencia SET ? WHERE id_registro = ?", [campos, req.params.id_registro]);
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Registro de asistencia no encontrado" });
    res.json({ message: "Registro de asistencia actualizado parcialmente" });
  } catch (error) {
    return res.status(500).json({ message: "Error en actualización parcial de registro de asistencia" });
  }
};
