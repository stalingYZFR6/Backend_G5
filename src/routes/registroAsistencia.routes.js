import { Router } from "express";
import { 
  obtenerRegistrosAsistencia, 
  obtenerRegistroAsistencia, 
  crearRegistroAsistencia, 
  eliminarRegistroAsistencia, 
  actualizarRegistroAsistencia, 
  patchRegistroAsistencia 
} from "../controllers/registroAsistencia.controllers.js";


const router = Router();

// Rutas de Registro de Asistencia
router.get("/registroAsistencia", obtenerRegistrosAsistencia);
router.get("/registroAsistencia/:id_registro", obtenerRegistroAsistencia);
router.post("/registroAsistencia", crearRegistroAsistencia);
router.delete("/registroAsistencia/:id_registro", eliminarRegistroAsistencia);
router.put("/registroAsistencia/:id_registro", actualizarRegistroAsistencia);
router.patch("/registroAsistencia/:id_registro", patchRegistroAsistencia);

export default router;
