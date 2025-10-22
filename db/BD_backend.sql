-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS BD_backend;
USE BD_backend;

-- Verificar la versión de MySQL
SELECT VERSION();

-- Crear tabla Rol
CREATE TABLE Rol (
    id_rol INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(25) NOT NULL UNIQUE
);

-- Crear tabla Empleado
CREATE TABLE Empleado (
    id_empleado INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    cedula VARCHAR(18) NOT NULL UNIQUE,
    correo VARCHAR(100),
    telefono VARCHAR(12),
    direccion VARCHAR(90),
    id_rol INT NOT NULL,
    FOREIGN KEY (id_rol) REFERENCES Rol(id_rol)
);

-- Crear tabla Usuario
CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    id_empleado INT NOT NULL UNIQUE,
    login VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(256) NOT NULL,
    rol_aplicacion ENUM('cajero', 'admin', 'supervisor') NOT NULL DEFAULT 'cajero',
    ultima_actividad DATETIME,
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

-- Crear tabla Turnos
CREATE TABLE Turnos (
    id_turno INT PRIMARY KEY AUTO_INCREMENT,
    id_empleado INT NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    tipo_turno VARCHAR(20) NOT NULL CHECK (tipo_turno IN ('mañana', 'tarde', 'noche', 'flexible')),
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

RENAME TABLE Registro_Asistencia TO RegistroAsistencia;


-- Crear tabla Registro_Asistencia
CREATE TABLE RegistroAsistencia (
    id_registro INT PRIMARY KEY AUTO_INCREMENT,
    id_empleado INT NOT NULL,
    id_turno INT NOT NULL,
    fecha DATE NOT NULL,
    hora_entrada TIME,
    hora_salida TIME,
    horas_trabajadas FLOAT,
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado),
    FOREIGN KEY (id_turno) REFERENCES Turnos(id_turno)
);

