
-- Crear la base de datos
CREATE DATABASE BDESRH_bakenversion;
USE BDESRH_bakenversion;

-- Crear tabla Rol
CREATE TABLE Rol (
    id_rol INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(20) NOT NULL UNIQUE
);

-- Crear tabla Empleado
CREATE TABLE Empleado (
    id_empleado INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    cedula VARCHAR(20) NOT NULL UNIQUE,
    correo VARCHAR(100),
    telefono VARCHAR(20),
    direccion VARCHAR(200),
    id_rol INT NOT NULL,
    FOREIGN KEY (id_rol) REFERENCES Rol(id_rol)
);

-- Crear tabla Administrador
CREATE TABLE Administrador (
    id_administrador INT PRIMARY KEY AUTO_INCREMENT,
    id_empleado INT NOT NULL UNIQUE,
    login VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(256) NOT NULL, -- Ampliado para hash seguro
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

-- Crear tabla Registro_Asistencia
CREATE TABLE Registro_Asistencia (
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
    id_registro INT NOT NULL,
    tipo_cambio VARCHAR(20) NOT NULL,
    usuario VARCHAR(50) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    detalles TEXT, -- Agregado para registrar detalles de cambios
    CONSTRAINT chk_tipo_cambio CHECK (tipo_cambio IN ('INSERT', 'UPDATE', 'DELETE'))
);

-- Crear índices para mejorar rendimiento
CREATE INDEX idx_registro_asistencia_fecha ON Registro_Asistencia(fecha);
CREATE INDEX idx_registro_asistencia_id_empleado ON Registro_Asistencia(id_empleado);
CREATE INDEX idx_incidencias_id_empleado ON Incidencias(id_empleado);
CREATE INDEX idx_turnos_id_empleado ON Turnos(id_empleado);

-- Insertar roles posibles
INSERT INTO Rol (nombre) VALUES
    ('empleado'),
    ('administrador'),
    ('servicio al cliente'),
    ('cajero'),
    ('mantenimiento');

-- Inserciones en Empleado
INSERT INTO Empleado (nombre, apellido, cedula, correo, telefono, direccion, id_rol) VALUES
    ('Juan', 'Pérez', '12345678', 'juan.perez@empresa.com', '123-456-7890', 'Calle 1, Ciudad A', 1),
    ('María', 'Gómez', '87654321', 'maria.gomez@empresa.com', '234-567-8901', 'Avenida 2, Ciudad B', 2),
    ('Carlos', 'López', '11223344', 'carlos.lopez@empresa.com', '345-678-9012', 'Calle 3, Ciudad C', 1),
    ('Ana', 'Martínez', '44332211', 'ana.martinez@empresa.com', '456-789-0123', 'Avenida 4, Ciudad D', 2),
    ('Luis', 'Rodríguez', '55667788', 'luis.rodriguez@empresa.com', '567-890-1234', 'Calle 5, Ciudad E', 1);

-- Inserciones en Administrador
INSERT INTO Administrador (id_empleado, login, password, ultima_actividad) VALUES
    (2, 'maria.gomez', SHA2('pass1234', 256), '2025-04-08 09:15:00'),
    (4, 'ana.martinez', SHA2('admin2025', 256), '2025-04-07 14:30:00');

-- Inserciones en Turnos
INSERT INTO Turnos (id_empleado, fecha, hora_inicio, hora_fin, tipo_turno) VALUES
    (1, '2025-04-09', '08:00:00', '12:00:00', 'mañana'),
    (2, '2025-04-09', '14:00:00', '18:00:00', 'tarde'),
    (3, '2025-04-09', '20:00:00', '00:00:00', 'noche'),
    (4, '2025-04-10', '09:00:00', '17:00:00', 'flexible'),
    (5, '2025-04-10', '08:00:00', '12:00:00', 'mañana');

-- Inserciones en Registro_Asistencia
INSERT INTO Registro_Asistencia (id_empleado, id_turno, fecha, hora_entrada, hora_salida, horas_trabajadas) VALUES
    (1, 1, '2025-04-09', '08:05:00', '12:00:00', 3.92),
    (2, 2, '2025-04-09', '14:00:00', '18:10:00', 4.17),
    (3, 3, '2025-04-09', '20:00:00', '23:55:00', 3.92),
    (4, 4, '2025-04-10', '09:10:00', '17:00:00', 7.83),
    (5, 5, '2025-04-10', '08:00:00', '12:05:00', 4.08);

-- Inserciones en Incidencias
INSERT INTO Incidencias (id_empleado, tipo_incidencia, descripcion, fecha_incidencia) VALUES
    (1, 'retraso', 'Llegó 5 minutos tarde por tráfico', '2025-04-09'),
    (2, 'permiso', 'Cita médica programada', '2025-04-09'),
    (3, 'ausencia', 'No se presentó sin aviso', '2025-04-09'),
    (4, 'retraso', 'Retraso de 10 minutos por lluvia', '2025-04-10'),
    (5, 'otro', 'Equipo dañado reportado', '2025-04-10');

-- Triggers para Empleado
DELIMITER //
CREATE TRIGGER trg_empleado_insert
AFTER INSERT ON Empleado
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, id_registro, tipo_cambio, usuario, detalles)
    VALUES ('Empleado', NEW.id_empleado, 'INSERT', USER(),
            CONCAT('nombre=', NEW.nombre, ', apellido=', NEW.apellido, ', cedula=', NEW.cedula));
