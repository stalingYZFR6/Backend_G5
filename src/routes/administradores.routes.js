import { Router } from "express";
import { 
  obtenerAdministradores, 
  obtenerAdministrador, 
  crearAdministrador, 
  eliminarAdministrador, 
  actualizarAdministrador, 
  patchAdministrador 
} from "../controllers/administradores.controllers.js";

const router = Router();

// Rutas de Administradores
router.get("/administradores", obtenerAdministradores);
router.get("/administradores/:id_admin", obtenerAdministrador);
router.post("/administradores", crearAdministrador);
router.delete("/administradores/:id_admin", eliminarAdministrador);
router.put("/administradores/:id_admin", actualizarAdministrador);
router.patch("/administradores/:id_admin", patchAdministrador);

export default router;
