USE [L3MSuper]
GO
/****** Object:  StoredProcedure [dbo].[Update_Pedido]    Script Date: 17/10/2017 13:11:47 ******/
DROP PROCEDURE [dbo].[Update_Pedido]
GO
/****** Object:  StoredProcedure [dbo].[Select_TodoSucursales]    Script Date: 17/10/2017 13:11:47 ******/
DROP PROCEDURE [dbo].[Select_TodoSucursales]
GO
/****** Object:  StoredProcedure [dbo].[Select_TodoPedidos]    Script Date: 17/10/2017 13:11:47 ******/
DROP PROCEDURE [dbo].[Select_TodoPedidos]
GO
/****** Object:  StoredProcedure [dbo].[Select_TodoMedicamentos]    Script Date: 17/10/2017 13:11:47 ******/
DROP PROCEDURE [dbo].[Select_TodoMedicamentos]
GO
/****** Object:  StoredProcedure [dbo].[Select_TodoClientes]    Script Date: 17/10/2017 13:11:47 ******/
DROP PROCEDURE [dbo].[Select_TodoClientes]
GO
/****** Object:  StoredProcedure [dbo].[Select_PedidosxCliente]    Script Date: 17/10/2017 13:11:47 ******/
DROP PROCEDURE [dbo].[Select_PedidosxCliente]
GO
/****** Object:  StoredProcedure [dbo].[Insert_Medicamento]    Script Date: 17/10/2017 13:11:47 ******/
DROP PROCEDURE [dbo].[Insert_Medicamento]
GO
/****** Object:  StoredProcedure [dbo].[Estadistica_VentasxCompañia]    Script Date: 17/10/2017 13:11:47 ******/
DROP PROCEDURE [dbo].[Estadistica_VentasxCompañia]
GO
/****** Object:  StoredProcedure [dbo].[Estadistica_MasVendidosxCompañia]    Script Date: 17/10/2017 13:11:47 ******/
DROP PROCEDURE [dbo].[Estadistica_MasVendidosxCompañia]
GO
/****** Object:  StoredProcedure [dbo].[Estadistica_MasVendidostotal]    Script Date: 17/10/2017 13:11:47 ******/
DROP PROCEDURE [dbo].[Estadistica_MasVendidostotal]
GO
/****** Object:  StoredProcedure [dbo].[Delete_MedicamentoxSucursal]    Script Date: 17/10/2017 13:11:47 ******/
DROP PROCEDURE [dbo].[Delete_MedicamentoxSucursal]
GO
/****** Object:  StoredProcedure [dbo].[Delete_MedicamentoxCompañia]    Script Date: 17/10/2017 13:11:47 ******/
DROP PROCEDURE [dbo].[Delete_MedicamentoxCompañia]
GO
/****** Object:  StoredProcedure [dbo].[Create_Pedido]    Script Date: 17/10/2017 13:11:47 ******/
DROP PROCEDURE [dbo].[Create_Pedido]
GO
ALTER TABLE [dbo].[SUCURSAL] DROP CONSTRAINT [EMPLEADOxSUCURSAL]
GO
ALTER TABLE [dbo].[SUCURSAL] DROP CONSTRAINT [COMPAÑIAxSUCURSAL]
GO
ALTER TABLE [dbo].[SUC_MEDICAMENTO] DROP CONSTRAINT [SUCURSALxSUC_MEDICAMENTO]
GO
ALTER TABLE [dbo].[SUC_MEDICAMENTO] DROP CONSTRAINT [MEDICAMENTOxSUC_MEDICAMENTO]
GO
ALTER TABLE [dbo].[RECETA] DROP CONSTRAINT [EMPLEADOxRECETA]
GO
ALTER TABLE [dbo].[PADECIMIENTOS] DROP CONSTRAINT [CLIENTExPADECIMIENTOS]
GO
ALTER TABLE [dbo].[EMPLEADO] DROP CONSTRAINT [SUCURSALxEMPLEADO]
GO
ALTER TABLE [dbo].[EMPLEADO] DROP CONSTRAINT [ROLxEMPLEADO]
GO
ALTER TABLE [dbo].[EMPLEADO] DROP CONSTRAINT [COMPAÑIAxEMPLEADO]
GO
ALTER TABLE [dbo].[DESC_PEDIDO] DROP CONSTRAINT [SUCURSALxDESC_PEDIDO]
GO
ALTER TABLE [dbo].[DESC_PEDIDO] DROP CONSTRAINT [CLIENTExDESC_PEDIDO]
GO
ALTER TABLE [dbo].[CONT_PEDIDO] DROP CONSTRAINT [RECETAxCONT_PEDIDO]
GO
ALTER TABLE [dbo].[CONT_PEDIDO] DROP CONSTRAINT [MEDICAMENTOxCONT_PEDIDO]
GO
ALTER TABLE [dbo].[CONT_PEDIDO] DROP CONSTRAINT [DESC_PEDIDOxCONT_PEDIDO]
GO
/****** Object:  Table [dbo].[SUCURSAL]    Script Date: 17/10/2017 13:11:48 ******/
DROP TABLE [dbo].[SUCURSAL]
GO
/****** Object:  Table [dbo].[SUC_MEDICAMENTO]    Script Date: 17/10/2017 13:11:48 ******/
DROP TABLE [dbo].[SUC_MEDICAMENTO]
GO
/****** Object:  Table [dbo].[ROL]    Script Date: 17/10/2017 13:11:48 ******/
DROP TABLE [dbo].[ROL]
GO
/****** Object:  Table [dbo].[RECETA]    Script Date: 17/10/2017 13:11:48 ******/
DROP TABLE [dbo].[RECETA]
GO
/****** Object:  Table [dbo].[PADECIMIENTOS]    Script Date: 17/10/2017 13:11:48 ******/
DROP TABLE [dbo].[PADECIMIENTOS]
GO
/****** Object:  Table [dbo].[MEDICAMENTO]    Script Date: 17/10/2017 13:11:48 ******/
DROP TABLE [dbo].[MEDICAMENTO]
GO
/****** Object:  Table [dbo].[EMPLEADO]    Script Date: 17/10/2017 13:11:48 ******/
DROP TABLE [dbo].[EMPLEADO]
GO
/****** Object:  Table [dbo].[DESC_PEDIDO]    Script Date: 17/10/2017 13:11:48 ******/
DROP TABLE [dbo].[DESC_PEDIDO]
GO
/****** Object:  Table [dbo].[CONT_PEDIDO]    Script Date: 17/10/2017 13:11:48 ******/
DROP TABLE [dbo].[CONT_PEDIDO]
GO
/****** Object:  Table [dbo].[COMPAÑIA]    Script Date: 17/10/2017 13:11:48 ******/
DROP TABLE [dbo].[COMPAÑIA]
GO
/****** Object:  Table [dbo].[CLIENTE]    Script Date: 17/10/2017 13:11:48 ******/
DROP TABLE [dbo].[CLIENTE]
GO
USE [master]
GO

