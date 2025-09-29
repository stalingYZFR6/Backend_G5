import { pool } from "../../db_conection.js";

// Obtener todos los registros de bitácora
export const obtenerBitacora = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Bitacora");
    res.json(result);
  } catch (error) {
    return res.status(500).json({ message: "Error al obtener registros de bitácora" });
  }
};

// Obtener un registro de bitácora por ID
export const obtenerRegistroBitacora = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Bitacora WHERE id_bitacora = ?", [req.params.id_bitacora]);
    if (result.length <= 0)
      return res.status(404).json({ message: "Registro de bitácora no encontrado" });
    res.json(result[0]);
  } catch (error) {
    return res.status(500).json({ message: "Error al obtener registro de bitácora" });
  }
};

// Crear un nuevo registro de bitácora
export const crearRegistroBitacora = async (req, res) => {
  try {
    const { id_admin, fecha, accion, descripcion } = req.body;
    const [result] = await pool.query(
      "INSERT INTO Bitacora (id_admin, fecha, accion, descripcion) VALUES (?, ?, ?, ?)",
      [id_admin, fecha, accion, descripcion]
    );
    res.json({ id: result.insertId, id_admin, fecha, accion, descripcion });
  } catch (error) {
    return res.status(500).json({ message: "Error al crear registro de bitácora" });
  }
};

// Eliminar un registro de bitácora
export const eliminarRegistroBitacora = async (req, res) => {
  try {
    const [result] = await pool.query("DELETE FROM Bitacora WHERE id_bitacora = ?", [req.params.id_bitacora]);
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Registro de bitácora no encontrado" });
    res.json({ message: "Registro de bitácora eliminado correctamente" });
  } catch (error) {
    return res.status(500).json({ message: "Error al eliminar registro de bitácora" });
  }
};

// Actualizar un registro de bitácora (PUT)
export const actualizarRegistroBitacora = async (req, res) => {
  try {
    const { id_admin, fecha, accion, descripcion } = req.body;
    const [result] = await pool.query(
      "UPDATE Bitacora SET id_admin = ?, fecha = ?, accion = ?, descripcion = ? WHERE id_bitacora = ?",
      [id_admin, fecha, accion, descripcion, req.params.id_bitacora]
    );
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Registro de bitácora no encontrado" });
    res.json({ message: "Registro de bitácora actualizado correctamente" });
  } catch (error) {
    return res.status(500).json({ message: "Error al actualizar registro de bitácora" });
  }
};

// Actualización parcial (PATCH)
export const patchRegistroBitacora = async (req, res) => {
  try {
    const campos = req.body;
    const [result] = await pool.query("UPDATE Bitacora SET ? WHERE id_bitacora = ?", [campos, req.params.id_bitacora]);
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Registro de bitácora no encontrado" });
    res.json({ message: "Registro de bitácora actualizado parcialmente" });
  } catch (error) {
    return res.status(500).json({ message: "Error en actualización parcial de bitácora" });
  }
};
