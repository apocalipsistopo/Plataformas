-- Procedimientos Almacenados
-- Cadenillas Ñaccha,Fernando
-- 08/08/2022

--PA para la TEscuela

USE BDUniversidad
GO

IF OBJECT_ID('spListarEscuela') IS NOT NULL DROP PROC spListarEscuela
GO

CREATE PROC spListarEscuela
AS
BEGIN
	SELECT CodEscuela,Escuela,Facultad FROM TEscuela
END
go


IF OBJECT_ID('spAgregarEscuela') IS NOT NULL DROP PROC spAgregarEscuela
GO
CREATE PROC spAgregarEscuela
@CODESCUELA CHAR(3),
@ESCUELA VARCHAR(50),
@FACULTAD VARCHAR(50)
AS
BEGIN
	--CODESCUELA NO PUEDE SER DUPLICADO
	IF NOT EXISTS (SELECT CodEscuela from TEscuela where CodEscuela=@CODESCUELA)
		--ESCUELA NO PUEDE SER DUPLICADA
		IF NOT EXISTS (SELECT Escuela from TEscuela where Escuela=@ESCUELA)
		BEGIN
			INSERT INTO TEscuela VALUES(@CODESCUELA,@ESCUELA,@FACULTAD)
			SELECT CODERROR=0, MENSAJE='Se insertó correctamente la escuela'
		END
		ELSE SELECT CODERROR=1, MENSAJE='ERROR: Escuela duplicada'
	ELSE SELECT CODERROR=1, MENSAJE='ERROR: CodEscuela duplicado'
	--
END
GO

-- Actividad: Implementar Eliminar, Actualizar y Buscar, vía Aula Virtual

IF OBJECT_ID('spEliminarEscuela') IS NOT NULL DROP PROC spEliminarEscuela
GO

CREATE PROC spEliminarEscuela
@CODESCUELA CHAR(3)
AS
BEGIN
	delete from TEscuela where CodEscuela=@CODESCUELA
	if ((SELECT @@ROWCOUNT AS DELETED)=1)
	    --Se Elimino un elemento
		SELECT CODERROR=0, MENSAJE='Se elimino correctamente el elemento'
	
	--El elemento no existe
	ELSE SELECT CODERROR=1, MENSAJE='ERROR: No existe el CodEscuela ingresado'
	--
END
Go

IF OBJECT_ID('spActualizarEscuela') IS NOT NULL DROP PROC spActualizarEscuela
GO

CREATE PROC spActualizarEscuela
@CODESCUELA CHAR(3),
@ESCUELA VARCHAR(50),
@FACULTAD VARCHAR(50)
AS
BEGIN
	--Buscamos el Cod Escuela
	IF EXISTS (SELECT CodEscuela from TEscuela where CodEscuela=@CODESCUELA)
		--ESCUELA NO PUEDE SER DUPLICADA
		IF NOT EXISTS (SELECT Escuela from TEscuela where Escuela=@ESCUELA)
		BEGIN
			Update TEscuela set Escuela=@ESCUELA ,Facultad=@FACULTAD Where CodEscuela=@CODESCUELA
			SELECT CODERROR=0, MENSAJE='Se modifico correctamente la escuela'
		END
		ELSE SELECT CODERROR=1, MENSAJE='ERROR: Escuela duplicada'
	ELSE SELECT CODERROR=1, MENSAJE='ERROR: CodEscuela no existe'
	--
END
GO
IF OBJECT_ID('spBuscarEscuela') IS NOT NULL DROP PROC spBuscarEscuela
GO


CREATE PROC spBuscarEscuela
@ESCUELA VARCHAR(50)
AS
BEGIN
	--Buscamos Escuela
	SELECT CodEscuela,Escuela,Facultad FROM TEscuela where Escuela like '%'+@ESCUELA+'%'
	--
END
GO