END;
//

CREATE TRIGGER trg_empleado_update
AFTER UPDATE ON Empleado
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, id_registro, tipo_cambio, usuario, detalles)
    VALUES ('Empleado', NEW.id_empleado, 'UPDATE', USER(),
            CONCAT('Antes: nombre=', OLD.nombre, ', apellido=', OLD.apellido, ', rol=', OLD.id_rol,
                   ' | Después: nombre=', NEW.nombre, ', apellido=', NEW.apellido, ', rol=', NEW.id_rol));
END;
//

CREATE TRIGGER trg_empleado_delete
AFTER DELETE ON Empleado
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, id_registro, tipo_cambio, usuario, detalles)
    VALUES ('Empleado', OLD.id_empleado, 'DELETE', USER(),
            CONCAT('nombre=', OLD.nombre, ', apellido=', OLD.apellido, ', cedula=', OLD.cedula));
END;
//
DELIMITER ;

-- Triggers para Administrador
DELIMITER //
CREATE TRIGGER trg_administrador_insert
AFTER INSERT ON Administrador
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, id_registro, tipo_cambio, usuario, detalles)
    VALUES ('Administrador', NEW.id_administrador, 'INSERT', USER(),
            CONCAT('id_empleado=', NEW.id_empleado, ', login=', NEW.login));
END;
//

CREATE TRIGGER trg_administrador_update
AFTER UPDATE ON Administrador
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, id_registro, tipo_cambio, usuario, detalles)
    VALUES ('Administrador', NEW.id_administrador, 'UPDATE', USER(),
            CONCAT('Antes: login=', OLD.login, ', ultima_actividad=', OLD.ultima_actividad,
                   ' | Después: login=', NEW.login, ', ultima_actividad=', NEW.ultima_actividad));
END;
//

CREATE TRIGGER trg_administrador_delete
AFTER DELETE ON Administrador
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, id_registro, tipo_cambio, usuario, detalles)
    VALUES ('Administrador', OLD.id_administrador, 'DELETE', USER(),
            CONCAT('id_empleado=', OLD.id_empleado, ', login=', OLD.login));
END;
//
DELIMITER ;

-- Triggers para Turnos
DELIMITER //
CREATE TRIGGER trg_turnos_insert
AFTER INSERT ON Turnos
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, id_registro, tipo_cambio, usuario, detalles)
    VALUES ('Turnos', NEW.id_turno, 'INSERT', USER(),
            CONCAT('id_empleado=', NEW.id_empleado, ', fecha=', NEW.fecha, ', tipo_turno=', NEW.tipo_turno));
END;
//

CREATE TRIGGER trg_turnos_update
AFTER UPDATE ON Turnos
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, id_registro, tipo_cambio, usuario, detalles)
    VALUES ('Turnos', NEW.id_turno, 'UPDATE', USER(),
            CONCAT('Antes: fecha=', OLD.fecha, ', tipo_turno=', OLD.tipo_turno,
                   ' | Después: fecha=', NEW.fecha, ', tipo_turno=', NEW.tipo_turno));
END;
//

CREATE TRIGGER trg_turnos_delete
AFTER DELETE ON Turnos
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, id_registro, tipo_cambio, usuario, detalles)
    VALUES ('Turnos', OLD.id_turno, 'DELETE', USER(),
            CONCAT('id_empleado=', OLD.id_empleado, ', fecha=', OLD.fecha, ', tipo_turno=', OLD.tipo_turno));
