import { pool } from "../../db_conection.js";

// Obtener todas las incidencias
export const obtenerIncidencias = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Incidencias");
    res.json(result);
  } catch (error) {
    return res.status(500).json({ message: "Error al obtener incidencias" });
  }
};

// Obtener una incidencia por ID
export const obtenerIncidencia = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Incidencias WHERE id_incidencia = ?", [req.params.id_incidencia]);
    if (result.length <= 0)
      return res.status(404).json({ message: "Incidencia no encontrada" });
    res.json(result[0]);
  } catch (error) {
    return res.status(500).json({ message: "Error al obtener incidencia" });
  }
};

// Crear nueva incidencia
export const crearIncidencia = async (req, res) => {
  try {
    const { id_empleado, fecha, descripcion, estado } = req.body;
    const [result] = await pool.query(
      "INSERT INTO Incidencias (id_empleado, fecha, descripcion, estado) VALUES (?, ?, ?, ?)",
      [id_empleado, fecha, descripcion, estado]
    );
    res.json({ id: result.insertId, id_empleado, fecha, descripcion, estado });
  } catch (error) {
    return res.status(500).json({ message: "Error al crear incidencia" });
  }
};

// Eliminar incidencia
export const eliminarIncidencia = async (req, res) => {
  try {
    const [result] = await pool.query("DELETE FROM Incidencias WHERE id_incidencia = ?", [req.params.id_incidencia]);
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Incidencia no encontrada" });
    res.json({ message: "Incidencia eliminada correctamente" });
  } catch (error) {
    return res.status(500).json({ message: "Error al eliminar incidencia" });
  }
};

// Actualizar incidencia (PUT)
export const actualizarIncidencia = async (req, res) => {
  try {
    const { id_empleado, fecha, descripcion, estado } = req.body;
    const [result] = await pool.query(
      "UPDATE Incidencias SET id_empleado = ?, fecha = ?, descripcion = ?, estado = ? WHERE id_incidencia = ?",
      [id_empleado, fecha, descripcion, estado, req.params.id_incidencia]
    );
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Incidencia no encontrada" });
    res.json({ message: "Incidencia actualizada correctamente" });
  } catch (error) {
    return res.status(500).json({ message: "Error al actualizar incidencia" });
  }
};

// Actualización parcial (PATCH)
export const patchIncidencia = async (req, res) => {
  try {
    const campos = req.body;
    const [result] = await pool.query("UPDATE Incidencias SET ? WHERE id_incidencia = ?", [campos, req.params.id_incidencia]);
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Incidencia no encontrada" });
    res.json({ message: "Incidencia actualizada parcialmente" });
  } catch (error) {
    return res.status(500).json({ message: "Error en actualización parcial de incidencia" });
  }
};
