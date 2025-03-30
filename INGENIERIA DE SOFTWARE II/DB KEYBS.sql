CREATE DATABASE keyBS;
USE keyBS;
CREATE TABLE Usuarios (
    id INT PRIMARY KEY IDENTITY (1,1),
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contrasena_hash VARBINARY(256) NOT NULL,
    salt VARBINARY(256) NOT NULL,
    tipo_usuario ENUM('Administrador', 'Usuario') NOT NULL,
    estado ENUM('Activo', 'Suspendido') DEFAULT 'Activo',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE DatosBiometricos (
    id INT PRIMARY KEY IDENTITY(1,1),
    usuario_id INT,
    huella_hash VARBINARY(256) NOT NULL,
    rostro_hash VARBINARY(256) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id) ON DELETE CASCADE
);

CREATE TABLE RegistrosAcceso (
    id INT PRIMARY KEY IDENTITY(1,1),
    usuario_id INT,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    metodo_autenticacion ENUM('Huella', 'Reconocimiento Facial', 'Contraseña') NOT NULL,
    estado ENUM('Éxito', 'Fallo') NOT NULL,
    direccion_ip VARCHAR(45) NOT NULL,
    dispositivo VARCHAR(100) NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id) ON DELETE CASCADE
);

CREATE TABLE DispositivosAutorizados (
    id INT PRIMARY KEY IDENTITY(1,1),
    usuario_id INT,
    dispositivo VARCHAR(100) NOT NULL,
    ip VARCHAR(50) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id) ON DELETE CASCADE
);

CREATE TABLE LogsSeguridad (
    id INT PRIMARY KEY IDENTITY(1,1),
    usuario_id INT,
    accion VARCHAR(255) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    detalle TEXT,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id) ON DELETE CASCADE
);

INSERT INTO Usuarios (nombre, correo, contrasena_hash, salt, tipo_usuario) VALUES
('Admin Keybs', 'admin@keybs.com', UNHEX('5f4dcc3b5aa765d61d8327deb882cf99'), UNHEX('a1b2c3d4e5f6g7h8'), 'Administrador'),
('Juan Pérez', 'juan.perez@keybs.com', UNHEX('a7b9c2d4e6f8g0h1'), UNHEX('h8g7f6e5d4c3b2a1'), 'Usuario');

INSERT INTO DatosBiometricos (usuario_id, huella_hash, rostro_hash) VALUES
(2, UNHEX('c1d2e3f4a5b6c7d8'), UNHEX('d8c7b6a5f4e3d2c1'));

INSERT INTO RegistrosAcceso (usuario_id, metodo_autenticacion, estado, direccion_ip, dispositivo) VALUES
(2, 'Huella', 'Éxito', '192.168.1.100', 'Laptop Personal'),
(2, 'Contraseña', 'Fallo', '192.168.1.101', 'Teléfono Móvil');

INSERT INTO DispositivosAutorizados (usuario_id, dispositivo, ip) VALUES
(2, 'Laptop Personal', '192.168.1.100');

INSERT INTO LogsSeguridad (usuario_id, accion, detalle) VALUES
(2, 'Intento de acceso fallido', 'Contraseña incorrecta en 192.168.1.101');

