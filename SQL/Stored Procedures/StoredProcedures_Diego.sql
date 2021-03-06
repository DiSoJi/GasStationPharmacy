-- =============================================
-- Author:		<Diego Sol�s Jim�nez>
-- Create date: <9/10/2017>
-- Description:	<Devuelve la informaci�n de las sucursales de la compa��a especificada, m�s el nombre y apellido de su administrador>
-- =============================================
CREATE PROCEDURE Select_TodoSucursales
	-- Add the parameters for the stored procedure here
	@NombreCompa�ia varchar(30)
AS
BEGIN

	DECLARE @IDCompa�ia int
	SELECT @IDCompa�ia = COMPA�IA.ID FROM COMPA�IA WHERE COMPA�IA.Nombre = @NombreCompa�ia
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT SUCURSAL.ID,SUCURSAL.Nombre,EMPLEADO.Cedula as CedulaAdmin,EMPLEADO.Nombre1 as NombreAdmin,EMPLEADO.Apellido1 as ApellidoAdmin, 
	COMPA�IA.Nombre as NombreCompa�ia,SUCURSAL.Descripcion, SUCURSAL.Provincia, SUCURSAL.Canton, SUCURSAL.Distrito, SUCURSAL.Indicaciones
	
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
	@NombreCompa�ia varchar(30)
AS
BEGIN
	DECLARE @IDCompa�ia int
	SELECT @IDCompa�ia = COMPA�IA.ID FROM COMPA�IA WHERE COMPA�IA.Nombre = @NombreCompa�ia
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT DISTINCT DESC_PEDIDO.ID,CLIENTE.Cedula AS CedulaCliente,CLIENTE.Nombre1 AS NombreCliente,CLIENTE.Apellido1 AS ApellidoCliente,SUCURSAL.Nombre AS NombreSucursal,
	DESC_PEDIDO.Telefono,DESC_PEDIDO.HoraRecojo,DESC_PEDIDO.FechaRecojo,DESC_PEDIDO.Estado, MEDICAMENTO.Nombre as NombreMedicamento, CONT_PEDIDO.Cantidad, EMPLEADO.Cedula as CedulaDoctor,RECETA.Foto
	
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
-- Description:	<Cambia el estado de un pedido (nuevo, preparado, facturado y retirado)>
-- =============================================

CREATE PROCEDURE Update_Pedido

	@IDSucursal int,
	@IDDescPedido int,
	@Estado varchar(15)
AS
BEGIN

	UPDATE DESC_PEDIDO SET Estado = @Estado WHERE DESC_PEDIDO.ID = @IDDescPedido AND DESC_PEDIDO.IDSucursal =  @IDSucursal

END
GO


-- =============================================
-- Author:		<Diego Sol�s Jim�nez>
-- Create date: <14/10/2017>
-- Description:	<Crea un pedido, con un estado de nuevo y devuelve el ID del pedido creado>
-- =============================================

CREATE PROCEDURE Create_Pedido

	@IDSucursal int,
	@CedulaCliente int,
	@Telefono int,
	@HoraRecojo time,
	@FechaRecojo date
	
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @IDPedido int
	
	INSERT INTO DESC_PEDIDO(CedCliente,IDSucursal,Telefono,HoraRecojo,FechaRecojo,Estado,Activo) VALUES (@CedulaCliente,@IDSucursal,@Telefono,@HoraRecojo,@FechaRecojo,'Nuevo',1)
	SELECT @IDPedido = COUNT(*) FROM DESC_PEDIDO
	SELECT @IDPedido AS IDPedido
	FOR JSON PATH; 
END
GO

-- =============================================
-- Author:		<Diego Sol�s Jim�nez>
-- Create date: <14/10/2017>
-- Description:	<Crea un pedido, con un estado de nuevo y devuelve el ID del pedido creado>
-- =============================================

CREATE PROCEDURE Create_CONT_Pedido

	@IDPedido int,
	@NombreMedicamento varchar(30),
	@IDReceta int,
	@Cantidad int
	
