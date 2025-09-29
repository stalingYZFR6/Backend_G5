import { Router } from "express";
import { 
  obtenerIncidencias, 
  obtenerIncidencia, 
  crearIncidencia, 
  eliminarIncidencia, 
  actualizarIncidencia, 
  patchIncidencia 
} from "../controllers/incidencias.controllers.js";

const router = Router();

// Rutas de Incidencias
router.get("/incidencias", obtenerIncidencias);
router.get("/incidencias/:id_incidencia", obtenerIncidencia);
router.post("/incidencias", crearIncidencia);
router.delete("/incidencias/:id_incidencia", eliminarIncidencia);
router.put("/incidencias/:id_incidencia", actualizarIncidencia);
router.patch("/incidencias/:id_incidencia", patchIncidencia);

export default router;
