import { Router } from "express";

import { 
  obtenerEmpleados, 
  obtenerEmpleado, 
  crearEmpleado, 
  eliminarEmpleado, 
  actualizarEmpleado, 
  patchEmpleado 
} from "../controllers/empleados.controllers.js";

const router = Router();

// Rutas de empleados
router.get("/empleados", obtenerEmpleados);
router.get("/empleados/:id_empleado", obtenerEmpleado);
router.post("/empleados", crearEmpleado);
router.delete("/empleados/:id_empleado", eliminarEmpleado);
router.put("/empleados/:id_empleado", actualizarEmpleado);
router.patch("/empleados/:id_empleado", patchEmpleado);

export default router;