-- Crear tabla Incidencias
CREATE TABLE Incidencias (
    id_incidencia INT PRIMARY KEY AUTO_INCREMENT,
    id_empleado INT NOT NULL,
    tipo_incidencia VARCHAR(50) NOT NULL CHECK (tipo_incidencia IN ('retraso', 'ausencia', 'permiso', 'otro')),
    descripcion TEXT,
    fecha_incidencia DATE NOT NULL,
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

-- Crear tabla Bitacora
CREATE TABLE Bitacora (
    id_bitacora INT AUTO_INCREMENT PRIMARY KEY,
    tabla_afectada VARCHAR(50) NOT NULL,
    tipo_cambio VARCHAR(20) NOT NULL,
    usuario VARCHAR(50) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    detalles TEXT,
    CONSTRAINT chk_tipo_cambio CHECK (tipo_cambio IN ('INSERT', 'UPDATE', 'DELETE'))
);

-- Crear índices para mejorar rendimiento
CREATE INDEX idx_registro_asistencia_fecha ON Registro_Asistencia(fecha);
CREATE INDEX idx_registro_asistencia_id_empleado ON Registro_Asistencia(id_empleado);
CREATE INDEX idx_incidencias_id_empleado ON Incidencias(id_empleado);
CREATE INDEX idx_turnos_id_empleado ON Turnos(id_empleado);

-- Crear usuarios con privilegios
CREATE USER IF NOT EXISTS 'gerson'@'localhost' IDENTIFIED BY 'gerson123';
GRANT ALL PRIVILEGES ON BD_backend.* TO 'gerson'@'localhost';

CREATE USER IF NOT EXISTS 'staling'@'localhost' IDENTIFIED BY 'staling123';
GRANT SELECT, INSERT, UPDATE ON BD_backend.* TO 'staling'@'localhost';

CREATE USER IF NOT EXISTS 'magdi'@'localhost' IDENTIFIED BY 'magdi123';
GRANT SELECT ON BD_backend.* TO 'magdi'@'localhost';

-- Aplicar cambios de privilegios
FLUSH PRIVILEGES;

-- Crear roles y asignar privilegios
CREATE ROLE 'admin', 'cajero', 'supervisor';
GRANT ALL PRIVILEGES ON *.* TO 'admin';
GRANT SELECT, INSERT, UPDATE ON BD_backend.* TO 'cajero';
GRANT SELECT, UPDATE ON BD_backend.Turnos TO 'supervisor';

-- Asignar roles a usuarios
GRANT 'admin' TO 'gerson'@'localhost';
SET DEFAULT ROLE 'admin' FOR 'gerson'@'localhost';

GRANT 'cajero' TO 'staling'@'localhost';
SET DEFAULT ROLE 'cajero' FOR 'staling'@'localhost';

GRANT 'supervisor' TO 'magdi'@'localhost';
SET DEFAULT ROLE 'supervisor' FOR 'magdi'@'localhost';

-- Aplicar cambios de privilegios
FLUSH PRIVILEGES;

-- Insertar roles posibles
INSERT INTO Rol (nombre) VALUES
    ('cajero'),
    ('admin'),
    ('supervisor');

-- Inserciones en Empleado
INSERT INTO Empleado (nombre, apellido, cedula, correo, telefono, direccion, id_rol) VALUES
    ('Gerson', 'Pérez', '12345678', 'gerson.perez@empresa.com', '123-456-7890', 'Calle 1, Ciudad A', 2),
    ('Staling', 'Gómez', '87654321', 'staling.gomez@empresa.com', '234-567-8901', 'Avenida 2, Ciudad B', 1),
    ('Magdi', 'López', '11223344', 'magdi.lopez@empresa.com', '345-678-9012', 'Calle 3, Ciudad C', 3),
    ('Ana', 'Martínez', '44332211', 'ana.martinez@empresa.com', '456-789-0123', 'Avenida 4, Ciudad D', 1),
    ('Luis', 'Rodríguez', '55667788', 'luis.rodriguez@empresa.com', '567-890-1234', 'Calle 5, Ciudad E', 1),
    ('Diego', 'Fernández', '66778899', 'diego.fernandez@empresa.com', '678-901-2345', 'Calle 6, Ciudad F', 3);

-- Inserciones en Usuario
INSERT INTO Usuario (id_empleado, login, password, rol_aplicacion, ultima_actividad) VALUES
    (1, 'gerson', ('gerson123'), 'admin', NOW()),
    (2, 'staling', ('staling123'), 'cajero', NOW()),
    (3, 'magdi', ('magdi123'), 'supervisor', NOW());
-- Borrar un usuario por su id_usuario
DELETE  FROM Usuario;
TRUNCATE TABLE Usuario;


-- Inserciones en Turnos
INSERT INTO Turnos (id_empleado, fecha, hora_inicio, hora_fin, tipo_turno) VALUES
    (1, '2025-04-09', '08:00:00', '12:00:00', 'mañana'),
    (2, '2025-04-09', '14:00:00', '18:00:00', 'tarde'),
    (3, '2025-04-09', '20:00:00', '00:00:00', 'noche'),
    (4, '2025-04-10', '09:00:00', '17:00:00', 'flexible'),
    (5, '2025-04-10', '08:00:00', '12:00:00', 'mañana'),
    (6, '2025-04-11', '08:00:00', '16:00:00', 'flexible');

-- Inserciones en Registro_Asistencia
INSERT INTO Registro_Asistencia (id_empleado, id_turno, fecha, hora_entrada, hora_salida, horas_trabajadas) VALUES
    (1, 1, '2025-04-09', '08:05:00', '12:00:00', 3.92),
    (2, 2, '2025-04-09', '14:00:00', '18:10:00', 4.17),
    (3, 3, '2025-04-09', '20:00:00', '23:55:00', 3.92),
    (4, 4, '2025-04-10', '09:10:00', '17:00:00', 7.83),
    (5, 5, '2025-04-10', '08:00:00', '12:05:00', 4.08),
    (6, 6, '2025-04-11', '08:05:00', '16:00:00', 7.92);

-- Inserciones en Incidencias
INSERT INTO Incidencias (id_empleado, tipo_incidencia, descripcion, fecha_incidencia) VALUES
    (1, 'retraso', 'Llegó 5 minutos tarde por tráfico', '2025-04-09'),
    (2, 'permiso', 'Cita médica programada', '2025-04-09'),
    (3, 'ausencia', 'No se presentó sin aviso', '2025-04-09'),
    (4, 'retraso', 'Retraso de 10 minutos por lluvia', '2025-04-10'),
    (5, 'otro', 'Equipo dañado reportado', '2025-04-10'),
    (6, 'permiso', 'Asistencia a curso de capacitación', '2025-04-11');

-- Triggers para Usuario
DELIMITER //
CREATE TRIGGER trg_usuario_insert
AFTER INSERT ON Usuario
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, tipo_cambio, usuario, detalles)
    VALUES ('Usuario', 'INSERT', USER(), CONCAT('Se insertó el usuario con id_usuario=', NEW.id_usuario));
