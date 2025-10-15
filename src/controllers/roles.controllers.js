import { pool } from "../../db_conection.js";

// Obtener todos los roles
export const obtenerRoles = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Rol");
    res.json(result);
  } catch (error) {
    console.error('Error en obtenerRoles:', error);
    return res.status(500).json({ message: "Error al obtener roles", error: error.message });
  }
};

// Obtener un rol por ID
export const obtenerRol = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Rol WHERE id_rol = ?", [req.params.id_rol]);
    if (result.length <= 0)
      return res.status(404).json({ message: "Rol no encontrado" });
    res.json(result[0]);
  } catch (error) {
    console.error('Error en obtenerRol:', error);
    return res.status(500).json({ message: "Error al obtener rol", error: error.message });
  }
};

// Crear un nuevo rol
export const crearRol = async (req, res) => {
  try {
    const { nombre } = req.body;
    const [result] = await pool.query("INSERT INTO Rol (nombre) VALUES (?)", [nombre]);
    res.json({ id_rol: result.insertId, nombre });
  } catch (error) {
    console.error('Error en crearRol:', error);
    return res.status(500).json({ message: "Error al crear rol", error: error.message });
  }
};

// Eliminar un rol
export const eliminarRol = async (req, res) => {
  try {
    const [result] = await pool.query("DELETE FROM Rol WHERE id_rol = ?", [req.params.id_rol]);
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Rol no encontrado" });
    res.json({ message: "Rol eliminado correctamente" });
  } catch (error) {
    console.error('Error en eliminarRol:', error);
    return res.status(500).json({ message: "Error al eliminar rol", error: error.message });
  }
};

// Actualizar un rol (PUT)
export const actualizarRol = async (req, res) => {
  try {
    const { nombre } = req.body;
    const [result] = await pool.query("UPDATE Rol SET nombre = ? WHERE id_rol = ?", [nombre, req.params.id_rol]);
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Rol no encontrado" });
    res.json({ message: "Rol actualizado correctamente" });
  } catch (error) {
    console.error('Error en actualizarRol:', error);
    return res.status(500).json({ message: "Error al actualizar rol", error: error.message });
  }
};

// Actualización parcial (PATCH)
export const patchRol = async (req, res) => {
  try {
    const campos = req.body;
    const [result] = await pool.query("UPDATE Rol SET ? WHERE id_rol = ?", [campos, req.params.id_rol]);
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Rol no encontrado" });
    res.json({ message: "Rol actualizado parcialmente" });
  } catch (error) {
    console.error('Error en patchRol:', error);
    return res.status(500).json({ message: "Error en actualización parcial de rol", error: error.message });
  }
};