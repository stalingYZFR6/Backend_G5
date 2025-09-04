import { pool } from '../../db_conection.js';

// Obtener todos los empleados
export const obtenerEmpleados = async (req, res) => {
  try {
    const [result] = await pool.query('SELECT * FROM Empleado');
    res.json(result);
  } catch (error) {
    res.status(500).json({
      mensaje: 'Error al obtener empleados',
      error: error.message
    });
  }
};

// Crear un empleado
export const crearEmpleado = async (req, res) => {
  try {
    const { nombre, apellido, cedula, email, rol } = req.body;
    const [result] = await pool.query(
      'INSERT INTO Empleado (nombre, apellido, cedula, email, rol) VALUES (?, ?, ?, ?, ?)',
      [nombre, apellido, cedula, email, rol]
    );
    res.json({ mensaje: 'Empleado creado', id: result.insertId });
  } catch (error) {
    res.status(500).json({ mensaje: 'Error al crear empleado', error: error.message });
  }
};

