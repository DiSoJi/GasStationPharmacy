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
-- Description:	<Comprueba en que condicion se encuentra un Cliente y lo modifica, ya sea activar o desactiva (Pseudo eliminación)>
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
-- Create date: <10/10/2017>
-- Description:	Retorna todos los empleados de una compañia con toda la informacion completa (joins)>
-- =============================================
CREATE PROCEDURE Select_TodoEmpleados
	-- Add the parameters for the stored procedure here
	@IDCompañia int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT EMPLEADO.Nombre1, EMPLEADO.Nombre2, EMPLEADO.Apellido1, EMPLEADO.Apellido2, EMPLEADO.Provincia,
		EMPLEADO.Canton, EMPLEADO.Distrito, EMPLEADO.Indicaciones, EMPLEADO.Cedula, EMPLEADO.FNacimiento, EMPLEADO.Telefono,
		COMPAÑIA.Nombre as Compañia, ROL.Descripcion as Roll, SUCURSAL.Nombre as Sucursal
	FROM (((EMPLEADO
		INNER JOIN COMPAÑIA ON EMPLEADO.IDCompañia = COMPAÑIA.ID)
		INNER JOIN ROL ON EMPLEADO.IDRol = ROL.ID)
		INNER JOIN SUCURSAL ON EMPLEADO.IDSucursal = SUCURSAL.ID)
	Where COMPAÑIA.ID = 1 and EMPLEADO.Activo=1 
	FOR JSON PATH;
	
END
GO