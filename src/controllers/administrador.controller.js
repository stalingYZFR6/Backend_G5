import { pool } from '../../db_conection.js';

// Obtener todos los administradores
export const obtenerAdministradores = async (req, res) => {
  try {
    const [result] = await pool.query(
      `SELECT a.id_administrador, e.nombre, e.apellido, e.cedula, a.login, a.ultima_actividad
       FROM Administrador a
       JOIN Empleado e ON a.id_empleado = e.id_empleado`
    );
    res.json(result);
  } catch (error) {
    res.status(500).json({ mensaje: 'Error al obtener administradores', error: error.message });
  }
};

// Crear un administrador
export const crearAdministrador = async (req, res) => {
  try {
    const { id_empleado, login, password } = req.body;
    const [result] = await pool.query(
      'INSERT INTO Administrador (id_empleado, login, password) VALUES (?, ?, ?)',
      [id_empleado, login, password]
    );
    res.json({ mensaje: 'Administrador creado', id: result.insertId });
  } catch (error) {
    res.status(500).json({ mensaje: 'Error al crear administrador', error: error.message });
  }
};
