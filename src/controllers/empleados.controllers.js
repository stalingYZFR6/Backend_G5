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
      const { nombre, apellido, cedula, correo, telefono, direccion, id_rol } = req.body;

      // Validaciones básicas
      if (!nombre || !apellido || !cedula || !id_rol) {
        return res.status(400).json({
          message: "Nombre, apellido, cédula y rol son obligatorios",
        });
      }

      // Insertar en la base de datos
      const [result] = await pool.query(
        `INSERT INTO Empleado 
          (nombre, apellido, cedula, correo, telefono, direccion, id_rol) 
        VALUES (?, ?, ?, ?, ?, ?, ?)`,
        [nombre, apellido, cedula, correo || null, telefono || null, direccion || null, id_rol]
      );

      res.status(201).json({
        message: "Empleado creado correctamente",
        empleado: { id: result.insertId, nombre, apellido, cedula, correo, telefono, direccion, id_rol },
      });
    } catch (error) {
      // Capturar errores de clave foránea o duplicados
      if (error.code === "ER_NO_REFERENCED_ROW_2") {
        return res.status(400).json({
          message: `El rol con id ${req.body.id_rol} no existe`,
        });
      }
      if (error.code === "ER_DUP_ENTRY") {
        return res.status(400).json({
          message: `Ya existe un empleado con la cédula ${req.body.cedula}`,
        });
      }

      // Otros errores
      console.error("Error al crear empleado:", error);
      return res.status(500).json({ message: "Error interno al crear empleado", error: error.message });
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

// Actualizar un empleado (PUT)
export const actualizarEmpleado = async (req, res) => {
  try {
    const { nombre, apellido, cedula, correo, telefono, direccion, id_rol } = req.body;

    const [result] = await pool.query(
      `UPDATE Empleado 
        SET nombre = ?, apellido = ?, cedula = ?, correo = ?, telefono = ?, direccion = ?, id_rol = ?
        WHERE id_empleado = ?`,
      [nombre, apellido, cedula, correo, telefono, direccion, id_rol, req.params.id_empleado]
    );

    if (result.affectedRows <= 0) {
      return res.status(404).json({ message: "Empleado no encontrado" });
    }

    res.json({ message: "Empleado actualizado correctamente" });
  } catch (error) {
    console.error("Error al actualizar empleado:", error);
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

