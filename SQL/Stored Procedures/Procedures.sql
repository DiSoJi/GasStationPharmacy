-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Efren Carvajal Valverde>
-- Create date: <09/10/2017>
-- Description:	<Comprueba en que condicion se encuentra un Cliente y lo modifica, ya sea activar o desactiva (Pseudo eliminaci�n)>
-- =============================================
CREATE PROCEDURE UpdateCLIENTE_Activo
	-- Add the parameters for the stored procedure here
	@Cedula int
AS
BEGIN
	if ((SELECT Activo from CLIENTE Where Cedula=@Cedula) = 1)
		BEGIN
			UPDATE CLIENTE SET Activo = 0 Where Cedula=@Cedula
		END
	else
		BEGIN
			UPDATE CLIENTE SET Activo = 1 Where Cedula=@Cedula
		END
END
GO
-- =============================================
-- Author:		<Efren Carvajal Valverde>
-- Create date: <9/10/2017>
-- Description:	Retorna todos los empleados de una compa�ia con toda la informacion completa (joins)>
-- =============================================
CREATE PROCEDURE Select_TodoEmpleados
	-- Add the parameters for the stored procedure here
	@NombreCompa�ia varchar(30)
AS
BEGIN

	DECLARE @IDCompa�ia int
	SELECT @IDCompa�ia = COMPA�IA.ID FROM COMPA�IA WHERE COMPA�IA.Nombre = @NombreCompa�ia
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT EMPLEADO.Nombre1, EMPLEADO.Nombre2, EMPLEADO.Apellido1, EMPLEADO.Apellido2, EMPLEADO.Provincia,
		EMPLEADO.Canton, EMPLEADO.Distrito, EMPLEADO.Indicaciones, EMPLEADO.Cedula, EMPLEADO.FNacimiento, EMPLEADO.Telefono,
		COMPA�IA.Nombre as Compa�ia, ROL.Descripcion as Roll, SUCURSAL.Nombre as Sucursal
	FROM (((EMPLEADO
		INNER JOIN COMPA�IA ON EMPLEADO.IDCompa�ia = COMPA�IA.ID)
		INNER JOIN ROL ON EMPLEADO.IDRol = ROL.ID)
		INNER JOIN SUCURSAL ON EMPLEADO.IDSucursal = SUCURSAL.ID)
	Where COMPA�IA.ID = @IDCompa�ia and EMPLEADO.Activo=1 
	FOR JSON PATH;
	
END
GO
-- =============================================
-- Author:		<Efren Carvajal Valverde>
-- Create date: <10/10/2017>
-- Description:	<INserta empleados en la tabla empleado con todas sus dependencias en correcto estado>
-- =============================================
CREATE PROCEDURE InsertEmpleado
	-- Add the parameters for the stored procedure here
	@Nombre1 varChar(20), @Nombre2 varChar(20), @Apellido1 varChar(20), @Apellido2 varChar(20), @Contrase�a varChar(20), @FNAcimiento date,
	@Provincia varChar(50), @Canton varChar(50), @Distrito varChar(50), @Indicaciones varChar(120), @Telefono int, @Rol varChar(20),
	@Compa�ia varChar(20), @Sucursal varChar(20), @Cedula int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @TempIDCompa�ia int;
	DECLARE @TempIDSucursal int;
	DECLARE @TempIDRol int;
    -- Insert statements for procedure here
	SELECT @TempIDCompa�ia = COMPA�IA.ID FROM COMPA�IA WHERE COMPA�IA.Nombre = @Compa�ia;
	SELECT @TempIDSucursal = SUCURSAL.ID FROM SUCURSAL WHERE SUCURSAL.Nombre = @Sucursal;
	SELECT @TempIDRol = ROL.ID FROM ROL WHERE ROL.Descripcion = @Rol;
	INSERT INTO EMPLEADO (Cedula, Apellido1, Apellido2, Nombre1, Nombre2, FNacimiento, Contrase�a, Provincia, Canton, Distrito, 
		Indicaciones, Telefono, IDRol, IDCompa�ia, IDSucursal, Activo)
     VALUES(@Cedula, @Apellido1, @Apellido2, @Nombre1, @Nombre2, @FNAcimiento, @Contrase�a, @Provincia, @Canton, @Distrito, 
		@Indicaciones,  @Telefono, @TempIDRol, @TempIDCompa�ia, @TempIDSucursal, 1)
	
END
GO
-- =============================================
-- Author:		<Efren Carvajal Valverde>
-- Create date: <10/10/2017>
-- Description:	<Comprueba en que condicion se encuentra un Empleado y lo modifica, ya sea activar o desactiva (Pseudo eliminaci�n)>
-- =============================================
CREATE PROCEDURE UpdateEmpleado_Activo 
	-- Add the parameters for the stored procedure here
	@Cedula int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if ((SELECT Activo from EMPLEADO Where Cedula=@Cedula) = 1)
		BEGIN
			UPDATE EMPLEADO SET Activo = 0 Where Cedula=@Cedula
		END
	else
		BEGIN
			UPDATE EMPLEADO SET Activo = 1 Where Cedula=@Cedula
		END
END
GO

