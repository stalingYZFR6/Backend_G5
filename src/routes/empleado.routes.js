import { Router } from 'express';
import { obtenerEmpleados, crearEmpleado } from '../controllers/empleado.controller.js';

const router = Router();

router.get('/', obtenerEmpleados);
router.post('/', crearEmpleado);

export default router;
