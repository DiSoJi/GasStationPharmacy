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
	COMPAÑIA.Nombre as NombreCompañia,SUCURSAL.Descripcion, SUCURSAL.Provincia, SUCURSAL.Canton, SUCURSAL.Distrito, SUCURSAL.Indicaciones
	
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


	SELECT DESC_PEDIDO.ID,CLIENTE.Cedula AS CedulaCliente,CLIENTE.Nombre1 AS NombreCliente,CLIENTE.Apellido1 AS ApellidoCliente,SUCURSAL.Nombre AS NombreSucursal,
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
-- Description:	<Devuelve el nombre y la cantidad de todos los productos vendidos por compañía>
-- =============================================
--Devolverlos en orden
CREATE PROCEDURE Estadistica_MasVendidosxCompañia
	-- Add the parameters for the stored procedure here
	@IDCompañia int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT CONT_PEDIDO.NombreMedicamento,DESC_PEDIDO.Cantidad
	
	FROM (((RECETA INNER JOIN EMPLEADO ON RECETA.CedDoctor = EMPLEADO.Cedula) 
	FULL OUTER JOIN ((CONT_PEDIDO INNER JOIN ((DESC_PEDIDO INNER JOIN CLIENTE ON DESC_PEDIDO.CedCliente = CLIENTE.Cedula) 
	INNER JOIN SUCURSAL ON DESC_PEDIDO.IDSucursal = SUCURSAL.ID) ON CONT_PEDIDO.IDPedido = DESC_PEDIDO.ID) 
	INNER JOIN MEDICAMENTO ON CONT_PEDIDO.NombreMedicamento = MEDICAMENTO.Nombre) ON CONT_PEDIDO.IDReceta = RECETA.ID))
	
	WHERE SUCURSAL.IDCompañia = @IDCompañia AND (DESC_PEDIDO.Estado = 'Facturado' OR DESC_PEDIDO.ESTADO = 'Retirado')
	FOR JSON PATH; 

END
GO


-- =============================================
-- Author:		<Diego Solís Jiménez>
-- Create date: <9/10/2017>
-- Description:	<Devuelve el nombre y la cantidad de todos los productos vendidos de todas las compañías>
-- =============================================

--Devolverlos en orden
CREATE PROCEDURE Estadistica_MasVendidostotal

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT CONT_PEDIDO.NombreMedicamento,DESC_PEDIDO.Cantidad
	
	FROM (((RECETA INNER JOIN EMPLEADO ON RECETA.CedDoctor = EMPLEADO.Cedula) 
	FULL OUTER JOIN ((CONT_PEDIDO INNER JOIN ((DESC_PEDIDO INNER JOIN CLIENTE ON DESC_PEDIDO.CedCliente = CLIENTE.Cedula) 
	INNER JOIN SUCURSAL ON DESC_PEDIDO.IDSucursal = SUCURSAL.ID) ON CONT_PEDIDO.IDPedido = DESC_PEDIDO.ID) 
	INNER JOIN MEDICAMENTO ON CONT_PEDIDO.NombreMedicamento = MEDICAMENTO.Nombre) ON CONT_PEDIDO.IDReceta = RECETA.ID))
	
	WHERE DESC_PEDIDO.Estado = 'Facturado' OR DESC_PEDIDO.ESTADO = 'Retirado'
	FOR JSON PATH; 

END
GO


-- =============================================
-- Author:		<Diego Solís Jiménez>
-- Create date: <9/10/2017>
-- Description:	<Devuelve el nombre y la cantidad de todos los productos vendidos por compañía>
-- =============================================
CREATE PROCEDURE Estadistica_VentasxCompañia
	-- Add the parameters for the stored procedure here
	@IDCompañia int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT COUNT(DESC_PEDIDO.Estado)
	
	FROM (((RECETA INNER JOIN EMPLEADO ON RECETA.CedDoctor = EMPLEADO.Cedula) 
	FULL OUTER JOIN ((CONT_PEDIDO INNER JOIN ((DESC_PEDIDO INNER JOIN CLIENTE ON DESC_PEDIDO.CedCliente = CLIENTE.Cedula) 
	INNER JOIN SUCURSAL ON DESC_PEDIDO.IDSucursal = SUCURSAL.ID) ON CONT_PEDIDO.IDPedido = DESC_PEDIDO.ID) 
	INNER JOIN MEDICAMENTO ON CONT_PEDIDO.NombreMedicamento = MEDICAMENTO.Nombre) ON CONT_PEDIDO.IDReceta = RECETA.ID))
	
	WHERE SUCURSAL.IDCompañia = @IDCompañia AND (DESC_PEDIDO.Estado = 'Facturado' OR DESC_PEDIDO.ESTADO = 'Retirado')
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


-- =============================================
-- Author:		<Diego Solís Jiménez>
-- Create date: <9/10/2017>
-- Description:	<Devuelve los datos más importantes de los Medicamentos por compañía(Haciendo enfasis en su cantidad por sucursal)>
-- =============================================

