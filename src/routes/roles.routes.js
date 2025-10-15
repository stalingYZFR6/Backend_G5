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
router.get("/rol", obtenerRoles);
router.get("/rol/:id_rol", obtenerRol);
router.post("/rol", crearRol);
router.delete("/rol/:id_rol", eliminarRol);
router.put("/rol/:id_rol", actualizarRol);
router.patch("/rol/:id_rol", patchRol);

export default router;
