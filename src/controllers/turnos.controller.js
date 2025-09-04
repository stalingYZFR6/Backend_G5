import { pool } from '../../db_conection.js';

// Obtener todos los turnos
export const obtenerTurnos = async (req, res) => {
  try {
    const [result] = await pool.query('SELECT * FROM Turnos');
    res.json(result);
  } catch (error) {
    res.status(500).json({ mensaje: 'Error al obtener turnos', error: error.message });
  }
};

// Crear un turno
export const crearTurno = async (req, res) => {
  try {
    const { id_empleado, fecha, hora_inicio, hora_fin, tipo_turno } = req.body;
    const [result] = await pool.query(
      'INSERT INTO Turnos (id_empleado, fecha, hora_inicio, hora_fin, tipo_turno) VALUES (?, ?, ?, ?, ?)',
      [id_empleado, fecha, hora_inicio, hora_fin, tipo_turno]
    );
    res.json({ mensaje: 'Turno creado', id: result.insertId });
  } catch (error) {
    res.status(500).json({ mensaje: 'Error al crear turno', error: error.message });
  }
};