END;
//
DELIMITER ;

-- Triggers para Registro_Asistencia
DELIMITER //
CREATE TRIGGER trg_registro_asistencia_insert
AFTER INSERT ON Registro_Asistencia
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, id_registro, tipo_cambio, usuario, detalles)
    VALUES ('Registro_Asistencia', NEW.id_registro, 'INSERT', USER(),
            CONCAT('id_empleado=', NEW.id_empleado, ', fecha=', NEW.fecha, ', horas_trabajadas=', NEW.horas_trabajadas));
END;
//

CREATE TRIGGER trg_registro_asistencia_update
AFTER UPDATE ON Registro_Asistencia
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, id_registro, tipo_cambio, usuario, detalles)
    VALUES ('Registro_Asistencia', NEW.id_registro, 'UPDATE', USER(),
            CONCAT('Antes: fecha=', OLD.fecha, ', horas_trabajadas=', OLD.horas_trabajadas,
                   ' | Después: fecha=', NEW.fecha, ', horas_trabajadas=', NEW.horas_trabajadas));
END;
//

CREATE TRIGGER trg_registro_asistencia_delete
AFTER DELETE ON Registro_Asistencia
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, id_registro, tipo_cambio, usuario, detalles)
    VALUES ('Registro_Asistencia', OLD.id_registro, 'DELETE', USER(),
            CONCAT('id_empleado=', OLD.id_empleado, ', fecha=', OLD.fecha, ', horas_trabajadas=', OLD.horas_trabajadas));
END;
//
DELIMITER ;

-- Triggers para Incidencias
DELIMITER //
CREATE TRIGGER trg_incidencias_insert
AFTER INSERT ON Incidencias
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, id_registro, tipo_cambio, usuario, detalles)
    VALUES ('Incidencias', NEW.id_incidencia, 'INSERT', USER(),
            CONCAT('id_empleado=', NEW.id_empleado, ', tipo_incidencia=', NEW.tipo_incidencia, ', fecha_incidencia=', NEW.fecha_incidencia));
END;
//

CREATE TRIGGER trg_incidencias_update
AFTER UPDATE ON Incidencias
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, id_registro, tipo_cambio, usuario, detalles)
    VALUES ('Incidencias', NEW.id_incidencia, 'UPDATE', USER(),
            CONCAT('Antes: tipo_incidencia=', OLD.tipo_incidencia, ', fecha_incidencia=', OLD.fecha_incidencia,
                   ' | Después: tipo_incidencia=', NEW.tipo_incidencia, ', fecha_incidencia=', NEW.fecha_incidencia));
END;//

CREATE TRIGGER trg_incidencias_delete
AFTER DELETE ON Incidencias
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (tabla_afectada, id_registro, tipo_cambio, usuario, detalles)
    VALUES ('Incidencias', OLD.id_incidencia, 'DELETE', USER(),
            CONCAT('id_empleado=', OLD.id_empleado, ', tipo_incidencia=', OLD.tipo_incidencia, ', fecha_incidencia=', OLD.fecha_incidencia));
END;//
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

-- Vista 4: Administradores y su última actividad
CREATE VIEW Vista_Actividad_Administradores AS
SELECT 
    e.nombre, 
    e.apellido, 
    a.login, 
    a.ultima_actividad
FROM 
    Empleado e
INNER JOIN 
    Administrador a ON e.id_empleado = a.id_empleado
INNER JOIN
    Rol r ON e.id_rol = r.id_rol
WHERE 
    r.nombre = 'administrador'
ORDER BY 
    a.ultima_actividad DESC;

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

-- Procedimiento 1: Insertar un nuevo empleado
DELIMITER //
CREATE PROCEDURE InsertarEmpleado(
    IN p_nombre VARCHAR(50),
    IN p_apellido VARCHAR(50),
    IN p_cedula VARCHAR(20),
    IN p_correo VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_direccion VARCHAR(200),
    IN p_rol VARCHAR(20)
)
BEGIN
    DECLARE v_id_rol INT;
    DECLARE EXIT HANDLER FOR NOT FOUND 
    BEGIN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El rol especificado no existe';
    END;
    SELECT id_rol INTO v_id_rol FROM Rol WHERE nombre = p_rol;
    INSERT INTO Empleado (nombre, apellido, cedula, correo, telefono, direccion, id_rol)
    VALUES (p_nombre, p_apellido, p_cedula, p_correo, p_telefono, p_direccion, v_id_rol);
