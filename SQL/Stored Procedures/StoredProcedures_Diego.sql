-- =============================================
-- Author:		<Diego Sol�s Jim�nez>
-- Create date: <9/10/2017>
-- Description:	Devuelve la informaci�n de las sucursales de la compa��a especificada, m�s el nombre y apellido de su administrador>
-- =============================================
CREATE PROCEDURE Select_TodoSucursales
	-- Add the parameters for the stored procedure here
	@IDCompa�ia int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT SUCURSAL.Nombre,EMPLEADO.Cedula as CedulaAdmin,EMPLEADO.Nombre1 as NombreAdmin,EMPLEADO.Apellido1 as ApellidoAdmin, 
	COMPA�IA.Nombre as NombreCompa�ia,SUCURSAL.Descripcion
	
	FROM ((SUCURSAL INNER JOIN EMPLEADO ON SUCURSAL.CedAdmin = EMPLEADO.Cedula) 
	INNER JOIN COMPA�IA ON SUCURSAL.IDCompa�ia = COMPA�IA.ID)
	
	WHERE COMPA�IA.ID = @IDCompa�ia AND SUCURSAL.Activo = 1
	FOR JSON PATH; 

END
GO