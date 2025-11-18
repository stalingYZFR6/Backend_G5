import { pool } from "../../db_conection.js";


// Verificar usuario para login
export const verificarUsuario = async (req, res) => {
  try {
    const { usuario, contrasena } = req.body;

    if (!usuario || !contrasena) {
      return res.status(400).json({
        mensaje: "Debe enviar usuario y contrasena."
      });
    }

    const [result] = await pool.query(
      'SELECT * FROM Usuarios WHERE usuario = ? AND contraseña = ?',
      [usuario, contrasena]
    );

    if (result.length > 0) {
      return res.json(true);   // Usuario correcto
    } else {
      return res.json(false);  // Datos incorrectos
    }

  } catch (error) {
    return res.status(500).json({
      mensaje: 'Error al verificar el usuario.',
      error
    });
  }
};

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
    const { id_empleado, login, password, rol_aplicacion } = req.body;

    // Validar que el empleado exista
    const [empleado] = await pool.query("SELECT * FROM Empleado WHERE id_empleado = ?", [id_empleado]);
    if (empleado.length === 0) return res.status(400).json({ message: "Empleado no existe" });

    // Validar login único
    const [usuarioExistente] = await pool.query("SELECT * FROM Usuario WHERE login = ?", [login]);
    if (usuarioExistente.length > 0) return res.status(400).json({ message: "Login ya existe" });

    // Insertar usuario
    const [result] = await pool.query(
      "INSERT INTO Usuario (id_empleado, login, password, rol_aplicacion) VALUES (?, ?, ?, ?)",
      [id_empleado, login, password, rol_aplicacion || "cajero"]
    );

    res.status(201).json({ id: result.insertId, id_empleado, login, rol_aplicacion });
  } catch (error) {
    // Cambio aquí: mostrar el error real
    console.error(error);
    return res.status(500).json({ message: error.message, stack: error.stack });
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
    const { id_empleado, login, password, rol_aplicacion } = req.body;

    const [result] = await pool.query(
      `UPDATE Usuario 
       SET id_empleado = ?, login = ?, password = ?, rol_aplicacion = ? 
       WHERE id_usuario = ?`,
      [id_empleado, login, password, rol_aplicacion, req.params.id_usuario]
    );

    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Usuario no encontrado" });

    res.json({ message: "Usuario actualizado correctamente" });
  } catch (error) {
    console.error(error);
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
