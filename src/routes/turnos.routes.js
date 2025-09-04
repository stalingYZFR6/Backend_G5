import { Router } from 'express';
import { obtenerTurnos, crearTurno } from '../controllers/turnos.controller.js';

const router = Router();

router.get('/', obtenerTurnos);
router.post('/', crearTurno);

export default router;