CREATE PROCEDURE Select_TodoMedicamentos
	-- Add the parameters for the stored procedure here
	@IDCompañia int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT MEDICAMENTO.Nombre,MEDICAMENTO.Prescripcion,MEDICAMENTO.CasaFarmaceutica,SUCURSAL.Nombre as Sucursal,SUC_MEDICAMENTO.Cantidad

	FROM (MEDICAMENTO INNER JOIN SUC_MEDICAMENTO ON SUC_MEDICAMENTO.NombreMedicamento = MEDICAMENTO.Nombre) INNER JOIN SUCURSAL ON SUC_MEDICAMENTO.IDSucursal = SUCURSAL.ID

	WHERE SUCURSAL.IDCompañia = @IDCompañia AND SUCURSAL.Activo = 1 AND MEDICAMENTO.Activo = 1 
	FOR JSON PATH; 

END
GO

-- =============================================
-- Author:		<Diego Solís Jiménez>
-- Create date: <9/10/2017>
-- Description:	<Agrega un medicamento, actualizando la tabla de SUC_MEDICAMENTO, y calculando la cantidad total entre las compañías>
-- =============================================
CREATE PROCEDURE Insert_Medicamento
	-- Add the parameters for the stored procedure here
	@NombreMedicamento varchar(30),
	@CasaFarmaceutica varchar(30),
	@IDSucursal int,
	@Cantidad int,
	@Prescripcion bit
	
AS
BEGIN

	INSERT INTO MEDICAMENTO VALUES (@NombreMedicamento,@CasaFarmaceutica,@Prescripcion, 0, 1);
	INSERT INTO SUC_MEDICAMENTO(NombreMedicamento,IDSucursal,Cantidad,Activo) VALUES (@NombreMedicamento,@IDSucursal,@Cantidad,1);
	UPDATE MEDICAMENTO SET MEDICAMENTO.CantidadTotal = (SELECT SUM(SUC_MEDICAMENTO.Cantidad) FROM SUC_MEDICAMENTO WHERE SUC_MEDICAMENTO.IDSucursal = @IDSucursal AND SUC_MEDICAMENTO.NombreMedicamento = @NombreMedicamento) WHERE MEDICAMENTO.Nombre = @NombreMedicamento;

END
GO


-- =============================================
-- Author:		<Diego Solís Jiménez>
-- Create date: <10/10/2017>
-- Description:	<Elimina un medicamento, actualizando la tabla de SUC_MEDICAMENTO poniendo Activo en cero (Borrado Lógico), Para la sucursal indicada>
-- =============================================

CREATE PROCEDURE Delete_MedicamentoxSucursal
	-- Add the parameters for the stored procedure here
	@NombreMedicamento varchar(30),
	@IDSucursal int
AS
BEGIN

	UPDATE SUC_MEDICAMENTO SET SUC_MEDICAMENTO.Activo = 0 WHERE (SUC_MEDICAMENTO.NombreMedicamento = @NombreMedicamento AND SUC_MEDICAMENTO.IDSucursal = @IDSucursal)

END
GO

-- =============================================
-- Author:		<Efren Carvajal Valverde>
-- Create date: <10/10/2017>
-- Description:	<Elimina un medicamento, actualizando la tabla de SUC_MEDICAMENTO poniendo Activo en cero (Borrado Lógico) Para todas las sucursales de una compañia>
-- =============================================

CREATE PROCEDURE Delete_MedicamentoxCompañia
	-- Add the parameters for the stored procedure here
	@NombreMedicamento varchar(30),
	@NombreCompañia varchar(30)

AS
BEGIN
	
	DECLARE @TempIDCompañia int
	DECLARE @NumeroSucursales int
	DECLARE @i int = 1
	DECLARE @Cantidad int
	SELECT @NumeroSucursales = COUNT(*) FROM SUCURSAL
	SELECT @TempIDCompañia = COMPAÑIA.ID FROM COMPAÑIA WHERE COMPAÑIA.Nombre = @NombreCompañia
	
	  

	While(@i <= @NumeroSucursales)
	BEGIN

		if( (SELECT IDCompañia FROM SUCURSAL WHERE SUCURSAL.ID = @i) = @TempIDCompañia)
		BEGIN
			SELECT @Cantidad = SUC_MEDICAMENTO.Cantidad FROM SUC_MEDICAMENTO WHERE MEDICAMENTO.Nombre = @NombreMedicamento
			UPDATE MEDICAMENTO SET MEDICAMENTO.CantidadTotal = MEDICAMENTO.CantidadTotal - @Cantidad
			UPDATE SUC_MEDICAMENTO SET SUC_MEDICAMENTO.Activo = 0,SUC_MEDICAMENTO.Cantidad = 0  WHERE SUC_MEDICAMENTO.IDSucursal = @i AND SUC_MEDICAMENTO.NombreMedicamento = @NombreMedicamento
		END
		SET @i = @i + 1
	END
	
END
GO 