-- =============================================
-- Author:		Efren Carvajal Valverde
-- Create date: 15/10/2017
-- Description:	Actualiza la informacion de un empleado
-- =============================================
CREATE PROCEDURE UpdateInfoEmpleado
	-- Add the parameters for the stored procedure here
	@Nombre1 varChar(20), @Nombre2 varChar(20), @Apellido1 varChar(20), @Apellido2 varChar(20), @Contrase�a varChar(20), @FNAcimiento date,
	@Provincia varChar(50), @Canton varChar(50), @Distrito varChar(50), @Indicaciones varChar(120), @Telefono int, @Rol varChar(20),
	@Compa�ia varChar(20), @Sucursal varChar(20), @Cedula int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET NOCOUNT ON;
	DECLARE @TempIDCompa�ia int;
	DECLARE @TempIDSucursal int;
	DECLARE @TempIDRol int;
    -- Insert statements for procedure here
	SELECT @TempIDCompa�ia = COMPA�IA.ID FROM COMPA�IA WHERE COMPA�IA.Nombre = @Compa�ia;
	SELECT @TempIDSucursal = SUCURSAL.ID FROM SUCURSAL WHERE SUCURSAL.Nombre = @Sucursal;
	SELECT @TempIDRol = ROL.ID FROM ROL WHERE ROL.Descripcion = @Rol;
	UPDATE EMPLEADO SET Cedula=@Cedula, Apellido1=@Apellido1, Apellido2=@Apellido2, Nombre1=@Nombre1, Nombre2=@Nombre1,
		FNacimiento=@FNAcimiento, Contrase�a=@Contrase�a, Provincia=@Provincia, Canton=@Canton, Distrito=@Distrito, 
		Indicaciones=@Indicaciones, Telefono=@Telefono, IDRol=@TempIDRol, IDCompa�ia=@TempIDCompa�ia, 
		IDSucursal=@TempIDSucursal, Activo=1
	WHERE EMPLEADO.Cedula = @Cedula
END
GO
-- =============================================
-- Author:		Efren Carvajal Valverde
-- Create date: 15/10/17
-- Description:	Devuelve la informacion de un empelado especifico(login)
-- =============================================
CREATE PROCEDURE SelectInfoEmpleado 
	-- Add the parameters for the stored procedure here
	@IDEmpleado int,
	@Pass VarChar(20)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT EMPLEADO.Nombre1, EMPLEADO.Nombre2, EMPLEADO.Apellido1, EMPLEADO.Apellido2, EMPLEADO.Provincia,
		EMPLEADO.Canton, EMPLEADO.Distrito, EMPLEADO.Indicaciones, EMPLEADO.Cedula, EMPLEADO.FNacimiento, EMPLEADO.Telefono,
		COMPA�IA.Nombre as Compa�ia, ROL.Descripcion as Roll, SUCURSAL.Nombre as Sucursal
	FROM (((EMPLEADO
		INNER JOIN COMPA�IA ON EMPLEADO.IDCompa�ia = COMPA�IA.ID)
		INNER JOIN ROL ON EMPLEADO.IDRol = ROL.ID)
		INNER JOIN SUCURSAL ON EMPLEADO.IDSucursal = SUCURSAL.ID)
	Where EMPLEADO.Cedula = @IDEmpleado and EMPLEADO.Contrase�a=@Pass and EMPLEADO.Activo=1 
	FOR JSON PATH , WITHOUT_ARRAY_WRAPPER;;
END
GO
-- =============================================
-- Author:		Efren Carvajal Valverde
-- Create date: 17/10/17
-- Description:	Insertar una compa�ia 
-- =============================================
CREATE PROCEDURE InsertSucursal
	-- Add the parameters for the stored procedure here
	@CedAdmin int, @Nombre VarChar(30), @Descripcion VarChar(30), @Provincia VarChar(50), 
	@Canton VarChar(50), @Distrito VarChar(50), @Indicaciones VarChar(120), @NombreComp VarChar(30)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @TempIDCompa�ia int
    -- Insert statements for procedure here
	SELECT @TempIDCompa�ia = COMPA�IA.ID FROM COMPA�IA WHERE COMPA�IA.Nombre = @NombreComp;

	INSERT INTO SUCURSAL  (CedAdmin, Nombre, Descripcion, Provincia, Canton, Distrito, 
		Indicaciones, IDCompa�ia, Activo)
     VALUES(@CedAdmin, @Nombre, @Descripcion, @Provincia, @Canton, @Distrito, 
		@Indicaciones, @TempIDCompa�ia,  1)
END
GO
-- =============================================
-- Author:		<Efren Carvajal Valverde>
-- Create date: <09/10/2017>
-- Description:	<Comprueba en que condicion se encuentra una Sucursal  y lo modifica, ya sea activar o desactiva (Pseudo eliminaci�n)>
-- =============================================
CREATE PROCEDURE UpdateSucursal_Activo
	-- Add the parameters for the stored procedure here
	@IDSucursal  int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if ((SELECT Activo from SUCURSAL Where ID=@IDSucursal) = 1)
		BEGIN
			UPDATE SUCURSAL SET Activo = 0 Where ID=@IDSucursal
		END
	else
		BEGIN
			UPDATE SUCURSAL SET Activo = 1 Where ID=@IDSucursal
		END
END
GO
-- =============================================
-- Author:		Efren Carvajal Valverde
-- Create date: 17/10/17
-- Description:	Actualizar Sucursal 
-- =============================================
CREATE PROCEDURE UpdateInfoSucursal 
	-- Add the parameters for the stored procedure here
	@CedAdmin int, @Nombre VarChar(30), @Descripcion VarChar(30), @Provincia VarChar(50), 
	@Canton VarChar(50), @Distrito VarChar(50), @Indicaciones VarChar(120)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	UPDATE SUCURSAL SET CedAdmin=@CedAdmin, Nombre=@Nombre, Descripcion=@Descripcion, Provincia=@Provincia, Canton=@Canton,
						Distrito=@Distrito, Indicaciones=@Indicaciones, Activo=1
	WHERE CedAdmin = @CedAdmin
END
GO

