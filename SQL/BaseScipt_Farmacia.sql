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
-- Author:		<Diego Solís Jiménez>
-- Create date: <9/10/2017>
-- Description:	<Devuelve la información de las sucursales de la compañía especificada, más el nombre y apellido de su administrador>
-- =============================================
CREATE PROCEDURE Select_TodoSucursales
	-- Add the parameters for the stored procedure here
	@NombreCompañia varchar(30)
AS
BEGIN

	DECLARE @IDCompañia int
	SELECT @IDCompañia = COMPAÑIA.ID FROM COMPAÑIA WHERE COMPAÑIA.Nombre = @NombreCompañia
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
	@NombreCompañia varchar(30)
AS
BEGIN
	DECLARE @IDCompañia int
	SELECT @IDCompañia = COMPAÑIA.ID FROM COMPAÑIA WHERE COMPAÑIA.Nombre = @NombreCompañia
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT DISTINCT DESC_PEDIDO.ID,CLIENTE.Cedula AS CedulaCliente,CLIENTE.Nombre1 AS NombreCliente,CLIENTE.Apellido1 AS ApellidoCliente,SUCURSAL.Nombre AS NombreSucursal,
	DESC_PEDIDO.Telefono,DESC_PEDIDO.HoraRecojo,DESC_PEDIDO.FechaRecojo,DESC_PEDIDO.Estado, MEDICAMENTO.Nombre as NombreMedicamento, CONT_PEDIDO.Cantidad, EMPLEADO.Cedula as CedulaDoctor,RECETA.Foto
	
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
-- Author:		<Diego Solís Jiménez>
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
-- Author:		<Diego Solís Jiménez>
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
-- Author:		<Diego Solís Jiménez>
-- Create date: <9/10/2017>
-- Description:	<Devuelve el nombre y la cantidad de todos los productos vendidos por compañía>
-- =============================================

CREATE PROCEDURE Estadistica_MasVendidosxCompañia
	-- Add the parameters for the stored procedure here
	@NombreCompañia varchar(30)
AS
BEGIN
	DECLARE @IDCompañia int
	SELECT @IDCompañia = COMPAÑIA.ID FROM COMPAÑIA WHERE COMPAÑIA.Nombre = @NombreCompañia
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT CONT_PEDIDO.NombreMedicamento,CONT_PEDIDO.Cantidad
	
	FROM (CONT_PEDIDO INNER JOIN DESC_PEDIDO ON CONT_PEDIDO.IDPedido = DESC_PEDIDO.ID) INNER JOIN SUCURSAL ON SUCURSAL.ID = DESC_PEDIDO.IDSucursal
	WHERE SUCURSAL.IDCompañia = @IDCompañia AND (DESC_PEDIDO.Estado = 'Facturado' OR DESC_PEDIDO.ESTADO = 'Retirado')

	ORDER BY CONT_PEDIDO.NombreMedicamento

	FOR JSON PATH; 

END
GO


-- =============================================
-- Author:		<Diego Solís Jiménez>
-- Create date: <9/10/2017>
-- Description:	<Devuelve el nombre y la cantidad de todos los productos vendidos de todas las compañías>
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
-- Author:		<Diego Solís Jiménez>
-- Create date: <9/10/2017>
-- Description:	<Devuelve el nombre y la cantidad de todos los productos vendidos por compañía>
-- =============================================
CREATE PROCEDURE Estadistica_VentasxCompañia
	-- Add the parameters for the stored procedure here
	@NombreCompañia varchar(30)
AS
BEGIN

	DECLARE @IDCompañia int
	SELECT @IDCompañia = COMPAÑIA.ID FROM COMPAÑIA WHERE COMPAÑIA.Nombre = @NombreCompañia
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT DISTINCT COUNT(DESC_PEDIDO.Estado) AS CantidadVentas
	
	FROM DESC_PEDIDO INNER JOIN SUCURSAL ON SUCURSAL.ID = DESC_PEDIDO.IDSucursal

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
-- Author:		<Diego Solís Jiménez>
-- Create date: <9/10/2017>
-- Description:	<Devuelve los datos más importantes de los Clientes por compañía>
-- =============================================
CREATE PROCEDURE Select_TodoClientes
	-- Add the parameters for the stored procedure here
	@NombreCompañia varchar(30)
