import { Router } from "express";
import { 
  obtenerUsuarios, 
  obtenerUsuario, 
  crearUsuario, 
  eliminarUsuario, 
  actualizarUsuario, 
  verificarUsuario,
  patchUsuario 
} from "../controllers/usuarios.controllers.js"; // controller en singular

const router = Router();

// Rutas de Usuarios (colección en plural)
router.get("/usuarios", obtenerUsuarios);                 // Obtener todos los usuarios
router.get("/usuarios/:id_usuario", obtenerUsuario);   // Obtener un usuario específico
router.post("/usuarios", crearUsuario);                  // Crear un nuevo usuario
router.delete("/usuarios/:id_usuario", eliminarUsuario); // Eliminar usuario
router.put("/usuarios/:id_usuario", actualizarUsuario);  // Actualizar usuario completo
router.patch("/usuarios/:id_usuario", patchUsuario);     // Actualización parcial
router.post('/verificarUsuario', verificarUsuario); // verificar usuario 

export default router;
