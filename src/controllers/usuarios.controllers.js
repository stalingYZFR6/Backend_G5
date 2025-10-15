import { pool } from "../../db_conection.js";

// Obtener todos los usuarios
export const obtenerUsuarios = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Usuario");
    res.json(result);
  } catch (error) {
    return res.status(500).json({ message: "Error al obtener usuarios" });
  }
};

// Obtener un usuario por ID
export const obtenerUsuario = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Usuario WHERE id_usuario = ?", [req.params.id_usuario]);
    if (result.length <= 0)
      return res.status(404).json({ message: "Usuario no encontrado" });
    res.json(result[0]);
  } catch (error) {
    return res.status(500).json({ message: "Error al obtener usuario" });
  }
};

// Crear un nuevo usuario
export const crearUsuario = async (req, res) => {
  try {
    const { nombre, apellido, correo, contraseña, rol } = req.body;
    const [result] = await pool.query(
      "INSERT INTO Usuario (nombre, apellido, correo, contraseña, rol) VALUES (?, ?, ?, ?, ?)",
      [nombre, apellido, correo, contraseña, rol]
    );
    res.json({ id: result.insertId, nombre, apellido, correo, rol });
  } catch (error) {
    return res.status(500).json({ message: "Error al crear usuario" });
  }
};

// Eliminar un usuario
export const eliminarUsuario = async (req, res) => {
  try {
    const [result] = await pool.query("DELETE FROM Usuario WHERE id_usuario = ?", [req.params.id_usuario]);
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Usuario no encontrado" });
    res.json({ message: "Usuario eliminado correctamente" });
  } catch (error) {
    return res.status(500).json({ message: "Error al eliminar usuario" });
  }
};

// Actualizar un usuario (PUT)
export const actualizarUsuario = async (req, res) => {
  try {
    const { nombre, apellido, correo, contraseña, rol } = req.body;
    const [result] = await pool.query(
      "UPDATE Usuario SET nombre = ?, apellido = ?, correo = ?, contraseña = ?, rol = ? WHERE id_usuario = ?",
      [nombre, apellido, correo, contraseña, rol, req.params.id_usuario]
    );
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Usuario no encontrado" });
    res.json({ message: "Usuario actualizado correctamente" });
  } catch (error) {
    return res.status(500).json({ message: "Error al actualizar usuario" });
  }
};

// Actualización parcial (PATCH)
export const patchUsuario = async (req, res) => {
  try {
    const campos = req.body;
    const [result] = await pool.query("UPDATE Usuario SET ? WHERE id_usuario = ?", [campos, req.params.id_usuario]);
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Usuario no encontrado" });
    res.json({ message: "Usuario actualizado parcialmente" });
  } catch (error) {
    return res.status(500).json({ message: "Error en actualización parcial de usuario" });
  }
};