AS
BEGIN

	DECLARE @IDCompañia int
	SELECT @IDCompañia = COMPAÑIA.ID FROM COMPAÑIA WHERE COMPAÑIA.Nombre = @NombreCompañia
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT DISTINCT CLIENTE.Nombre1,CLIENTE.Nombre2,CLIENTE.Apellido1,CLIENTE.Apellido2,CLIENTE.Cedula,CLIENTE.FNacimiento,CLIENTE.Telefono,CLIENTE.Provincia,
	CLIENTE.Canton,CLIENTE.Distrito,CLIENTE.Indicaciones,PADECIMIENTOS.Descripcion,PADECIMIENTOS.FechaPadecimiento

	FROM (CLIENTE FULL OUTER JOIN PADECIMIENTOS ON CLIENTE.Cedula = PADECIMIENTOS.CedulaCliente) INNER JOIN (DESC_PEDIDO INNER JOIN SUCURSAL ON DESC_PEDIDO.IDSucursal = SUCURSAL.ID) ON DESC_PEDIDO.CedCliente = CLIENTE.Cedula

	WHERE SUCURSAL.IDCompañia = @IDCompañia AND CLIENTE.Activo = 1 

	ORDER BY CLIENTE.Cedula DESC

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
	@NombreCompañia varchar(30)
AS
BEGIN

	DECLARE @IDCompañia int
	SELECT @IDCompañia = COMPAÑIA.ID FROM COMPAÑIA WHERE COMPAÑIA.Nombre = @NombreCompañia
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
	@Prescripcion bit
	
AS
BEGIN

	INSERT INTO MEDICAMENTO VALUES (@NombreMedicamento,@CasaFarmaceutica,@Prescripcion, 0, 1);

END
GO

-- =============================================
-- Author:		<Diego Solís Jiménez>
-- Create date: <9/10/2017>
-- Description:	<Asigna un medicamento a una sucursal, actualizando la tabla de SUC_MEDICAMENTO, y calculando la cantidad total entre las compañías>
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
-- Create date: <9/10/2017>
-- Description:	Retorna todos los empleados de una compañia con toda la informacion completa (joins)>
-- =============================================
CREATE PROCEDURE Select_TodoEmpleados
	-- Add the parameters for the stored procedure here
	@NombreCompañia varchar(30)
AS
BEGIN

	DECLARE @IDCompañia int
	SELECT @IDCompañia = COMPAÑIA.ID FROM COMPAÑIA WHERE COMPAÑIA.Nombre = @NombreCompañia
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
	Where COMPAÑIA.ID = @IDCompañia and EMPLEADO.Activo=1 
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
	@Nombre1 varChar(20), @Nombre2 varChar(20), @Apellido1 varChar(20), @Apellido2 varChar(20), @Contraseña varChar(20), @FNAcimiento date,
	@Provincia varChar(50), @Canton varChar(50), @Distrito varChar(50), @Indicaciones varChar(120), @Telefono int, @Rol varChar(20),
	@Compañia varChar(20), @Sucursal varChar(20), @Cedula int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @TempIDCompañia int;
	DECLARE @TempIDSucursal int;
	DECLARE @TempIDRol int;
    -- Insert statements for procedure here
	SELECT @TempIDCompañia = COMPAÑIA.ID FROM COMPAÑIA WHERE COMPAÑIA.Nombre = @Compañia;
	SELECT @TempIDSucursal = SUCURSAL.ID FROM SUCURSAL WHERE SUCURSAL.Nombre = @Sucursal;
	SELECT @TempIDRol = ROL.ID FROM ROL WHERE ROL.Descripcion = @Rol;
	INSERT INTO EMPLEADO (Cedula, Apellido1, Apellido2, Nombre1, Nombre2, FNacimiento, Contraseña, Provincia, Canton, Distrito, 
		Indicaciones, Telefono, IDRol, IDCompañia, IDSucursal, Activo)
     VALUES(@Cedula, @Apellido1, @Apellido2, @Nombre1, @Nombre2, @FNAcimiento, @Contraseña, @Provincia, @Canton, @Distrito, 
		@Indicaciones,  @Telefono, @TempIDRol, @TempIDCompañia, @TempIDSucursal, 1)
	
