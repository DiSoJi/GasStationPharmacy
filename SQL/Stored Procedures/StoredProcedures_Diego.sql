-- =============================================
-- Author:		<Diego Solís Jiménez>
-- Create date: <9/10/2017>
-- Description:	<Devuelve la información de las sucursales de la compañía especificada, más el nombre y apellido de su administrador>
-- =============================================
CREATE PROCEDURE Select_TodoSucursales
	-- Add the parameters for the stored procedure here
	@IDCompañia int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT SUCURSAL.ID,SUCURSAL.Nombre,EMPLEADO.Cedula as CedulaAdmin,EMPLEADO.Nombre1 as NombreAdmin,EMPLEADO.Apellido1 as ApellidoAdmin, 
	COMPAÑIA.Nombre as NombreCompañia,SUCURSAL.Descripcion
	
	FROM ((SUCURSAL INNER JOIN EMPLEADO ON SUCURSAL.CedAdmin = EMPLEADO.Cedula) 
	INNER JOIN COMPAÑIA ON SUCURSAL.IDCompañia = COMPAÑIA.ID)
	
	WHERE COMPAÑIA.ID = @IDCompañia AND SUCURSAL.Activo = 1
	FOR JSON PATH; 

END
GO


-- =============================================
-- Author:		<Diego Solís Jiménez>
-- Create date: <9/10/2017>
-- Description:	<Devuelve los datos más importantes de los pedidos por compañía>
-- =============================================
CREATE PROCEDURE Select_TodoPedidos
	-- Add the parameters for the stored procedure here
	@IDCompañia int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT CONT_PEDIDO.ID,CLIENTE.Cedula AS CedulaCliente,CLIENTE.Nombre1 AS NombreCliente,CLIENTE.Apellido1 AS ApellidoCliente,SUCURSAL.Nombre AS NombreSucursal,
	DESC_PEDIDO.Telefono,DESC_PEDIDO.HoraRecojo,DESC_PEDIDO.FechaRecojo,DESC_PEDIDO.Estado, MEDICAMENTO.Nombre as NombreMedicamento, DESC_PEDIDO.Cantidad, EMPLEADO.Cedula as CedulaDoctor,RECETA.Foto
	
	FROM (((RECETA INNER JOIN EMPLEADO ON RECETA.CedDoctor = EMPLEADO.Cedula) 
	FULL OUTER JOIN ((CONT_PEDIDO INNER JOIN ((DESC_PEDIDO INNER JOIN CLIENTE ON DESC_PEDIDO.CedCliente = CLIENTE.Cedula) 
	INNER JOIN SUCURSAL ON DESC_PEDIDO.IDSucursal = SUCURSAL.ID) ON CONT_PEDIDO.IDPedido = DESC_PEDIDO.ID) 
	INNER JOIN MEDICAMENTO ON CONT_PEDIDO.NombreMedicamento = MEDICAMENTO.Nombre) ON CONT_PEDIDO.IDReceta = RECETA.ID))
	
	WHERE SUCURSAL.IDCompañia = @IDCompañia AND CONT_PEDIDO.Activo = 1
	FOR JSON PATH; 

END
GO

-- =============================================
-- Author:		<Diego Solís Jiménez>
-- Create date: <9/10/2017>
-- Description:	<Devuelve los datos más importantes de los pedidos por Cliente>
-- =============================================
CREATE PROCEDURE Select_PedidosxCliente
	-- Add the parameters for the stored procedure here
	@CedulaCliente int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT CONT_PEDIDO.ID,CLIENTE.Cedula AS CedulaCliente,CLIENTE.Nombre1 AS NombreCliente,CLIENTE.Apellido1 AS ApellidoCliente,SUCURSAL.Nombre AS NombreSucursal,
	DESC_PEDIDO.Telefono,DESC_PEDIDO.HoraRecojo,DESC_PEDIDO.FechaRecojo,DESC_PEDIDO.Estado, MEDICAMENTO.Nombre as NombreMedicamento, DESC_PEDIDO.Cantidad, EMPLEADO.Cedula as CedulaDoctor,RECETA.Foto
	
	FROM (((RECETA INNER JOIN EMPLEADO ON RECETA.CedDoctor = EMPLEADO.Cedula) 
	FULL OUTER JOIN ((CONT_PEDIDO INNER JOIN ((DESC_PEDIDO INNER JOIN CLIENTE ON DESC_PEDIDO.CedCliente = CLIENTE.Cedula) 
	INNER JOIN SUCURSAL ON DESC_PEDIDO.IDSucursal = SUCURSAL.ID) ON CONT_PEDIDO.IDPedido = DESC_PEDIDO.ID) 
	INNER JOIN MEDICAMENTO ON CONT_PEDIDO.NombreMedicamento = MEDICAMENTO.Nombre) ON CONT_PEDIDO.IDReceta = RECETA.ID))
	
	WHERE CLIENTE.Cedula = @CedulaCliente AND CONT_PEDIDO.Activo = 1
	FOR JSON PATH;

END
GO


-- =============================================
-- Author:		<Diego Solís Jiménez>
-- Create date: <9/10/2017>
-- Description:	<Devuelve los datos más importantes de los Clientes por compañía>
-- =============================================
CREATE PROCEDURE Select_TodoClientes
	-- Add the parameters for the stored procedure here
	@IDCompañia int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT CLIENTE.Nombre1,CLIENTE.Nombre2,CLIENTE.Apellido1,CLIENTE.Apellido2,CLIENTE.Cedula,CLIENTE.FNacimiento,CLIENTE.Telefono,CLIENTE.Provincia,
	CLIENTE.Canton,CLIENTE.Distrito,CLIENTE.Indicaciones,PADECIMIENTOS.Descripcion

	FROM (CLIENTE FULL OUTER JOIN PADECIMIENTOS ON CLIENTE.Cedula = PADECIMIENTOS.CedulaCliente) INNER JOIN (DESC_PEDIDO INNER JOIN SUCURSAL ON DESC_PEDIDO.IDSucursal = SUCURSAL.ID) ON DESC_PEDIDO.CedCliente = CLIENTE.Cedula

	WHERE SUCURSAL.IDCompañia = @IDCompañia AND CLIENTE.Activo = 1 
	FOR JSON PATH; 

END
GO