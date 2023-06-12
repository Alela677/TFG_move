|------------------ Creación de tablas ------------------|

create database move;
use move;

create table usuario (
id INT IDENTITY PRIMARY KEY,
nombre_usuario VARCHAR(50) NOT NULL,
contraseña VARCHAR(50),
Correo_electronico VARCHAR(100)
);


create table perfil_usuario(
id INT IDENTITY PRIMARY KEY,
nombre_uno VARCHAR(50),
sexo VARCHAR(50),
edad INT,
localidad VARCHAR(60),
deportes VARCHAR(60),
idUsuario INT,
FOREIGN KEY (idUsuario) REFERENCES usuario (id)
);

create table imagenperfil(
id INT IDENTITY PRIMARY KEY,
imagen VARCHAR (250),
idPerfil INT,
FOREIGN KEY (idPerfil) REFERENCES perfil_usuario (id)
);


create table imagenes(
id INT IDENTITY PRIMARY KEY,
idPerfilU INT,
imagen VARCHAR(250),
FOREIGN KEY (idPerfilU) REFERENCES perfil_usuario (id)
);


create table amigos(
id INT IDENTITY PRIMARY KEY,
solicitante INT,
perfil1 INT,
perfil2 INT,
FOREIGN KEY (solicitante) REFERENCES perfil_usuario (id)

);

create table deporte(
id INT IDENTITY PRIMARY KEY,
nombre VARCHAR(70),
imagen VARCHAR(250)

);

create table evento(
id INT IDENTITY PRIMARY KEY,
descripcion VARCHAR(250),
numero_participantes INT,
idDeporte INT,
fecha_evento DATETIME,
idPerfil INT,
ciudad VARCHAR(50),
longitud VARCHAR(100),
latitud VARCHAR(100),
FOREIGN KEY (idPerfil) REFERENCES perfil_usuario (id),
FOREIGN KEY (idDeporte) REFERENCES deporte (id)
);


create table participante(
id INT IDENTITY PRIMARY KEY,
perfil INT,
evento INT
FOREIGN KEY (perfil) REFERENCES perfil_usuario (id),
FOREIGN KEY (evento) REFERENCES evento (id)
);


create table chat (
id INT IDENTITY PRIMARY KEY,
perfil INT,
evento INT,
mensaje VARCHAR(250),
FOREIGN KEY (perfil) REFERENCES perfil_usuario (id),
FOREIGN KEY (evento) REFERENCES evento (id)
);


|------------------ Insertar Deportes ------------------|

insert into deporte (nombre,imagen) 
VALUES 
('Fútbol','https://apimove.somee.com/api/Deporte/viewimage/futbol.jpg'),
('Baloncesto' , 'https://apimove.somee.com/api/Deporte/viewimage/baloncesto.jpg'),
('Balonmano', 'https://apimove.somee.com/api/Deporte/viewimage/balonmano.jpg'),
('Atletismo', 'https://apimove.somee.com/api/Deporte/viewimage/atletismo.jpg'),
('Golf', 'https://apimove.somee.com/api/Deporte/viewimage/golf.jpg'),
('Natación','https://apimove.somee.com/api/Deporte/viewimage/natacion.jpg'),
('Padel', 'https://apimove.somee.com/api/Deporte/viewimage/padel.jpg'),
('Tenis','https://apimove.somee.com/api/Deporte/viewimage/tenis.jpg'),
('Tenis mesa','https://apimove.somee.com/api/Deporte/viewimage/tenismesa.jpg')


|------------------ Procedure eliminar todos los datos del usuario ------------------|

CREATE PROCEDURE eliminar_usuario 
@idUsuario INT, 
@idPerfil INT 
AS 
BEGIN 
    
    EXEC sp_msforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT all'

    DELETE FROM chat WHERE evento IN (SELECT Evento FROM evento WHERE idPerfil = @idPerfil) AND perfil = @idPerfil;
    DELETE FROM evento WHERE idPerfil = @idPerfil; 
    DELETE FROM participante WHERE perfil = @idPerfil;
    DELETE FROM amigos WHERE perfil1 = @idPerfil;
    DELETE FROM imagenperfil WHERE idPerfil = @idPerfil;
    DELETE FROM imagenes WHERE idPerfilU = @idPerfil;
    DELETE FROM perfil_usuario WHERE id = @idPerfil;
    DELETE FROM usuario WHERE id = @idUsuario;

    
    EXEC sp_msforeachtable 'ALTER TABLE ? CHECK CONSTRAINT all'
    
END
