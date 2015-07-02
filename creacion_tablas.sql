CREATE TABLE dbo.niveles
	(
	idNivel int PRIMARY KEY NOT NULL,
	detalle varchar(255) NOT NULL
	) ON [PRIMARY]
GO

USE parcial_gdd
GO


CREATE TABLE dbo.paises
	(
	idPais int PRIMARY KEY NOT NULL,
	detalle varchar(255) NOT NULL
	) ON [PRIMARY]
GO

CREATE TABLE dbo.categoria
	(
	idCategoria int PRIMARY KEY NOT NULL,
	detalle varchar(255) NOT NULL
	) ON [PRIMARY]
GO

CREATE TABLE dbo.jugadores
	(
	idJugador int NOT NULL,
	nombre varchar(255) NOT NULL UNIQUE,
	pais int FOREIGN KEY REFERENCES dbo.paises(idPais),
	nick varchar(255),
	totalJugados int NOT NULL,
	totalGanados int NOT NULL,
	fechaAlta datetime,
	)  ON [PRIMARY]
GO

CREATE TABLE dbo.competiciones
	(
	idCompeticion int PRIMARY KEY NOT NULL,
	jugador1 int FOREIGN KEY REFERENCES dbo.jugadores(idJugador),
	jugador2 int FOREIGN KEY REFERENCES dbo.jugadores(idJugador),
	jugador3 int FOREIGN KEY REFERENCES dbo.jugadores(idJugador),
	jugador4 int FOREIGN KEY REFERENCES dbo.jugadores(idJugador),
	jugador5 int FOREIGN KEY REFERENCES dbo.jugadores(idJugador),
	ganador int
	)  ON [PRIMARY]
GO

CREATE TABLE dbo.preguntas
	(
	idPregunta int PRIMARY KEY NOT NULL,
	detalle varchar(255) NOT NULL,
	categoria int FOREIGN KEY REFERENCES categoria(idCategoria),
	nivel int FOREIGN KEY REFERENCES niveles(idNivel),
	fechaInicio datetime,
	fechaFin datetime
	) ON [PRIMARY]
GO

CREATE TABLE dbo.respuestas
	(
	idRespuesta int PRIMARY KEY NOT NULL,
	pregunta int FOREIGN KEY REFERENCES preguntas(idPregunta),
	letra tinyint NOT NULL,
	detalle varchar(255) NOT NULL,
	esCorrecta tinyint NOT NULL,
	porcentaje float NOT NULL
	) ON [PRIMARY]
GO

CREATE TABLE dbo.logs
	(
	idLog int PRIMARY KEY NOT NULL,
	pregunta int FOREIGN KEY REFERENCES preguntas(idPregunta),
	respuesta int FOREIGN KEY REFERENCES respuestas(idRespuesta),
	jugador int FOREIGN KEY REFERENCES jugadores(idJugador),
	competicion int FOREIGN KEY REFERENCES competiciones(idCompeticion),
	fechaHora datetime NOT NULL,
	) ON [PRIMARY]
GO

CREATE TABLE dbo.rel_pais_pregunta
	(
	idPais int NOT NULL,
	idPregunta int NOT NULL,
	CONSTRAINT PK_REL_PAIS_PREGUNTA PRIMARY KEY (idPais, idPregunta)
	) ON [PRIMARY]
GO

/*(* Preguntas) Al agregar una pregunta, la fecha de inicio está en
null y no se completa hasta que se active en el juego.  Si la fecha 
de fin está en null quiere decir que la pregunta está activa, al 
desactivarla la fecha de fin siempre debe ser mayor al día de hoy.*/

/*(* Respuestas) La cantidad de respuestas posibles son 4 y están 
enmarcadas como opciones / letra (A, B, C y D), para las 4 
opciones de cada pregunta solo una puede ser correcta, el campo 
porcentaje es un valor numérico entre 0 y 100 sin decimales, a 
medida que se completa la tabla de Log con las respuestas que se 
van dando, un trigger los va calculando de tal forma que la 
sumatoria de los 4 porcentajes da 100, si la pregunta nunca fue 
usada el campo posee null.*/

/*(* Jugadores) A medida que se completan las competiciones, un 
trigger va actualizando los campos de total de partidas jugadas y 
ganadas.*/

/*(* Competiciones) En cada competición hay al menos 1 jugador.  
Si solo juega 1 podría no haber un ganador, si juegan 2 o más 
jugadores siempre hay un ganador, los campos de los jugadores 
se completan siempre en orden desde jugador 1 a jugador 5, 
quedando los restantes en null, el campo ganador de poseer dato 
es un escalar de 1 a 5.*/

/*(* Países de las preguntas) si una pregunta no posee ningún 
registro en la tabla de relación se le puede realizar a jugadores de 
cualquier país, si en cambio posee registros se le puede realizar 
solo a jugadores que sean de ese país.  Las preguntas pueden 
figurar en sólo un país*/