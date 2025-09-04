import { Router } from 'express';
import { obtenerIncidencias, crearIncidencia } from '../controllers/incidencias.controller.js';

const router = Router();

router.get('/', obtenerIncidencias);
router.post('/', crearIncidencia);

export default router;
