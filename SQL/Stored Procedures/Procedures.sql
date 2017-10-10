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
	@IDCompa�ia int
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