END
GO
-- =============================================
-- Author:		<Efren Carvajal Valverde>
-- Create date: <10/10/2017>
-- Description:	<Comprueba en que condicion se encuentra un Empleado y lo modifica, ya sea activar o desactiva (Pseudo eliminación)>
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
	@Nombre1 varChar(20), @Nombre2 varChar(20), @Apellido1 varChar(20), @Apellido2 varChar(20), @Contraseña varChar(20), @FNAcimiento date,
	@Provincia varChar(50), @Canton varChar(50), @Distrito varChar(50), @Indicaciones varChar(120), @Telefono int, @Rol varChar(20),
	@Compañia varChar(20), @Sucursal varChar(20), @Cedula int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET NOCOUNT ON;
	DECLARE @TempIDCompañia int;
	DECLARE @TempIDSucursal int;
	DECLARE @TempIDRol int;
    -- Insert statements for procedure here
	SELECT @TempIDCompañia = COMPAÑIA.ID FROM COMPAÑIA WHERE COMPAÑIA.Nombre = @Compañia;
	SELECT @TempIDSucursal = SUCURSAL.ID FROM SUCURSAL WHERE SUCURSAL.Nombre = @Sucursal;
	SELECT @TempIDRol = ROL.ID FROM ROL WHERE ROL.Descripcion = @Rol;
	UPDATE EMPLEADO SET Cedula=@Cedula, Apellido1=@Apellido1, Apellido2=@Apellido2, Nombre1=@Nombre1, Nombre2=@Nombre1,
		FNacimiento=@FNAcimiento, Contraseña=@Contraseña, Provincia=@Provincia, Canton=@Canton, Distrito=@Distrito, 
		Indicaciones=@Indicaciones, Telefono=@Telefono, IDRol=@TempIDRol, IDCompañia=@TempIDCompañia, 
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
		COMPAÑIA.Nombre as Compañia, ROL.Descripcion as Roll, SUCURSAL.Nombre as Sucursal
	FROM (((EMPLEADO
		INNER JOIN COMPAÑIA ON EMPLEADO.IDCompañia = COMPAÑIA.ID)
		INNER JOIN ROL ON EMPLEADO.IDRol = ROL.ID)
		INNER JOIN SUCURSAL ON EMPLEADO.IDSucursal = SUCURSAL.ID)
	Where EMPLEADO.Cedula = @IDEmpleado and EMPLEADO.Contraseña=@Pass and EMPLEADO.Activo=1 
	FOR JSON PATH , WITHOUT_ARRAY_WRAPPER;;
END
GO
-- =============================================
-- Author:		Efren Carvajal Valverde
-- Create date: 17/10/17
-- Description:	Insertar una compañia 
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
	DECLARE @TempIDCompañia int
    -- Insert statements for procedure here
	SELECT @TempIDCompañia = COMPAÑIA.ID FROM COMPAÑIA WHERE COMPAÑIA.Nombre = @NombreComp;

	INSERT INTO SUCURSAL  (CedAdmin, Nombre, Descripcion, Provincia, Canton, Distrito, 
		Indicaciones, IDCompañia, Activo)
     VALUES(@CedAdmin, @Nombre, @Descripcion, @Provincia, @Canton, @Distrito, 
		@Indicaciones, @TempIDCompañia,  1)
END
GO
-- =============================================
-- Author:		<Efren Carvajal Valverde>
-- Create date: <09/10/2017>
-- Description:	<Comprueba en que condicion se encuentra una Sucursal  y lo modifica, ya sea activar o desactiva (Pseudo eliminación)>
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





CREATE TABLE ROL (
	ID INT NOT NULL,
	Descripcion VARCHAR(30) NOT NULL,
	Activo bit NOT NULL,
	PRIMARY KEY(ID)
	
);

CREATE TABLE EMPLEADO(
	Cedula INT NOT NULL,
	FNacimiento DATE NOT NULL,
	Contraseña VARCHAR(20) NOT NULL,
	Nombre1 VARCHAR(20) NOT NULL,
	Nombre2 VARCHAR(20),
	Apellido1 VARCHAR(20) NOT NULL,
	Apellido2 VARCHAR(20) NOT NULL,
	Provincia VARCHAR(50) NOT NULL,
	Canton VARCHAR(50) NOT NULL,
	Distrito VARCHAR(50) NOT NULL,
	Indicaciones VARCHAR(120) NOT NULL,
	Telefono INT,
	IDRol INT NOT NULL,
	IDCompañia INT NOT NULL,
	IDSucursal INT,
	Activo bit NOT NULL,
	PRIMARY KEY (Cedula)
	
);

CREATE TABLE PADECIMIENTOS (
	ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	CedulaCliente INT NOT NULL,
	Descripcion VARCHAR(80) NOT NULL,
	FechaPadecimiento DATE NOT NULL,
	Activo bit NOT NULL
	
);

CREATE TABLE CLIENTE(
	Cedula INT NOT NULL,
	FNacimiento DATE NOT NULL,
	Contraseña VARCHAR(20) NOT NULL,
	Nombre1 VARCHAR(20) NOT NULL,
	Nombre2 VARCHAR(20),
	Apellido1 VARCHAR(20) NOT NULL,
	Apellido2 VARCHAR(20) NOT NULL,
	Provincia VARCHAR(50) NOT NULL,
	Canton VARCHAR(50) NOT NULL,
	Distrito VARCHAR(50) NOT NULL,
	Indicaciones VARCHAR(120) NOT NULL,
	Telefono INT,
	Activo bit NOT NULL,
	PRIMARY KEY (Cedula)
);

CREATE TABLE COMPAÑIA (
	ID INT NOT NULL,
	Nombre VARCHAR(30) NOT NULL,
	Activo bit NOT NULL,
	PRIMARY KEY(ID)
);

