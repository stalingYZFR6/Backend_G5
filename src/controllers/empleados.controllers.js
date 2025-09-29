import { pool } from "../../db_conection.js";

// Obtener todos los empleados
export const obtenerEmpleados = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Empleado");
    res.json(result);
  } catch (error) {
    return res.status(500).json({ message: "Error al obtener empleados" });
  }
};

// Obtener un empleado por ID
export const obtenerEmpleado = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Empleado WHERE id_empleado = ?", [req.params.id_empleado]);
    if (result.length <= 0)
      return res.status(404).json({ message: "Empleado no encontrado" });
    res.json(result[0]);
  } catch (error) {
    return res.status(500).json({ message: "Error al obtener empleado" });
  }
};

// Crear un nuevo empleado
export const crearEmpleado = async (req, res) => {
  try {
    const { nombre, apellido, cargo, fecha_ingreso, estado } = req.body;
    const [result] = await pool.query(
      "INSERT INTO Empleado (nombre, apellido, cargo, fecha_ingreso, estado) VALUES (?, ?, ?, ?, ?)",
      [nombre, apellido, cargo, fecha_ingreso, estado]
    );
    res.json({ id: result.insertId, nombre, apellido, cargo, fecha_ingreso, estado });
  } catch (error) {
    return res.status(500).json({ message: "Error al crear empleado" });
  }
};

// Eliminar un empleado por ID
export const eliminarEmpleado = async (req, res) => {
  try {
    const [result] = await pool.query("DELETE FROM Empleado WHERE id_empleado = ?", [req.params.id_empleado]);
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Empleado no encontrado" });
    res.json({ message: "Empleado eliminado correctamente" });
  } catch (error) {
    return res.status(500).json({ message: "Error al eliminar empleado" });
  }
};

// Actualizar un empleado (PUT → todos los campos)
export const actualizarEmpleado = async (req, res) => {
  try {
    const { nombre, apellido, cargo, fecha_ingreso, estado } = req.body;
    const [result] = await pool.query(
      "UPDATE Empleado SET nombre = ?, apellido = ?, cargo = ?, fecha_ingreso = ?, estado = ? WHERE id_empleado = ?",
      [nombre, apellido, cargo, fecha_ingreso, estado, req.params.id_empleado]
    );
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Empleado no encontrado" });
    res.json({ message: "Empleado actualizado correctamente" });
  } catch (error) {
    return res.status(500).json({ message: "Error al actualizar empleado" });
  }
};

// Actualizar parcialmente un empleado (PATCH)
export const patchEmpleado = async (req, res) => {
  try {
    const campos = req.body;
    const [result] = await pool.query("UPDATE Empleado SET ? WHERE id_empleado = ?", [campos, req.params.id_empleado]);
    if (result.affectedRows <= 0)
      return res.status(404).json({ message: "Empleado no encontrado" });
    res.json({ message: "Empleado actualizado parcialmente" });
  } catch (error) {
    return res.status(500).json({ message: "Error en actualización parcial de empleado" });
  }
};