IF OBJECT_ID('spListarAlumno') IS NOT NULL DROP PROC spListarAlumno
GO
CREATE PROC spListarAlumno
AS
BEGIN
	SELECT CodAlumno,Apellidos,Nombres,LugarNac,FechaNac,CodEscuela FROM TAlumno
END
go


IF OBJECT_ID('spAgregarAlumno') IS NOT NULL DROP PROC spAgregarAlumno
GO
CREATE PROC spAgregarAlumno
@CODALUMNO CHAR(5),
@APELLIDOS VARCHAR(50),
@NOMBRES VARCHAR(50),
@LUGARNAC VARCHAR(50),
@FECHANAC datetime,
@CODESCUELA VARCHAR(3)
AS
BEGIN
	--CODAlumno NO PUEDE SER DUPLICADO
	IF NOT EXISTS (SELECT CodAlumno from TAlumno where CodAlumno=@CODALUMNO)
		IF EXISTS (SELECT CodEscuela from TEscuela where CodEscuela=@CODESCUELA)
			BEGIN
				INSERT INTO TAlumno VALUES(@CODALUMNO,@APELLIDOS,@NOMBRES,@LUGARNAC,@FECHANAC,@CODESCUELA)
				SELECT CODERROR=0, MENSAJE='Se insertó correctamente el alumno'
			END
		ELSE SELECT CODERROR=1, MENSAJE='ERROR: CodEscuela no Existe'
	ELSE SELECT CODERROR=1, MENSAJE='ERROR: CodAlumno duplicado'
	--
END
GO


IF OBJECT_ID('spEliminarAlumno') IS NOT NULL DROP PROC spEliminarAlumno
GO

CREATE PROC spEliminarAlumno
@CODALUMNO CHAR(5)
AS
BEGIN
	delete from TAlumno where CodAlumno=@CODALUMNO
	if ((SELECT @@ROWCOUNT AS DELETED)=1)
	    --Se Elimino un elemento
		SELECT CODERROR=0, MENSAJE='Se elimino correctamente el elumno'
	
	--El elemento no existe
	ELSE SELECT CODERROR=1, MENSAJE='ERROR: No existe el CodAlumno ingresado'
	--
END
GO



IF OBJECT_ID('spActualizarAlumno') IS NOT NULL DROP PROC spActualizarAlumno
GO

CREATE PROC spActualizarAlumno
@CODALUMNO CHAR(5),
@APELLIDOS VARCHAR(50),
@NOMBRES VARCHAR(50),
@LUGARNAC VARCHAR(50),
@FECHANAC datetime,
@CODESCUELA VARCHAR(3)
AS
BEGIN
	--Buscamos el Cod Alumno
	IF EXISTS (SELECT CodAlumno from TAlumno where CodAlumno=@CODALUMNO)
		--ESCUELA NO PUEDE SER DUPLICADA
		IF EXISTS (SELECT CodEscuela from TEscuela where CodEscuela=@CODESCUELA)
			BEGIN
				Update TAlumno set Apellidos=@APELLIDOS ,Nombres=@NOMBRES,LugarNac=@LUGARNAC,FechaNac=@FECHANAC,CodEscuela=@CODESCUELA Where CodEscuela=@CODESCUELA
				SELECT CODERROR=0, MENSAJE='Se Modifico correctamente el alumno'
			END
		ELSE SELECT CODERROR=1, MENSAJE='ERROR: CodEscuela no Existe'
	ELSE SELECT CODERROR=1, MENSAJE='ERROR: CodAlumno duplicado'
	--
END
GO



IF OBJECT_ID('spBuscarAlumno') IS NOT NULL DROP PROC spBuscarAlumno
GO

CREATE PROC spBuscarAlumno
@NOMBRE VARCHAR(50)
AS
BEGIN
	--Buscamos Escuela
	SELECT CodAlumno,Apellidos,Nombres,LugarNac,FechaNac,CodEscuela FROM TAlumno where Nombres+' '+Apellidos like '%'+@NOMBRE+'%'
	--
END
GO



