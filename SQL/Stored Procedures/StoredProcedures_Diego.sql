-- =============================================
-- Author:		<Diego Solís Jiménez>
-- Create date: <9/10/2017>
-- Description:	Devuelve la información de las sucursales de la compañía especificada, más el nombre y apellido de su administrador>
-- =============================================
CREATE PROCEDURE Select_TodoSucursales
	-- Add the parameters for the stored procedure here
	@IDCompañia int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT SUCURSAL.Nombre,EMPLEADO.Cedula as CedulaAdmin,EMPLEADO.Nombre1 as NombreAdmin,EMPLEADO.Apellido1 as ApellidoAdmin, 
	COMPAÑIA.Nombre as NombreCompañia,SUCURSAL.Descripcion
	
	FROM ((SUCURSAL INNER JOIN EMPLEADO ON SUCURSAL.CedAdmin = EMPLEADO.Cedula) 
	INNER JOIN COMPAÑIA ON SUCURSAL.IDCompañia = COMPAÑIA.ID)
	
	WHERE COMPAÑIA.ID = @IDCompañia AND SUCURSAL.Activo = 1
	FOR JSON PATH; 

END
GO