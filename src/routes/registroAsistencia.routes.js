import { Router } from 'express';
import { obtenerRegistroAsistencia, crearRegistroAsistencia } from '../controllers/registroAsistencia.controller.js';

const router = Router();

router.get('/', obtenerRegistroAsistencia);
router.post('/', crearRegistroAsistencia);

export default router;
