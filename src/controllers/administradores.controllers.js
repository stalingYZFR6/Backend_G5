import { pool } from "../../db_conection.js";

// Obtener todos los administradores
export const obtenerAdministradores = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Administrador");
    res.json(result);
  } catch (error) {
    return res.status(500).json({ message: "Error al obtener administradores" });
  }
};

// Obtener un administrador por ID
export const obtenerAdministrador = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Administrador WHERE id_admin = ?", [req.params.id_admin]);
    if (result.length <= 0)
      return res.status(404).json({ message: "Administrador no encontrado" });
    res.json(result[0]);
  } catch (error) {
    return res.status(500).json({ message: "Error al obtener administrador" });
  }
};

// Crear nuevo administrador
export const crearAdministrador = async (req, res) => {
  try {
    const { nombre, usuario, contrasena } = req.body;
    const [result] = await pool.query(
      "INSERT INTO Administrador (nombre, usuario, contrasena) VALUES (?, ?, ?)",
      [nombre, usuario, contrasena]
    );
    res.json({ id: result.insertId, nombre, usuario });
  } catch (error) {
    return res.status(500).json({ message: "Error al crear administrador" });
  }
};

// Eliminar administrador
export const eliminarAdministrador = async (req, res) => {
  try {
    const [result] = await pool.query("DELETE FROM Administrador WHERE id_admin = ?", [req.params.id_admin]);
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Administrador no encontrado" });
    res.json({ message: "Administrador eliminado correctamente" });
  } catch (error) {
    return res.status(500).json({ message: "Error al eliminar administrador" });
  }
};

// Actualizar administrador (PUT)
export const actualizarAdministrador = async (req, res) => {
  try {
    const { nombre, usuario, contrasena } = req.body;
    const [result] = await pool.query(
      "UPDATE Administrador SET nombre = ?, usuario = ?, contrasena = ? WHERE id_admin = ?",
      [nombre, usuario, contrasena, req.params.id_admin]
    );
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Administrador no encontrado" });
    res.json({ message: "Administrador actualizado correctamente" });
  } catch (error) {
    return res.status(500).json({ message: "Error al actualizar administrador" });
  }
};

// Actualización parcial (PATCH)
export const patchAdministrador = async (req, res) => {
  try {
    const campos = req.body;
    const [result] = await pool.query("UPDATE Administrador SET ? WHERE id_admin = ?", [campos, req.params.id_admin]);
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Administrador no encontrado" });
    res.json({ message: "Administrador actualizado parcialmente" });
  } catch (error) {
    return res.status(500).json({ message: "Error en actualización parcial de administrador" });
  }
};