END;
//

CREATE TRIGGER trg_usuario_update
AFTER UPDATE ON Usuario
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, tipo_cambio, usuario, detalles)
    VALUES ('Usuario', 'UPDATE', USER(), CONCAT('Se actualizó el usuario con id_usuario=', NEW.id_usuario));
END;
//

CREATE TRIGGER trg_usuario_delete
AFTER DELETE ON Usuario
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, tipo_cambio, usuario, detalles)
    VALUES ('Usuario', 'DELETE', USER(), CONCAT('Se eliminó el usuario con id_usuario=', OLD.id_usuario));
END;
//
DELIMITER ;

-- Triggers para Empleado
DELIMITER //
CREATE TRIGGER trg_empleado_insert
AFTER INSERT ON Empleado
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, tipo_cambio, usuario, detalles)
    VALUES ('Empleado', 'INSERT', USER(), 'Se insertó un empleado');
END;
//

CREATE TRIGGER trg_empleado_update
AFTER UPDATE ON Empleado
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, tipo_cambio, usuario, detalles)
    VALUES ('Empleado', 'UPDATE', USER(), 'Se actualizó un empleado');
END;
//

CREATE TRIGGER trg_empleado_delete
AFTER DELETE ON Empleado
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, tipo_cambio, usuario, detalles)
    VALUES ('Empleado', 'DELETE', USER(), 'Se eliminó un empleado');
END;
//
DELIMITER ;

-- Triggers para Turnos
DELIMITER //
CREATE TRIGGER trg_turnos_insert
AFTER INSERT ON Turnos
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, tipo_cambio, usuario, detalles)
    VALUES ('Turnos', 'INSERT', USER(), 'Se insertó un turno');
END;
//

CREATE TRIGGER trg_turnos_update
AFTER UPDATE ON Turnos
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, tipo_cambio, usuario, detalles)
    VALUES ('Turnos', 'UPDATE', USER(), 'Se actualizó un turno');
END;
//

CREATE TRIGGER trg_turnos_delete
AFTER DELETE ON Turnos
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, tipo_cambio, usuario, detalles)
    VALUES ('Turnos', 'DELETE', USER(), 'Se eliminó un turno');
END;
//
DELIMITER ;

-- Triggers para RegistroAsistencia
DELIMITER //
CREATE TRIGGER trg_registro_asistencia_insert
AFTER INSERT ON RegistroAsistencia
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, tipo_cambio, usuario, detalles)
    VALUES ('Registro_Asistencia', 'INSERT', USER(), 'Se insertó un registro de asistencia');
END;
//

CREATE TRIGGER trg_registro_asistencia_update
AFTER UPDATE ON RegistroAsistencia
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, tipo_cambio, usuario, detalles)
    VALUES ('Registro_Asistencia', 'UPDATE', USER(), 'Se actualizó un registro de asistencia');
END;
//

CREATE TRIGGER trg_registro_asistencia_delete
AFTER DELETE ON RegistroAsistencia
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, tipo_cambio, usuario, detalles)
    VALUES ('Registro_Asistencia', 'DELETE', USER(), 'Se eliminó un registro de asistencia');
END;
//
DELIMITER ;