END;
//
DELIMITER ;

-- Procedimiento 2: Registrar asistencia
DELIMITER //
CREATE PROCEDURE RegistrarAsistencia(
    IN p_id_empleado INT,
    IN p_id_turno INT,
    IN p_fecha DATE,
    IN p_hora_entrada TIME,
    IN p_hora_salida TIME
)
BEGIN
    DECLARE horas_trabajadas FLOAT;
    DECLARE start_datetime DATETIME;
    DECLARE end_datetime DATETIME;
    DECLARE v_count INT;

    -- Validar existencia de id_empleado
    SELECT COUNT(*) INTO v_count FROM Empleado WHERE id_empleado = p_id_empleado;
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El empleado especificado no existe';
    END IF;

    -- Validar existencia de id_turno
    SELECT COUNT(*) INTO v_count FROM Turnos WHERE id_turno = p_id_turno;
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El turno especificado no existe';
    END IF;

    SET start_datetime = CONCAT('2000-01-01 ', p_hora_entrada);
    SET end_datetime = CONCAT('2000-01-01 ', p_hora_salida);

    IF p_hora_salida <= p_hora_entrada THEN
        SET end_datetime = DATE_ADD(end_datetime, INTERVAL 1 DAY);
    END IF;

    SET horas_trabajadas = TIMESTAMPDIFF(MINUTE, start_datetime, end_datetime) / 60;

    INSERT INTO Registro_Asistencia (id_empleado, id_turno, fecha, hora_entrada, hora_salida, horas_trabajadas)
    VALUES (p_id_empleado, p_id_turno, p_fecha, p_hora_entrada, p_hora_salida, horas_trabajadas);
END;
//
DELIMITER ;

-- Procedimiento 3: Actualizar los datos de un empleado
DELIMITER //
CREATE PROCEDURE ActualizarEmpleado(
    IN p_id_empleado INT,
    IN p_nombre VARCHAR(50),
    IN p_apellido VARCHAR(50),
    IN p_correo VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_direccion VARCHAR(200),
    IN p_rol VARCHAR(20)
)
BEGIN
    DECLARE v_id_rol INT;
    DECLARE v_count INT;

    -- Validar existencia de id_empleado
    SELECT COUNT(*) INTO v_count FROM Empleado WHERE id_empleado = p_id_empleado;
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El empleado especificado no existe';
    END IF;

    -- Validar existencia de rol
    SELECT id_rol INTO v_id_rol FROM Rol WHERE nombre = p_rol;
    IF v_id_rol IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El rol especificado no existe';
    END IF;

    UPDATE Empleado
    SET
        nombre = p_nombre,
        apellido = p_apellido,
        correo = p_correo,
        telefono = p_telefono,
        direccion = p_direccion,
        id_rol = v_id_rol
    WHERE id_empleado = p_id_empleado;
END;
//
DELIMITER ;

-- Procedimiento 4: Registrar una incidencia
DELIMITER //
CREATE PROCEDURE RegistrarIncidencia(
    IN p_id_empleado INT,
    IN p_tipo_incidencia VARCHAR(50),
    IN p_descripcion TEXT,
    IN p_fecha_incidencia DATE
)
BEGIN
    DECLARE v_count INT;

    -- Validar existencia de id_empleado
    SELECT COUNT(*) INTO v_count FROM Empleado WHERE id_empleado = p_id_empleado;
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El empleado especificado no existe';
    END IF;

    INSERT INTO Incidencias (id_empleado, tipo_incidencia, descripcion, fecha_incidencia)
    VALUES (p_id_empleado, p_tipo_incidencia, p_descripcion, p_fecha_incidencia);
END;
//
DELIMITER ;

-- Procedimiento 5: Consultar historial de asistencias de un empleado
DELIMITER //
CREATE PROCEDURE HistorialAsistenciaEmpleado(
    IN p_id_empleado INT
)
BEGIN
    DECLARE v_count INT;

    -- Validar existencia de id_empleado
    SELECT COUNT(*) INTO v_count FROM Empleado WHERE id_empleado = p_id_empleado;
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El empleado especificado no existe';
    END IF;

    SELECT 
        CONCAT(e.nombre, ' ', e.apellido) AS nombre_completo,
        ra.fecha, 
        ra.hora_entrada, 
        ra.hora_salida, 
        ra.horas_trabajadas
    FROM Registro_Asistencia ra
    JOIN Empleado e ON ra.id_empleado = e.id_empleado
    WHERE ra.id_empleado = p_id_empleado
    ORDER BY ra.fecha DESC;
