import { Router } from "express";
import { 
  obtenerTurnos, 
  obtenerTurno, 
  crearTurno, 
  eliminarTurno, 
  actualizarTurno, 
  patchTurno 
} from "../controllers/turnos.controllers.js";

const router = Router();

// Rutas de Turnos
router.get("/turnos", obtenerTurnos);
router.get("/turnos/:id_turno", obtenerTurno);
router.post("/turnos", crearTurno);
router.delete("/turnos/:id_turno", eliminarTurno);
router.put("/turnos/:id_turno", actualizarTurno);
router.patch("/turnos/:id_turno", patchTurno);

export default router;