-- Triggers para Incidencias
DELIMITER //
CREATE TRIGGER trg_incidencias_insert
AFTER INSERT ON Incidencias
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, tipo_cambio, usuario, detalles)
    VALUES ('Incidencias', 'INSERT', USER(), 'Se insertó una incidencia');
END;
//

CREATE TRIGGER trg_incidencias_update
AFTER UPDATE ON Incidencias
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, tipo_cambio, usuario, detalles)
    VALUES ('Incidencias', 'UPDATE', USER(), 'Se actualizó una incidencia');
END;
//

CREATE TRIGGER trg_incidencias_delete
AFTER DELETE ON Incidencias
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, tipo_cambio, usuario, detalles)
    VALUES ('Incidencias', 'DELETE', USER(), 'Se eliminó una incidencia');
END;
//
DELIMITER ;

-- Vista 1: Lista de empleados con sus turnos asignados
CREATE VIEW Vista_Turnos_Empleados AS
SELECT 
    e.nombre, 
    e.apellido, 
    e.cedula, 
    e.correo,
    e.telefono,
    e.direccion,
    t.fecha, 
    t.tipo_turno, 
    t.hora_inicio, 
    t.hora_fin
FROM 
    Empleado e
LEFT JOIN 
    Turnos t ON e.id_empleado = t.id_empleado
ORDER BY 
    e.apellido, e.nombre, t.fecha;

-- Vista 2: Horas trabajadas por empleado en un mes
CREATE VIEW Vista_Horas_Trabajadas_Mes AS
SELECT 
    e.nombre, 
    e.apellido, 
    SUM(ra.horas_trabajadas) AS total_horas
FROM 
    Empleado e
LEFT JOIN 
    Registro_Asistencia ra ON e.id_empleado = ra.id_empleado
WHERE 
    ra.fecha BETWEEN '2025-04-01' AND '2025-04-30'
GROUP BY 
    e.id_empleado, e.nombre, e.apellido
ORDER BY 
    e.apellido, e.nombre;

-- Vista 3: Incidencias por empleado
CREATE VIEW Vista_Incidencias_Empleados AS
SELECT 
    e.nombre, 
    e.apellido, 
    i.tipo_incidencia, 
    i.fecha_incidencia, 
    i.descripcion
FROM 
    Empleado e
LEFT JOIN 
    Incidencias i ON e.id_empleado = i.id_empleado
ORDER BY 
    e.apellido, e.nombre, i.fecha_incidencia;

-- Vista 4: Usuarios y su última actividad (modificada para usar la tabla Usuario)
CREATE VIEW Vista_Actividad_Usuarios AS
SELECT 
    e.nombre, 
    e.apellido, 
    u.login, 
    u.ultima_actividad
FROM 
    Empleado e
INNER JOIN 
    Usuario u ON e.id_empleado = u.id_empleado
INNER JOIN
    Rol r ON e.id_rol = r.id_rol
WHERE 
    r.nombre = 'admin'
ORDER BY 
    u.ultima_actividad DESC;

-- Vista 5: Resumen de asistencia diaria
CREATE VIEW Vista_Resumen_Asistencia_Diaria AS
SELECT
    e.nombre,
    e.apellido,
    ra.fecha,
    ra.hora_entrada,
    ra.hora_salida,
    ra.horas_trabajadas,
    CASE
        WHEN ra.hora_entrada IS NOT NULL AND ra.hora_salida IS NOT NULL THEN 'Completo'
        WHEN ra.hora_entrada IS NULL AND ra.hora_salida IS NULL THEN 'Sin registro'
        ELSE 'Incompleto'
    END AS estado_asistencia
FROM
    Empleado e
LEFT JOIN
    Registro_Asistencia ra ON e.id_empleado = ra.id_empleado
ORDER BY
    ra.fecha DESC, e.apellido, e.nombre;

-- Vista 6: Empleados con más de una incidencia registrada
CREATE VIEW Vista_Empleados_Con_Multiples_Incidencias AS
SELECT 
    e.nombre,
    e.apellido,
    COUNT(i.id_incidencia) AS cantidad_incidencias
FROM 
    Empleado e
