import { Router } from "express";
import { 
  obtenerBitacora, 
  obtenerRegistroBitacora, 
  crearRegistroBitacora, 
  eliminarRegistroBitacora, 
  actualizarRegistroBitacora, 
  patchRegistroBitacora 
} from "../controllers/bitacora.controllers.js";

const router = Router();

// Rutas de Bitácora
router.get("/bitacora", obtenerBitacora); // todos los registros
router.get("/bitacora/:id_bitacora", obtenerRegistroBitacora); // registro por ID
router.post("/bitacora", crearRegistroBitacora);
router.delete("/bitacora/:id_bitacora", eliminarRegistroBitacora);
router.put("/bitacora/:id_bitacora", actualizarRegistroBitacora);
router.patch("/bitacora/:id_bitacora", patchRegistroBitacora);

export default router;
