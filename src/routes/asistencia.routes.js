// routes/asistencia.routes.js
import { Router } from "express";
import {
  obtenerJornadas,
  crearJornada,
  obtenerDetalleJornada,
  marcarEntrada,
  marcarSalida,
  eliminarDetalle,
  eliminarJornada,
    cerrarJornada,
} from "../controllers/asistencia.controllers.js";

const router = Router();

// === JORNADAS (días) ===
router.get("/jornadas-asistencia", obtenerJornadas);           // Lista de días
router.post("/jornadas-asistencia", crearJornada);             // Crea jornada (normalmente hoy)

// === DETALLE (marcas de empleados en un día) ===
router.get("/detalle-asistencia/:id_jornada", obtenerDetalleJornada);

router.delete("/jornadas-asistencia/:id_jornada", eliminarJornada);

router.post("/marcar-entrada", marcarEntrada);                  // Marcar entrada ahora
router.put("/marcar-salida/:id_detalle", marcarSalida);         // Marcar salida ahora

router.delete("/detalle-asistencia/:id_detalle", eliminarDetalle);
router.put("/cerrar-jornada/:id_jornada", cerrarJornada);
export default router;