END;
//
DELIMITER ;

-- Procedimiento 6: Elimina un empleado dado su ID
DELIMITER //
CREATE PROCEDURE EliminarEmpleado(
    IN p_id_empleado INT
)
BEGIN
    DECLARE v_count INT;

    -- Validar existencia de id_empleado
    SELECT COUNT(*) INTO v_count FROM Empleado WHERE id_empleado = p_id_empleado;
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El empleado especificado no existe';
    END IF;

    DELETE FROM Registro_Asistencia WHERE id_empleado = p_id_empleado;
    DELETE FROM Incidencias WHERE id_empleado = p_id_empleado;
    DELETE FROM Turnos WHERE id_empleado = p_id_empleado;
    DELETE FROM Administrador WHERE id_empleado = p_id_empleado;
    DELETE FROM Empleado WHERE id_empleado = p_id_empleado;
END;
//
DELIMITER ;

-- Procedimiento 7: Consulta todas las incidencias de un tipo específico
DELIMITER //
CREATE PROCEDURE ConsultarIncidenciasPorTipo(IN p_tipo VARCHAR(50))
BEGIN
    SELECT * FROM Incidencias WHERE tipo_incidencia = p_tipo;
END;
//
DELIMITER ;

-- Procedimiento 8: Cambiar rol de empleado
DELIMITER //
CREATE PROCEDURE CambiarRolEmpleado(IN p_id_empleado INT, IN p_nuevo_rol VARCHAR(20))
BEGIN
    DECLARE v_id_rol INT;
    DECLARE v_count INT;

    -- Validar existencia de id_empleado
    SELECT COUNT(*) INTO v_count FROM Empleado WHERE id_empleado = p_id_empleado;
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El empleado especificado no existe';
    END IF;

    -- Validar existencia de rol
    SELECT id_rol INTO v_id_rol FROM Rol WHERE nombre = p_nuevo_rol;
    IF v_id_rol IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El rol especificado no existe';
    END IF;

    UPDATE Empleado SET id_rol = v_id_rol WHERE id_empleado = p_id_empleado;
END;
//
DELIMITER ;

-- Procedimiento 9: Consultar empleados por rol
DELIMITER //
CREATE PROCEDURE ConsultarEmpleadosPorRol(IN p_rol VARCHAR(20))
BEGIN
    DECLARE v_count INT;

    -- Validar existencia de rol
    SELECT COUNT(*) INTO v_count FROM Rol WHERE nombre = p_rol;
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El rol especificado no existe';
    END IF;

    SELECT e.* FROM Empleado e
    JOIN Rol r ON e.id_rol = r.id_rol
    WHERE r.nombre = p_rol;
END;
//
DELIMITER ;

-- Procedimiento 10: Obtener resumen de asistencia por fecha
DELIMITER //
CREATE PROCEDURE ResumenAsistenciaPorFecha(
    IN p_fecha DATE
)
BEGIN
    SELECT
        e.nombre,
        e.apellido,
        ra.hora_entrada,
        ra.hora_salida,
        ra.horas_trabajadas
    FROM
        Empleado e
    JOIN
        Registro_Asistencia ra ON e.id_empleado = ra.id_empleado
    WHERE
        ra.fecha = p_fecha;
END;
//
DELIMITER ;

-- Procedimiento adicional: Insertar administrador
DELIMITER //
CREATE PROCEDURE InsertarAdministrador(
    IN p_id_empleado INT,
    IN p_login VARCHAR(50),
    IN p_password VARCHAR(256)
)
BEGIN
    DECLARE v_count INT;

    -- Validar existencia de id_empleado
    SELECT COUNT(*) INTO v_count FROM Empleado WHERE id_empleado = p_id_empleado;
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El empleado especificado no existe';
    END IF;

    INSERT INTO Administrador (id_empleado, login, password, ultima_actividad)
    VALUES (p_id_empleado, p_login, SHA2(p_password, 256), NOW());
END;
//
DELIMITER ;

