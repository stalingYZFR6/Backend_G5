import { Router } from 'express';
import { obtenerAdministradores, crearAdministrador } from '../controllers/administrador.controller.js';

const router = Router();

// Rutas
router.get('/', obtenerAdministradores);
router.post('/', crearAdministrador);

export default router;