AS
BEGIN

	INSERT INTO CONT_PEDIDO(IDPedido,NombreMedicamento,Cantidad,IDReceta,Activo) VALUES (@IDPedido,@NombreMedicamento,@IDReceta,@Cantidad,1);

END
GO

-- =============================================
-- Author:		<Diego Sol�s Jim�nez>
-- Create date: <9/10/2017>
-- Description:	<Devuelve el nombre y la cantidad de todos los productos vendidos por compa��a>
-- =============================================

CREATE PROCEDURE Estadistica_MasVendidosxCompa�ia
	-- Add the parameters for the stored procedure here
	@NombreCompa�ia varchar(30)
AS
BEGIN
	DECLARE @IDCompa�ia int
	SELECT @IDCompa�ia = COMPA�IA.ID FROM COMPA�IA WHERE COMPA�IA.Nombre = @NombreCompa�ia
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT CONT_PEDIDO.NombreMedicamento,CONT_PEDIDO.Cantidad
	
	FROM (CONT_PEDIDO INNER JOIN DESC_PEDIDO ON CONT_PEDIDO.IDPedido = DESC_PEDIDO.ID) INNER JOIN SUCURSAL ON SUCURSAL.ID = DESC_PEDIDO.IDSucursal
	WHERE SUCURSAL.IDCompa�ia = @IDCompa�ia AND (DESC_PEDIDO.Estado = 'Facturado' OR DESC_PEDIDO.ESTADO = 'Retirado')

	ORDER BY CONT_PEDIDO.NombreMedicamento

	FOR JSON PATH; 

END
GO


-- =============================================
-- Author:		<Diego Sol�s Jim�nez>
-- Create date: <9/10/2017>
-- Description:	<Devuelve el nombre y la cantidad de todos los productos vendidos de todas las compa��as>
-- =============================================

CREATE PROCEDURE Estadistica_MasVendidostotal

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT DISTINCT CONT_PEDIDO.NombreMedicamento,CONT_PEDIDO.Cantidad
	
	FROM CONT_PEDIDO INNER JOIN DESC_PEDIDO ON CONT_PEDIDO.IDPedido = DESC_PEDIDO.ID
	WHERE DESC_PEDIDO.Estado = 'Facturado' OR DESC_PEDIDO.ESTADO = 'Retirado'

	ORDER BY CONT_PEDIDO.Cantidad DESC
	FOR JSON PATH; 

END
GO


-- =============================================
-- Author:		<Diego Sol�s Jim�nez>
-- Create date: <9/10/2017>
-- Description:	<Devuelve el nombre y la cantidad de todos los productos vendidos por compa��a>
-- =============================================
CREATE PROCEDURE Estadistica_VentasxCompa�ia
	-- Add the parameters for the stored procedure here
	@NombreCompa�ia varchar(30)