-- Función 1: Obtener el nombre completo de un empleado
DELIMITER //
CREATE FUNCTION ObtenerNombreCompleto(p_id_empleado INT)
RETURNS VARCHAR(120)
DETERMINISTIC
BEGIN
    DECLARE nombre_completo VARCHAR(120);
    
    SELECT CONCAT(nombre, ' ', apellido)
    INTO nombre_completo
    FROM Empleado
    WHERE id_empleado = p_id_empleado;
    
    IF nombre_completo IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El empleado especificado no existe';
    END IF;
    
    RETURN nombre_completo;
END;
//
DELIMITER ;

-- Función 2: Calcular la duración (en horas) entre dos horas
DELIMITER //
CREATE FUNCTION CalcularHorasTrabajadas(p_hora_inicio TIME, p_hora_fin TIME)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE start_datetime DATETIME;
    DECLARE end_datetime DATETIME;

    SET start_datetime = CONCAT('2000-01-01 ', p_hora_inicio);
    SET end_datetime = CONCAT('2000-01-01 ', p_hora_fin);

    IF p_hora_fin <= p_hora_inicio THEN
        SET end_datetime = DATE_ADD(end_datetime, INTERVAL 1 DAY);
    END IF;

    RETURN TIMESTAMPDIFF(MINUTE, start_datetime, end_datetime) / 60;
END;
//
DELIMITER ;

