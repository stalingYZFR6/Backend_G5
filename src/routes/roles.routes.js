import { Router } from "express";
import { 
  obtenerRoles, 
  obtenerRol, 
  crearRol, 
  eliminarRol, 
  actualizarRol, 
  patchRol 
} from "../controllers/roles.controllers.js";

const router = Router();

// Rutas de Roles
router.get("/roles", obtenerRoles);
router.get("/roles/:id_rol", obtenerRol);
router.post("/roles", crearRol);
router.delete("/roles/:id_rol", eliminarRol);
router.put("/roles/:id_rol", actualizarRol);
router.patch("/roles/:id_rol", patchRol);

export default router;
