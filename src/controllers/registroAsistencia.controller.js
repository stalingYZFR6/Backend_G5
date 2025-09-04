import { pool } from '../../db_conection.js';

// Obtener todos los registros de asistencia
export const obtenerRegistroAsistencia = async (req, res) => {
  try {
    const [result] = await pool.query('SELECT * FROM Registro_Asistencia');
    res.json(result);
  } catch (error) {
    res.status(500).json({ mensaje: 'Error al obtener registros', error: error.message });
  }
};

// Crear un registro de asistencia
export const crearRegistroAsistencia = async (req, res) => {
  try {
    const { id_empleado, id_turno, fecha, hora_entrada, hora_salida, horas_trabajadas } = req.body;
    const [result] = await pool.query(
      'INSERT INTO Registro_Asistencia (id_empleado, id_turno, fecha, hora_entrada, hora_salida, horas_trabajadas) VALUES (?, ?, ?, ?, ?, ?)',
      [id_empleado, id_turno, fecha, hora_entrada, hora_salida, horas_trabajadas]
    );
    res.json({ mensaje: 'Registro creado', id: result.insertId });
  } catch (error) {
    res.status(500).json({ mensaje: 'Error al crear registro', error: error.message });
  }
};