AS
BEGIN

	DECLARE @IDCompa�ia int
	SELECT @IDCompa�ia = COMPA�IA.ID FROM COMPA�IA WHERE COMPA�IA.Nombre = @NombreCompa�ia
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT DISTINCT COUNT(DESC_PEDIDO.Estado) AS CantidadVentas
	
	FROM DESC_PEDIDO INNER JOIN SUCURSAL ON SUCURSAL.ID = DESC_PEDIDO.IDSucursal

	WHERE SUCURSAL.IDCompa�ia = @IDCompa�ia AND (DESC_PEDIDO.Estado = 'Facturado' OR DESC_PEDIDO.ESTADO = 'Retirado')
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


	SELECT DISTINCT CONT_PEDIDO.ID,CLIENTE.Cedula AS CedulaCliente,CLIENTE.Nombre1 AS NombreCliente,CLIENTE.Apellido1 AS ApellidoCliente,SUCURSAL.Nombre AS NombreSucursal,
	DESC_PEDIDO.Telefono,DESC_PEDIDO.HoraRecojo,DESC_PEDIDO.FechaRecojo,DESC_PEDIDO.Estado, CONT_PEDIDO.NombreMedicamento as NombreMedicamento, CONT_PEDIDO.Cantidad, RECETA.CedDoctor as CedulaDoctor,RECETA.Foto
	
	FROM (((RECETA INNER JOIN EMPLEADO ON RECETA.CedDoctor = EMPLEADO.Cedula) 
	FULL OUTER JOIN ((CONT_PEDIDO INNER JOIN ((DESC_PEDIDO INNER JOIN CLIENTE ON DESC_PEDIDO.CedCliente = CLIENTE.Cedula) 
	INNER JOIN SUCURSAL ON DESC_PEDIDO.IDSucursal = SUCURSAL.ID) ON CONT_PEDIDO.IDPedido = DESC_PEDIDO.ID) 
	INNER JOIN MEDICAMENTO ON CONT_PEDIDO.NombreMedicamento = MEDICAMENTO.Nombre) ON CONT_PEDIDO.IDReceta = RECETA.ID))
	
	--FROM ((CLIENTE INNER JOIN (DESC_PEDIDO INNER JOIN SUCURSAL ON DESC_PEDIDO.IDSucursal = SUCURSAL.ID) ON CLIENTE.Cedula = DESC_PEDIDO.CedCliente) INNER JOIN (CONT_PEDIDO FULL OUTER JOIN RECETA ON CONT_PEDIDO.IDReceta = RECETA.ID))
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
	@NombreCompa�ia varchar(30)
AS
BEGIN

	DECLARE @IDCompa�ia int
	SELECT @IDCompa�ia = COMPA�IA.ID FROM COMPA�IA WHERE COMPA�IA.Nombre = @NombreCompa�ia
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT DISTINCT CLIENTE.Nombre1,CLIENTE.Nombre2,CLIENTE.Apellido1,CLIENTE.Apellido2,CLIENTE.Cedula,CLIENTE.FNacimiento,CLIENTE.Telefono,CLIENTE.Provincia,
	CLIENTE.Canton,CLIENTE.Distrito,CLIENTE.Indicaciones,PADECIMIENTOS.Descripcion,PADECIMIENTOS.FechaPadecimiento

	FROM (CLIENTE FULL OUTER JOIN PADECIMIENTOS ON CLIENTE.Cedula = PADECIMIENTOS.CedulaCliente) INNER JOIN (DESC_PEDIDO INNER JOIN SUCURSAL ON DESC_PEDIDO.IDSucursal = SUCURSAL.ID) ON DESC_PEDIDO.CedCliente = CLIENTE.Cedula

	WHERE SUCURSAL.IDCompa�ia = @IDCompa�ia AND CLIENTE.Activo = 1 

	ORDER BY CLIENTE.Cedula DESC

	FOR JSON PATH; 

END
GO


-- =============================================
-- Author:		<Diego Sol�s Jim�nez>
-- Create date: <9/10/2017>
-- Description:	<Devuelve los datos m�s importantes de los Medicamentos por compa��a(Haciendo enfasis en su cantidad por sucursal)>
-- =============================================

CREATE PROCEDURE Select_TodoMedicamentos
	-- Add the parameters for the stored procedure here
	@NombreCompa�ia varchar(30)
AS
BEGIN

	DECLARE @IDCompa�ia int
	SELECT @IDCompa�ia = COMPA�IA.ID FROM COMPA�IA WHERE COMPA�IA.Nombre = @NombreCompa�ia
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT MEDICAMENTO.Nombre,MEDICAMENTO.Prescripcion,MEDICAMENTO.CasaFarmaceutica,SUCURSAL.Nombre as Sucursal,SUC_MEDICAMENTO.Cantidad

	FROM (MEDICAMENTO INNER JOIN SUC_MEDICAMENTO ON SUC_MEDICAMENTO.NombreMedicamento = MEDICAMENTO.Nombre) INNER JOIN SUCURSAL ON SUC_MEDICAMENTO.IDSucursal = SUCURSAL.ID

	WHERE SUCURSAL.IDCompa�ia = @IDCompa�ia AND SUCURSAL.Activo = 1 AND MEDICAMENTO.Activo = 1 
	FOR JSON PATH; 

END
GO