CREATE TABLE SUCURSAL (
	ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	CedAdmin INT NOT NULL,
	IDCompañia INT NOT NULL,
	Nombre VARCHAR(30) NOT NULL,
	Descripcion VARCHAR(30) NOT NULL,
	Provincia VARCHAR(50) NOT NULL,
	Canton VARCHAR(50) NOT NULL,
	Distrito VARCHAR(50) NOT NULL,
	Indicaciones VARCHAR(120) NOT NULL,
	Activo bit NOT NULL,

);


CREATE TABLE DESC_PEDIDO (
	ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	CedCliente INT NOT NULL,
	IDSucursal INT NOT NULL,
	Telefono INT NOT NULL,
	HoraRecojo TIME NOT NULL,
	FechaRecojo Date NOT NULL,
	--Cantidad INT NOT NULL,
	Estado varchar(15) NOT NULL,
	Activo bit NOT NULL

);

CREATE TABLE SUC_MEDICAMENTO (
	ID INT IDENTITY(1,1) PRIMARY KEY,
	NombreMedicamento VARCHAR(30) NOT NULL,
	IDSucursal INT NOT NULL,
	Cantidad INT NOT NULL,
	Activo bit NOT NULL,
);

CREATE TABLE MEDICAMENTO (
	Nombre VARCHAR(30) NOT NULL,
	CasaFarmaceutica VARCHAR(30) NOT NULL,
	Prescripcion bit NOT NULL,
	CantidadTotal VARCHAR(30) NOT NULL,
	Activo bit NOT NULL,
	PRIMARY KEY(Nombre)
);

CREATE TABLE CONT_PEDIDO (
	ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	IDPedido INT NOT NULL,
	NombreMedicamento VARCHAR(30) NOT NULL,
	IDReceta INT,
	Cantidad INT,
	Activo bit NOT NULL

);

CREATE TABLE RECETA (
	ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	/*IDContPedido INT NOT NULL,*/
	CedDoctor INT NOT NULL,
	Foto Varchar(max),
	Activo bit NOT NULL
);


ALTER TABLE EMPLEADO
ADD CONSTRAINT ROLxEMPLEADO FOREIGN KEY (IDRol) REFERENCES ROL(ID);

ALTER TABLE EMPLEADO
ADD CONSTRAINT COMPAÑIAxEMPLEADO FOREIGN KEY (IDCompañia) REFERENCES COMPAÑIA(ID);

ALTER TABLE EMPLEADO
ADD CONSTRAINT SUCURSALxEMPLEADO FOREIGN KEY (IDSucursal) REFERENCES SUCURSAL(ID);

ALTER TABLE SUCURSAL
ADD CONSTRAINT COMPAÑIAxSUCURSAL FOREIGN KEY (IDCompañia) REFERENCES COMPAÑIA(ID);

ALTER TABLE SUCURSAL
ADD CONSTRAINT EMPLEADOxSUCURSAL FOREIGN KEY (CedAdmin) REFERENCES EMPLEADO(Cedula);

ALTER TABLE DESC_PEDIDO
ADD CONSTRAINT CLIENTExDESC_PEDIDO FOREIGN KEY (CedCliente) REFERENCES CLIENTE(Cedula);

ALTER TABLE DESC_PEDIDO
ADD CONSTRAINT SUCURSALxDESC_PEDIDO FOREIGN KEY (IDSucursal) REFERENCES SUCURSAL(ID);

ALTER TABLE SUC_MEDICAMENTO
ADD CONSTRAINT MEDICAMENTOxSUC_MEDICAMENTO FOREIGN KEY (NombreMedicamento) REFERENCES MEDICAMENTO(Nombre);

ALTER TABLE SUC_MEDICAMENTO
ADD CONSTRAINT SUCURSALxSUC_MEDICAMENTO FOREIGN KEY (IDSucursal) REFERENCES SUCURSAL(ID);

ALTER TABLE CONT_PEDIDO
ADD CONSTRAINT DESC_PEDIDOxCONT_PEDIDO FOREIGN KEY (IDPedido) REFERENCES DESC_PEDIDO(ID);

ALTER TABLE CONT_PEDIDO
ADD CONSTRAINT MEDICAMENTOxCONT_PEDIDO FOREIGN KEY (NombreMedicamento) REFERENCES MEDICAMENTO(Nombre);

ALTER TABLE CONT_PEDIDO
ADD CONSTRAINT RECETAxCONT_PEDIDO FOREIGN KEY (IDReceta) REFERENCES RECETA(ID);

ALTER TABLE RECETA
ADD CONSTRAINT EMPLEADOxRECETA FOREIGN KEY (CedDoctor) REFERENCES EMPLEADO(Cedula);

ALTER TABLE PADECIMIENTOS
ADD CONSTRAINT CLIENTExPADECIMIENTOS FOREIGN KEY (CedulaCliente) REFERENCES CLIENTE(Cedula);



