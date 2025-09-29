import { pool } from "../../db_conection.js";

// Obtener todos los roles
export const obtenerRoles = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Roles");
    res.json(result);
  } catch (error) {
    return res.status(500).json({ message: "Error al obtener roles" });
  }
};

// Obtener un rol por ID
export const obtenerRol = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Roles WHERE id_rol = ?", [req.params.id_rol]);
    if (result.length <= 0)
      return res.status(404).json({ message: "Rol no encontrado" });
    res.json(result[0]);
  } catch (error) {
    return res.status(500).json({ message: "Error al obtener rol" });
  }
};

// Crear un nuevo rol
export const crearRol = async (req, res) => {
  try {
    const { nombre, descripcion } = req.body;
    const [result] = await pool.query(
      "INSERT INTO Roles (nombre, descripcion) VALUES (?, ?)",
      [nombre, descripcion]
    );
    res.json({ id: result.insertId, nombre, descripcion });
  } catch (error) {
    return res.status(500).json({ message: "Error al crear rol" });
  }
};

// Eliminar un rol
export const eliminarRol = async (req, res) => {
  try {
    const [result] = await pool.query("DELETE FROM Roles WHERE id_rol = ?", [req.params.id_rol]);
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Rol no encontrado" });
    res.json({ message: "Rol eliminado correctamente" });
  } catch (error) {
    return res.status(500).json({ message: "Error al eliminar rol" });
  }
};

// Actualizar un rol (PUT)
export const actualizarRol = async (req, res) => {
  try {
    const { nombre, descripcion } = req.body;
    const [result] = await pool.query(
      "UPDATE Roles SET nombre = ?, descripcion = ? WHERE id_rol = ?",
      [nombre, descripcion, req.params.id_rol]
    );
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Rol no encontrado" });
    res.json({ message: "Rol actualizado correctamente" });
  } catch (error) {
    return res.status(500).json({ message: "Error al actualizar rol" });
  }
};

// Actualización parcial (PATCH)
export const patchRol = async (req, res) => {
  try {
    const campos = req.body;
    const [result] = await pool.query("UPDATE Roles SET ? WHERE id_rol = ?", [campos, req.params.id_rol]);
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Rol no encontrado" });
    res.json({ message: "Rol actualizado parcialmente" });
  } catch (error) {
    return res.status(500).json({ message: "Error en actualización parcial de rol" });
  }
};