-- Función 3: Contar el número de incidencias de un empleado
DELIMITER //
CREATE FUNCTION ContarIncidenciasEmpleado(p_id_empleado INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_incidencias INT;
    
    SELECT COUNT(*)
    INTO total_incidencias
    FROM Incidencias
    WHERE id_empleado = p_id_empleado;
    
    RETURN total_incidencias;
END;
//
DELIMITER ;

-- Función 4: Verificar si un empleado es administrador
DELIMITER //
CREATE FUNCTION EsAdministrador(p_id_empleado INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE es_admin BOOLEAN;
    
    SELECT CASE WHEN r.nombre = 'administrador' THEN TRUE ELSE FALSE END
    INTO es_admin
    FROM Empleado e
    JOIN Rol r ON e.id_rol = r.id_rol
    WHERE e.id_empleado = p_id_empleado;
    
    IF es_admin IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El empleado especificado no existe';
    END IF;
    
    RETURN es_admin;
END;
//
DELIMITER ;

-- Función 5: Obtener el total de horas trabajadas por un empleado en un rango de fechas
DELIMITER //
CREATE FUNCTION TotalHorasTrabajadasEmpleado(p_id_empleado INT, p_fecha_inicio DATE, p_fecha_fin DATE)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE total_horas FLOAT;
    
    SELECT COALESCE(SUM(horas_trabajadas), 0)
    INTO total_horas
    FROM Registro_Asistencia
    WHERE id_empleado = p_id_empleado
      AND fecha BETWEEN p_fecha_inicio AND p_fecha_fin;
      
    RETURN total_horas;
END;
//
DELIMITER ;

-- Función 6: Obtener los detalles completos de un empleado
DELIMITER //
CREATE FUNCTION ObtenerDetallesEmpleado(p_id_empleado INT)
RETURNS VARCHAR(500)
DETERMINISTIC
BEGIN
    DECLARE detalles VARCHAR(500);
    
    SELECT CONCAT(nombre, ' ', apellido, ' | Cédula: ', cedula, ' | Correo: ', correo, ' | Teléfono: ', telefono, ' | Dirección: ', direccion)
    INTO detalles
    FROM Empleado
    WHERE id_empleado = p_id_empleado;
    
    IF detalles IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El empleado especificado no existe';
    END IF;
    
    RETURN detalles;
END;
//
DELIMITER ;

-- Función 7: Obtener tipo de turno por ID de turno
DELIMITER //
CREATE FUNCTION ObtenerTipoTurno(p_id_turno INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE tipo VARCHAR(20);
    SELECT tipo_turno INTO tipo FROM Turnos WHERE id_turno = p_id_turno;
    IF tipo IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El turno especificado no existe';
    END IF;
    RETURN tipo;
END;
//
DELIMITER ;

-- Función 8: Contar empleados por rol
DELIMITER //
CREATE FUNCTION ContarEmpleadosPorRol(
    p_rol VARCHAR(20)
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM Empleado e
    JOIN Rol r ON e.id_rol = r.id_rol
    WHERE r.nombre = p_rol;
    RETURN total;
END;
//
DELIMITER ;

-- Función 9: Calcular porcentaje de asistencia de un empleado en un mes
DELIMITER //
CREATE FUNCTION PorcentajeAsistenciaMensual(p_id_empleado INT, p_mes DATE)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE dias_presentes INT;
    DECLARE dias_mes INT;

    SELECT COUNT(DISTINCT fecha) INTO dias_presentes
    FROM Registro_Asistencia
    WHERE id_empleado = p_id_empleado
      AND MONTH(fecha) = MONTH(p_mes)
      AND YEAR(fecha) = YEAR(p_mes);
      
    SET dias_mes = DAY(LAST_DAY(p_mes));
    
    IF dias_presentes IS NULL THEN
        SET dias_presentes = 0;
    END IF;
    
    RETURN (dias_presentes / dias_mes) * 100;
END;
//
DELIMITER ;

-- Función 10: Obtener login de administrador
DELIMITER //
CREATE FUNCTION ObtenerLoginAdmin(p_id_empleado INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE login_usr VARCHAR(50);
    SELECT login INTO login_usr FROM Administrador WHERE id_empleado = p_id_empleado;
    IF login_usr IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El empleado no es administrador';
    END IF;
    RETURN login_usr;
END;
//
DELIMITER ;

-- Consultas de ejemplo para verificar las vistas
SELECT * FROM Vista_Turnos_Empleados;
SELECT * FROM Vista_Horas_Trabajadas_Mes;
SELECT * FROM Vista_Incidencias_Empleados;
SELECT * FROM Vista_Actividad_Administradores;
SELECT * FROM Vista_Resumen_Asistencia_Diaria;
SELECT * FROM Vista_Empleados_Con_Multiples_Incidencias;
SELECT * FROM Vista_Turnos_Por_Tipo;
SELECT * FROM Vista_Asistencias_Pendientes;
SELECT * FROM Vista_Dias_Trabajados;

-- Consultas de ejemplo para las funciones
SELECT ObtenerNombreCompleto(2);
SELECT CalcularHorasTrabajadas('08:00:00', '12:30:00');
SELECT ContarIncidenciasEmpleado(1);
SELECT EsAdministrador(4);
SELECT TotalHorasTrabajadasEmpleado(2, '2025-04-01', '2025-04-30');
SELECT ObtenerDetallesEmpleado(1);
SELECT ObtenerTipoTurno(1);
SELECT ContarEmpleadosPorRol('administrador');
SELECT PorcentajeAsistenciaMensual(1, '2025-04-01');
SELECT ObtenerLoginAdmin(2);

-- Ejemplo de uso de procedimientos almacenados
CALL InsertarEmpleado('Sofía', 'Ramírez', '99887766', 'sofia.ramirez@empresa.com', '678-901-2345', 'Calle 6, Ciudad F', 'empleado');
CALL ActualizarEmpleado(1, 'Juan', 'Pérez Modificado', 'juan.nuevo@empresa.com', '999-888-7777', 'Calle Nueva, Ciudad A', 'empleado');
CALL RegistrarAsistencia(1, 1, '2025-04-11', '08:00:00', '12:00:00');
CALL RegistrarIncidencia(1, 'retraso', 'Llegó tarde por problemas de transporte', '2025-04-11');
CALL HistorialAsistenciaEmpleado(1);
CALL EliminarEmpleado(1);
CALL ConsultarIncidenciasPorTipo('retraso');
CALL CambiarRolEmpleado(3, 'administrador');
CALL ConsultarEmpleadosPorRol('empleado');
CALL ResumenAsistenciaPorFecha('2025-04-09');
CALL InsertarAdministrador(3, 'carlos.lopez', 'carlos789');

-- Consultas para seleccionar todos los registros de las tablas
SELECT * FROM Empleado;
SELECT * FROM Administrador;
SELECT * FROM Turnos;
SELECT * FROM Registro_Asistencia;
SELECT * FROM Incidencias;
SELECT * FROM Bitacora;

SELECT DATABASE();
SHOW TABLES;
SHOW TRIGGERS IN BDESRH_bakenversion;

USE BDESRH_bakenversion;
CALL InsertarEmpleado('Prueba', 'Usuario', '77777777', 'prueba@empresa.com', '111-222-3333', 'Calle Prueba', 'empleado');
SELECT * FROM BDESRH_bakenversion.Bitacora;