-- =============================================
-- Author:		<Diego Sol�s Jim�nez>
-- Create date: <9/10/2017>
-- Description:	<Agrega un medicamento, actualizando la tabla de SUC_MEDICAMENTO, y calculando la cantidad total entre las compa��as>
-- =============================================
CREATE PROCEDURE Insert_Medicamento
	-- Add the parameters for the stored procedure here
	@NombreMedicamento varchar(30),
	@CasaFarmaceutica varchar(30),
	@Prescripcion bit
	
AS
BEGIN

	INSERT INTO MEDICAMENTO VALUES (@NombreMedicamento,@CasaFarmaceutica,@Prescripcion, 0, 1);

END
GO

-- =============================================
-- Author:		<Diego Sol�s Jim�nez>
-- Create date: <9/10/2017>
-- Description:	<Asigna un medicamento a una sucursal, actualizando la tabla de SUC_MEDICAMENTO, y calculando la cantidad total entre las compa��as>
-- =============================================
CREATE PROCEDURE Insert_MedicamentoxSucursal
	@NombreMedicamento varchar(30),
	@IDSucursal int,
	@Cantidad int

AS
BEGIN

	INSERT INTO SUC_MEDICAMENTO(NombreMedicamento,IDSucursal,Cantidad,Activo) VALUES (@NombreMedicamento,@IDSucursal,@Cantidad,1);
	UPDATE MEDICAMENTO SET MEDICAMENTO.CantidadTotal = (SELECT SUM(SUC_MEDICAMENTO.Cantidad) FROM SUC_MEDICAMENTO WHERE SUC_MEDICAMENTO.IDSucursal = @IDSucursal AND SUC_MEDICAMENTO.NombreMedicamento = @NombreMedicamento) WHERE MEDICAMENTO.Nombre = @NombreMedicamento;

END
GO
-- =============================================
-- Author:		<Diego Sol�s Jim�nez>
-- Create date: <10/10/2017>
-- Description:	<Elimina un medicamento, actualizando la tabla de SUC_MEDICAMENTO poniendo Activo en cero (Borrado L�gico), Para la sucursal indicada>
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
-- Description:	<Elimina un medicamento, actualizando la tabla de SUC_MEDICAMENTO poniendo Activo en cero (Borrado L�gico) Para todas las sucursales de una compa�ia>
-- =============================================

CREATE PROCEDURE Delete_MedicamentoxCompa�ia
  -- Add the parameters for the stored procedure here
  @NombreMedicamento varchar(30),
  @NombreCompa�ia varchar(30)

AS
BEGIN
  
  DECLARE @TempIDCompa�ia int
  DECLARE @NumeroSucursales int
  DECLARE @i int = 1
  DECLARE @Cantidad int
  SELECT @NumeroSucursales = COUNT(*) FROM SUCURSAL
  SELECT @TempIDCompa�ia = COMPA�IA.ID FROM COMPA�IA WHERE COMPA�IA.Nombre = @NombreCompa�ia
  
  While(@i <= @NumeroSucursales)
  BEGIN

    if( (SELECT IDCompa�ia FROM SUCURSAL WHERE SUCURSAL.ID = @i) = @TempIDCompa�ia)
    BEGIN
      SELECT @Cantidad = SUC_MEDICAMENTO.Cantidad FROM SUC_MEDICAMENTO WHERE SUC_MEDICAMENTO.NombreMedicamento = @NombreMedicamento and SUC_MEDICAMENTO.IDSucursal = @i
      UPDATE SUC_MEDICAMENTO SET SUC_MEDICAMENTO.Activo = 0 WHERE SUC_MEDICAMENTO.IDSucursal = @i AND SUC_MEDICAMENTO.NombreMedicamento = @NombreMedicamento
      IF (@@ROWCOUNT > 0)
      BEGIN
        UPDATE MEDICAMENTO SET MEDICAMENTO.CantidadTotal -= @Cantidad  WHERE MEDICAMENTO.Nombre = @NombreMedicamento
      END
    END
    SET @i = @i + 1
  END
  
END
GO