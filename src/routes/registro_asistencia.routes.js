import { Router } from "express";
import { 
  obtenerRegistrosAsistencia, 
  obtenerRegistroAsistencia, 
  crearRegistroAsistencia, 
  eliminarRegistroAsistencia, 
  actualizarRegistroAsistencia, 
  patchRegistroAsistencia 
} from "../controllers/registro_asistencia.controllers.js";


const router = Router();

// Rutas de Registro de Asistencia
router.get("/registro_asistencia", obtenerRegistrosAsistencia);
router.get("/registro_asistencia/:id_registro", obtenerRegistroAsistencia);
router.post("/registro_asistencia", crearRegistroAsistencia);
router.delete("/registro_asistencia/:id_registro", eliminarRegistroAsistencia);
router.put("/registro_asistencia/:id_registro", actualizarRegistroAsistencia);
router.patch("/registro_asistencia/:id_registro", patchRegistroAsistencia);

export default router;
