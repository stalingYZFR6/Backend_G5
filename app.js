// Importar las dependencias necesarias
import express from "express";
import cors from "cors";

// Importar las rutas
import rutasEmpleados from "./src/routes/empleados.routes.js";
import rutasRoles from "./src/routes/roles.routes.js";
import rutasTurnos from "./src/routes/turnos.routes.js";
import rutasRegistroAsistencia from "./src/routes/registroAsistencia.routes.js";
import rutasIncidencias from "./src/routes/incidencias.routes.js";
import rutasBitacora from "./src/routes/bitacora.routes.js";
import rutasUsuarios from "./src/routes/usuarios.routes.js";
import rutasAsistencia from "./src/routes/asistencia.routes.js";  // ← AÑADE ESTO


// Crear la aplicación de Express
const app = express();

// Habilitar CORS
app.use(
  cors({
    methods: ["GET", "POST", "PUT", "DELETE", "PATCH"],
    allowedHeaders: ["Content-Type"],
  })
);

// Middleware
app.use(express.json({ limit: "10mb" }));
app.use(express.urlencoded({ limit: "10mb", extended: true }));

// Rutas
app.use("/api", rutasEmpleados);
app.use("/api", rutasRoles);
app.use("/api", rutasTurnos);
app.use("/api", rutasRegistroAsistencia);
app.use("/api", rutasIncidencias);
app.use("/api", rutasBitacora);
app.use("/api", rutasUsuarios);
app.use("/api", rutasAsistencia); 


// Manejo de rutas no encontradas
app.use((req, res, next) => {
  res.status(404).json({
    message: "La ruta que ha especificado no se encuentra registrada.",
  });
});

export default app;