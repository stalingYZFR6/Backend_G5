// Importar las dependencias necesarias
import express from 'express';
import cors from 'cors';

// Importar las rutas
import rutasEmpleados from './src/routes/empleado.routes.js';
import rutasAdministradores from './src/routes/administrador.routes.js';
import rutasTurnos from './src/routes/turnos.routes.js';
import rutasRegistroAsistencia from './src/routes/registroAsistencia.routes.js';
import rutasIncidencias from './src/routes/incidencias.routes.js';

// Crear la aplicación de Express
const app = express();

// Habilitar CORS para cualquier origen
app.use(cors({
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
  allowedHeaders: ['Content-Type'],
}));

// Middleware para parsear el cuerpo de las solicitudes
app.use(express.json({ limit: '10mb' })); // 10 MB
app.use(express.urlencoded({ limit: '10mb', extended: true }));

// Rutas
app.use('/api/empleados', rutasEmpleados);
app.use('/api/administradores', rutasAdministradores);
app.use('/api/turnos', rutasTurnos);
app.use('/api/registro-asistencia', rutasRegistroAsistencia);
app.use('/api/incidencias', rutasIncidencias);

// Manejo de rutas no encontradas
app.use((req, res, next) => {
  res.status(404).json({
    message: 'La ruta que ha especificado no se encuentra registrada.'
  });
});

// Exportar la aplicación
export default app;
