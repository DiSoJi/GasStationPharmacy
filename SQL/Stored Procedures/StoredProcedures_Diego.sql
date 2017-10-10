-- =============================================
-- Author:		<Diego Sol�s Jim�nez>
-- Create date: <9/10/2017>
-- Description:	<Devuelve la informaci�n de las sucursales de la compa��a especificada, m�s el nombre y apellido de su administrador>
-- =============================================
CREATE PROCEDURE Select_TodoSucursales
	-- Add the parameters for the stored procedure here
	@IDCompa�ia int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT SUCURSAL.ID,SUCURSAL.Nombre,EMPLEADO.Cedula as CedulaAdmin,EMPLEADO.Nombre1 as NombreAdmin,EMPLEADO.Apellido1 as ApellidoAdmin, 
	COMPA�IA.Nombre as NombreCompa�ia,SUCURSAL.Descripcion
	
	FROM ((SUCURSAL INNER JOIN EMPLEADO ON SUCURSAL.CedAdmin = EMPLEADO.Cedula) 
	INNER JOIN COMPA�IA ON SUCURSAL.IDCompa�ia = COMPA�IA.ID)
	
	WHERE COMPA�IA.ID = @IDCompa�ia AND SUCURSAL.Activo = 1
	FOR JSON PATH; 

END
GO


-- =============================================
-- Author:		<Diego Sol�s Jim�nez>
-- Create date: <9/10/2017>
-- Description:	<Devuelve los datos m�s importantes de los pedidos por compa��a>
-- =============================================
CREATE PROCEDURE Select_TodoPedidos
	-- Add the parameters for the stored procedure here
	@IDCompa�ia int
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
	
	WHERE SUCURSAL.IDCompa�ia = @IDCompa�ia AND CONT_PEDIDO.Activo = 1
	FOR JSON PATH; 

END
GO

-- =============================================
-- Author:		<Diego Sol�s Jim�nez>
-- Create date: <9/10/2017>
-- Description:	<Devuelve los datos m�s importantes de los pedidos por Cliente>
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
-- Author:		<Diego Sol�s Jim�nez>
-- Create date: <9/10/2017>
-- Description:	<Devuelve los datos m�s importantes de los Clientes por compa��a>
-- =============================================
CREATE PROCEDURE Select_TodoClientes
	-- Add the parameters for the stored procedure here
	@IDCompa�ia int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT CLIENTE.Nombre1,CLIENTE.Nombre2,CLIENTE.Apellido1,CLIENTE.Apellido2,CLIENTE.Cedula,CLIENTE.FNacimiento,CLIENTE.Telefono,CLIENTE.Provincia,
	CLIENTE.Canton,CLIENTE.Distrito,CLIENTE.Indicaciones,PADECIMIENTOS.Descripcion

	FROM (CLIENTE FULL OUTER JOIN PADECIMIENTOS ON CLIENTE.Cedula = PADECIMIENTOS.CedulaCliente) INNER JOIN (DESC_PEDIDO INNER JOIN SUCURSAL ON DESC_PEDIDO.IDSucursal = SUCURSAL.ID) ON DESC_PEDIDO.CedCliente = CLIENTE.Cedula

	WHERE SUCURSAL.IDCompa�ia = @IDCompa�ia AND CLIENTE.Activo = 1 
	FOR JSON PATH; 

END
GO