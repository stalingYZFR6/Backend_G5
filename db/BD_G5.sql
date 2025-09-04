CREATE DATABASE IF NOT EXISTS BD_G5;
USE BD_G5;

-- Crear el usuario si no existe (opcional)
CREATE USER IF NOT EXISTS 'root'@'localhost' IDENTIFIED BY 'Staling#123';

-- Dar privilegios sobre la base
GRANT ALL PRIVILEGES ON BD_G5.* TO 'root'@'localhost';

-- Aplicar cambios
FLUSH PRIVILEGES;


-- 3️⃣ Crear tablas
CREATE TABLE Empleado (
    id_empleado INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    cedula VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100),
    rol VARCHAR(20) NOT NULL CHECK (rol IN ('empleado', 'administrador'))
);

CREATE TABLE Administrador (
    id_administrador INT PRIMARY KEY AUTO_INCREMENT,
    id_empleado INT NOT NULL UNIQUE,
    login VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    ultima_actividad DATETIME,
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

CREATE TABLE Turnos (
    id_turno INT PRIMARY KEY AUTO_INCREMENT,
    id_empleado INT NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    tipo_turno VARCHAR(20) NOT NULL CHECK (tipo_turno IN ('mañana', 'tarde', 'noche', 'flexible')),
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

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

CREATE TABLE Incidencias (
    id_incidencia INT PRIMARY KEY AUTO_INCREMENT,
    id_empleado INT NOT NULL,
    tipo_incidencia VARCHAR(50) NOT NULL CHECK (tipo_incidencia IN ('retraso', 'ausencia', 'permiso', 'otro')),
    descripcion TEXT,
    fecha_incidencia DATE NOT NULL,
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

-- 4️⃣ Inserciones en Empleado
INSERT INTO Empleado (nombre, apellido, cedula, email, rol) VALUES
    ('Juan', 'Pérez', '12345678', 'juan.perez@empresa.com', 'empleado'),
    ('María', 'Gómez', '87654321', 'maria.gomez@empresa.com', 'administrador'),
    ('Carlos', 'López', '11223344', 'carlos.lopez@empresa.com', 'empleado'),
    ('Ana', 'Martínez', '44332211', 'ana.martinez@empresa.com', 'administrador'),
    ('Luis', 'Rodríguez', '55667788', 'luis.rodriguez@empresa.com', 'empleado');

-- 5️⃣ Inserciones en Administrador
INSERT INTO Administrador (id_empleado, login, password, ultima_actividad) VALUES
    (2, 'maria.gomez', 'pass1234', '2025-04-08 09:15:00'),
    (4, 'ana.martinez', 'admin2025', '2025-04-07 14:30:00'),
    (1, 'juan.perez', 'juan456', '2025-04-06 10:00:00'),
    (3, 'carlos.lopez', 'carlos789', '2025-04-05 16:45:00'),
    (5, 'luis.rodriguez', 'luis1010', '2025-04-04 11:20:00');

-- 6️⃣ Inserciones en Turnos
INSERT INTO Turnos (id_empleado, fecha, hora_inicio, hora_fin, tipo_turno) VALUES
    (1, '2025-04-09', '08:00:00', '12:00:00', 'mañana'),
    (2, '2025-04-09', '14:00:00', '18:00:00', 'tarde'),
    (3, '2025-04-09', '20:00:00', '00:00:00', 'noche'),
    (4, '2025-04-10', '09:00:00', '17:00:00', 'flexible'),
    (5, '2025-04-10', '08:00:00', '12:00:00', 'mañana');

-- 7️⃣ Inserciones en Registro_Asistencia
INSERT INTO Registro_Asistencia (id_empleado, id_turno, fecha, hora_entrada, hora_salida, horas_trabajadas) VALUES
    (1, 1, '2025-04-09', '08:05:00', '12:00:00', 3.92),
    (2, 2, '2025-04-09', '14:00:00', '18:10:00', 4.17),
    (3, 3, '2025-04-09', '20:00:00', '23:55:00', 3.92),
    (4, 4, '2025-04-10', '09:10:00', '17:00:00', 7.83),
    (5, 5, '2025-04-10', '08:00:00', '12:05:00', 4.08);

-- 8️⃣ Inserciones en Incidencias
INSERT INTO Incidencias (id_empleado, tipo_incidencia, descripcion, fecha_incidencia) VALUES
    (1, 'retraso', 'Llegó 5 minutos tarde por tráfico', '2025-04-09'),
    (2, 'permiso', 'Cita médica programada', '2025-04-09'),
    (3, 'ausencia', 'No se presentó sin aviso', '2025-04-09'),
    (4, 'retraso', 'Retraso de 10 minutos por lluvia', '2025-04-10'),
    (5, 'otro', 'Equipo dañado reportado', '2025-04-10');
