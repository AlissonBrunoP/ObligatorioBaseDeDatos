create database ExamenBaseDatos;
use ExamenBaseDatos;

create table MODELOAERONAVE(
CodModelo int primary key, 
NombreModelo varchar (100), 
CodFabricante int ,
AutonomiaVuelo int,
)

create table AERONAVES(
Matricula int primary key, 
NombreAvión varchar (100),
CodModelo int foreign key references MODELOAERONAVE, 
Operativo varchar (100),
)

create table PILOTOS(
CodPiloto int primary key, 
NombrePiloto varchar (100) ,
Salario int,
)
create table CERTIFICACION(
CodPiloto int foreign key references PILOTOS, 
CodModelo int foreign key references modeloaeronave, 
fechaObtenido date, 
fechaExp date,
)create table FABRICANTES(CodFabricante int primary key, NombreFabricante varchar (100),)-- a. Para cada piloto que tenga habilitación vigente para volar más de 3 modelos de aeronaves diferentes,
-- se desea obtener su código y la máxima autonomía de vuelo que está certificado para volar.

select CERTIFICACION.CodPiloto, max (MODELOAERONAVE.AutonomiaVuelo) from CERTIFICACION, MODELOAERONAVE
where CERTIFICACION.CodModelo = MODELOAERONAVE.CodModelo and CERTIFICACION.fechaExp > getdate()
group by CERTIFICACION.CodPiloto, MODELOAERONAVE.AutonomiaVuelo
having count (certificacion.CodModelo) > 3




--b. Obtener el código y nombre de los modelos para los cuales existan pilotos certificados con un salario
--superior a USD 10.000 pero que no se incluyan los modelos del fabricante con el nombre
--“EMBARER”.


select CERTIFICACION.CodModelo, MODELOAERONAVE.NombreModelo from CERTIFICACION, pilotos, MODELOAERONAVE, FABRICANTES
where CERTIFICACION.CodPiloto = PILOTOS.CodPiloto and MODELOAERONAVE.CodFabricante = FABRICANTES.CodFabricante
and MODELOAERONAVE.CodModelo = CERTIFICACION.CodModelo and FABRICANTES.NombreFabricante = 'EMBARER'
group by  CERTIFICACION.CodModelo, MODELOAERONAVE.NombreModelo 
having count (PILOTOS.Salario) > 10000


--c. Obtener un ranking de los pilotos más experimentados de la aerolínea en volar el equipo “B747-400”
--  del fabricante “Boeing”. Se considera más experimentado aquel piloto que hace más cantidad
-- de tiempo que está certificado para volar una aeronave.


select CERTIFICACION.CodPiloto from CERTIFICACION, MODELOAERONAVE
where MODELOAERONAVE.CodModelo = CERTIFICACION.CodModelo and MODELOAERONAVE.NombreModelo = 'B747-400'
and fechaObtenido= ( select  min(CERTIFICACION.fechaObtenido) FROM CERTIFICACION)