JOIN 
    Incidencias i ON e.id_empleado = i.id_empleado
GROUP BY 
    e.id_empleado
HAVING 
    COUNT(i.id_incidencia) > 1;

-- Vista 7: Cantidad de turnos agrupados por tipo
CREATE VIEW Vista_Turnos_Por_Tipo AS
SELECT 
    tipo_turno,
    COUNT(*) AS cantidad_turnos
FROM 
    Turnos
GROUP BY 
    tipo_turno;

-- Vista 8: Empleados con asistencia pendiente
CREATE VIEW Vista_Asistencias_Pendientes AS
SELECT 
    e.nombre,
    e.apellido,
    ra.fecha,
    ra.hora_entrada,
    ra.hora_salida,
    CASE 
        WHEN ra.hora_entrada IS NULL THEN 'Falta hora entrada'
        WHEN ra.hora_salida IS NULL THEN 'Falta hora salida'
        ELSE 'Sin asistencia'
    END AS observacion
FROM 
    Empleado e
LEFT JOIN 
    Registro_Asistencia ra ON e.id_empleado = ra.id_empleado
WHERE 
    ra.hora_entrada IS NULL OR ra.hora_salida IS NULL;

-- Vista 9: Cantidad de días que cada empleado ha trabajado
CREATE VIEW Vista_Dias_Trabajados AS
SELECT 
    e.nombre,
    e.apellido,
    COUNT(DISTINCT ra.fecha) AS dias_trabajados
FROM 
    Empleado e
JOIN 
    Registro_Asistencia ra ON e.id_empleado = ra.id_empleado
GROUP BY 
    e.id_empleado;

DELIMITER //

-- =========================
-- Tabla Rol
-- =========================

CREATE PROCEDURE InsertarRol(IN p_nombre VARCHAR(25))
BEGIN
    INSERT INTO Rol(nombre) VALUES(p_nombre);
END;
//

CREATE PROCEDURE ActualizarRol(IN p_id_rol INT, IN p_nombre VARCHAR(25))
BEGIN
    UPDATE Rol SET nombre = p_nombre WHERE id_rol = p_id_rol;
END;
//

CREATE PROCEDURE EliminarRol(IN p_id_rol INT)
BEGIN
    DELETE FROM Rol WHERE id_rol = p_id_rol;
END;
//

-- =========================
-- Tabla Empleado
-- =========================

CREATE PROCEDURE InsertarEmpleado(
    IN p_nombre VARCHAR(50),
    IN p_apellido VARCHAR(50),
    IN p_cedula VARCHAR(18),
    IN p_correo VARCHAR(100),
    IN p_telefono VARCHAR(12),
    IN p_direccion VARCHAR(90),
    IN p_id_rol INT
)
BEGIN
    INSERT INTO Empleado(nombre, apellido, cedula, correo, telefono, direccion, id_rol)
    VALUES(p_nombre, p_apellido, p_cedula, p_correo, p_telefono, p_direccion, p_id_rol);
END;
//

CREATE PROCEDURE ActualizarEmpleado(
    IN p_id_empleado INT,
    IN p_nombre VARCHAR(50),
    IN p_apellido VARCHAR(50),
    IN p_correo VARCHAR(100),
    IN p_telefono VARCHAR(12),
    IN p_direccion VARCHAR(90),
    IN p_id_rol INT
)
BEGIN
    UPDATE Empleado
    SET nombre = p_nombre,
        apellido = p_apellido,
        correo = p_correo,
        telefono = p_telefono,
        direccion = p_direccion,
        id_rol = p_id_rol
    WHERE id_empleado = p_id_empleado;
END;
//

CREATE PROCEDURE EliminarEmpleado(IN p_id_empleado INT)
BEGIN
    DELETE FROM Empleado WHERE id_empleado = p_id_empleado;
END;
//

-- =========================
-- Tabla Usuario
-- =========================

