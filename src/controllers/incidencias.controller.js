import { pool } from '../../db_conection.js';

// Obtener todas las incidencias
export const obtenerIncidencias = async (req, res) => {
  try {
    const [result] = await pool.query('SELECT * FROM Incidencias');
    res.json(result);
  } catch (error) {
    res.status(500).json({ mensaje: 'Error al obtener incidencias', error: error.message });
  }
};

// Crear una incidencia
export const crearIncidencia = async (req, res) => {
  try {
    const { id_empleado, tipo_incidencia, descripcion, fecha_incidencia } = req.body;
    const [result] = await pool.query(
      'INSERT INTO Incidencias (id_empleado, tipo_incidencia, descripcion, fecha_incidencia) VALUES (?, ?, ?, ?)',
      [id_empleado, tipo_incidencia, descripcion, fecha_incidencia]
    );
    res.json({ mensaje: 'Incidencia creada', id: result.insertId });
  } catch (error) {
    res.status(500).json({ mensaje: 'Error al crear incidencia', error: error.message });
  }
};
