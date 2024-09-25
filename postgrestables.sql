-- Tabla de usuarios
CREATE TABLE usuarios (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    correo VARCHAR(255) NOT NULL UNIQUE,
    contraseña VARCHAR(255) NOT NULL,
    rol VARCHAR(50) CHECK (rol IN ('usuario', 'administrador')) NOT NULL,
    creado_en TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de instalaciones
CREATE TABLE instalaciones (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    ubicacion VARCHAR(255),
    disponible_desde TIMESTAMPTZ NOT NULL,
    disponible_hasta TIMESTAMPTZ NOT NULL
);

-- Tabla de estados
CREATE TABLE estados (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL UNIQUE
);

-- Insertar estados para reservas
INSERT INTO estados (nombre) VALUES ('pendiente'), ('confirmada'), ('cancelada');

-- Tabla de bloques de tiempo
CREATE TABLE bloques_tiempo (
    id BIGSERIAL PRIMARY KEY,
    instalacion_id BIGINT,
    bloque INT NOT NULL, -- Número del bloque
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    disponible BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (instalacion_id) REFERENCES instalaciones(id) ON DELETE CASCADE
);

-- Tabla de reservas (modificada)
CREATE TABLE reservas (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT,
    instalacion_id BIGINT,
    fecha_reserva DATE NOT NULL,
    bloque_tiempo_id BIGINT, -- Relación con el bloque de tiempo
    estado_id BIGINT,
    creado_en TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (instalacion_id) REFERENCES instalaciones(id) ON DELETE CASCADE,
    FOREIGN KEY (bloque_tiempo_id) REFERENCES bloques_tiempo(id) ON DELETE CASCADE,
    FOREIGN KEY (estado_id) REFERENCES estados(id) ON DELETE SET NULL
);

-- Tabla de notificaciones (modificada)
CREATE TABLE notificaciones (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT,
    mensaje TEXT NOT NULL,
    leida BOOLEAN DEFAULT FALSE, -- Nuevo campo para marcar si fue leída
    enviado_en TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Tabla de pagos
CREATE TABLE pagos (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT,
    reserva_id BIGINT,
    monto DECIMAL(10, 2) NOT NULL,
    fecha_pago TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(50) CHECK (estado IN ('pendiente', 'completado', 'fallido')) NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (reserva_id) REFERENCES reservas(id) ON DELETE CASCADE
);

-- Tabla de preferencias
CREATE TABLE preferencias (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT,
    tipo_preferencia VARCHAR(255) NOT NULL,
    valor_preferencia TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);