CREATE PROCEDURE InsertarUsuario(
    IN p_id_empleado INT,
    IN p_login VARCHAR(50),
    IN p_password VARCHAR(256),
    IN p_rol_aplicacion ENUM('cajero','admin','supervisor')
)
BEGIN
    INSERT INTO Usuario(id_empleado, login, password, rol_aplicacion, ultima_actividad)
    VALUES(p_id_empleado, p_login, SHA2(p_password, 256), p_rol_aplicacion, NOW());
END;
//

CREATE PROCEDURE ActualizarUsuario(
    IN p_id_usuario INT,
    IN p_login VARCHAR(50),
    IN p_password VARCHAR(256),
    IN p_rol_aplicacion ENUM('cajero','admin','supervisor')
)
BEGIN
    UPDATE Usuario
    SET login = p_login,
        password = SHA2(p_password, 256),
        rol_aplicacion = p_rol_aplicacion,
        ultima_actividad = NOW()
    WHERE id_usuario = p_id_usuario;
END;
//

CREATE PROCEDURE EliminarUsuario(IN p_id_usuario INT)
BEGIN
    DELETE FROM Usuario WHERE id_usuario = p_id_usuario;
END;
//

-- =========================
-- Tabla Turnos
-- =========================

CREATE PROCEDURE InsertarTurno(
    IN p_id_empleado INT,
    IN p_fecha DATE,
    IN p_hora_inicio TIME,
    IN p_hora_fin TIME,
    IN p_tipo_turno VARCHAR(20)
)
BEGIN
    INSERT INTO Turnos(id_empleado, fecha, hora_inicio, hora_fin, tipo_turno)
    VALUES(p_id_empleado, p_fecha, p_hora_inicio, p_hora_fin, p_tipo_turno);
END;
//

CREATE PROCEDURE ActualizarTurno(
    IN p_id_turno INT,
    IN p_id_empleado INT,
    IN p_fecha DATE,
    IN p_hora_inicio TIME,
    IN p_hora_fin TIME,
    IN p_tipo_turno VARCHAR(20)
)
BEGIN
    UPDATE Turnos
    SET id_empleado = p_id_empleado,
        fecha = p_fecha,
        hora_inicio = p_hora_inicio,
        hora_fin = p_hora_fin,
        tipo_turno = p_tipo_turno
    WHERE id_turno = p_id_turno;
END;
//

CREATE PROCEDURE EliminarTurno(IN p_id_turno INT)
BEGIN
    DELETE FROM Turnos WHERE id_turno = p_id_turno;
END;
//

-- =========================
-- Tabla RegistroAsistencia
-- =========================

CREATE PROCEDURE InsertarRegistroAsistencia(
    IN p_id_empleado INT,
    IN p_id_turno INT,
    IN p_fecha DATE,
    IN p_hora_entrada TIME,
    IN p_hora_salida TIME,
    IN p_horas_trabajadas FLOAT
)
BEGIN
    INSERT INTO RegistroAsistencia(id_empleado, id_turno, fecha, hora_entrada, hora_salida, horas_trabajadas)
    VALUES(p_id_empleado, p_id_turno, p_fecha, p_hora_entrada, p_hora_salida, p_horas_trabajadas);
END;
//

CREATE PROCEDURE ActualizarRegistroAsistencia(
    IN p_id_registro INT,
    IN p_hora_entrada TIME,
    IN p_hora_salida TIME,
    IN p_horas_trabajadas FLOAT
)
BEGIN
    UPDATE RegistroAsistencia
    SET hora_entrada = p_hora_entrada,
        hora_salida = p_hora_salida,
        horas_trabajadas = p_horas_trabajadas
    WHERE id_registro = p_id_registro;
END;
//

CREATE PROCEDURE EliminarRegistroAsistencia(IN p_id_registro INT)
BEGIN
    DELETE FROM RegistroAsistencia WHERE id_registro = p_id_registro;
END;
//

-- =========================
-- Tabla Incidencias
-- =========================

CREATE PROCEDURE InsertarIncidencia(
    IN p_id_empleado INT,
    IN p_tipo_incidencia VARCHAR(50),
    IN p_descripcion TEXT,
    IN p_fecha_incidencia DATE
)
BEGIN
    INSERT INTO Incidencias(id_empleado, tipo_incidencia, descripcion, fecha_incidencia)
    VALUES(p_id_empleado, p_tipo_incidencia, p_descripcion, p_fecha_incidencia);
END;
//

CREATE PROCEDURE ActualizarIncidencia(
    IN p_id_incidencia INT,
    IN p_tipo_incidencia VARCHAR(50),
    IN p_descripcion TEXT,
    IN p_fecha_incidencia DATE
)
BEGIN
    UPDATE Incidencias
    SET tipo_incidencia = p_tipo_incidencia,
        descripcion = p_descripcion,
        fecha_incidencia = p_fecha_incidencia
    WHERE id_incidencia = p_id_incidencia;
END;
//

CREATE PROCEDURE EliminarIncidencia(IN p_id_incidencia INT)
BEGIN
    DELETE FROM Incidencias WHERE id_incidencia = p_id_incidencia;
END;
//

DELIMITER ;


-- Consultas de ejemplo para verificar las vistas
SELECT * FROM Vista_Turnos_Empleados;
SELECT * FROM Vista_Horas_Trabajadas_Mes;
SELECT * FROM Vista_Incidencias_Empleados;
SELECT * FROM Vista_Actividad_Usuarios;
SELECT * FROM Vista_Resumen_Asistencia_Diaria;
SELECT * FROM Vista_Empleados_Con_Multiples_Incidencias;
SELECT * FROM Vista_Turnos_Por_Tipo;
SELECT * FROM Vista_Asistencias_Pendientes;
SELECT * FROM Vista_Dias_Trabajados;

-- Consultas de ejemplo para las funciones
SELECT ObtenerNombreCompleto(2);
SELECT CalcularHorasTrabajadas('08:00:00', '12:30:00');
SELECT ContarIncidenciasEmpleado(1);
SELECT EsAdministrador(1);
SELECT TotalHorasTrabajadasEmpleado(2, '2025-04-01', '2025-04-30');
SELECT ObtenerDetallesEmpleado(1);
SELECT ObtenerTipoTurno(1);
SELECT ContarEmpleadosPorRol('admin');
SELECT PorcentajeAsistenciaMensual(1, '2025-04-01');
SELECT ObtenerLoginAdmin(1);

-- Ejemplo de uso de procedimientos almacenados
CALL InsertarEmpleado('Sofía', 'Ramírez', '99887766', 'sofia.ramirez@empresa.com', '678-901-2345', 'Calle 6, Ciudad F', 'cajero');
CALL ActualizarEmpleado(1, 'Gerson', 'Pérez Modificado', 'gerson.nuevo@empresa.com', '999-888-7777', 'Calle Nueva, Ciudad A', 'admin');
CALL RegistrarAsistencia(1, 1, '2025-04-11', '08:00:00', '12:00:00');
CALL RegistrarIncidencia(1, 'retraso', 'Llegó tarde por problemas de transporte', '2025-04-11');
CALL HistorialAsistenciaEmpleado(1);
CALL EliminarEmpleado(4);
CALL ConsultarIncidenciasPorTipo('retraso');
CALL CambiarRolEmpleado(3, 'admin');
CALL ConsultarEmpleadosPorRol('cajero');
CALL ResumenAsistenciaPorFecha('2025-04-09');
CALL InsertarUsuario(3, 'carlos.lopez', 'carlos789', 'cajero');

-- Consultas para seleccionar todos los registros de las tablas
SELECT * FROM Empleado;
SELECT * FROM Usuario;
SELECT * FROM Turnos;
SELECT * FROM RegistroAsistencia;
SELECT * FROM Incidencias;
SELECT * FROM Bitacora;

-- Consultas finales para verificar la base de datos
SELECT DATABASE();
SHOW TABLES;
SHOW TRIGGERS IN BD_backend;

-- Ejemplo de inserción y consulta en Bitacora
USE BD_backend;
CALL InsertarEmpleado('Prueba', 'Usuario', '77777777', 'prueba@empresa.com', '111-222-3333', 'Calle Prueba', 'cajero');
SELECT * FROM BD_backend.Bitacora;