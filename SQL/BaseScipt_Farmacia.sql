CREATE TABLE ROL (
	ID INT NOT NULL,
	Descripcion VARCHAR(30) NOT NULL,
	Activo bit NOT NULL,
	PRIMARY KEY(ID)
	
);

CREATE TABLE EMPLEADO(
	Cedula INT NOT NULL,
	FNacimiento DATE NOT NULL,
	Contrase�a VARCHAR(20) NOT NULL,
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
	IDCompa�ia INT NOT NULL,
	IDSucursal INT,
	Activo bit NOT NULL,
	PRIMARY KEY (Cedula)
	
);

CREATE TABLE PADECIMIENTOS (
	ID INT IDENTITY(1,1) NOT NULL,
	Descripcion VARCHAR(80) NOT NULL,
	Activo bit NOT NULL,
	CedulaCliente INT NOT NULL,
	PRIMARY KEY(ID)
);

CREATE TABLE CLIENTE(
	Cedula INT NOT NULL,
	FNacimiento DATE NOT NULL,
	Contrase�a VARCHAR(20) NOT NULL,
	Nombre1 VARCHAR(20) NOT NULL,
	Nombre2 VARCHAR(20),
	Apellido1 VARCHAR(20) NOT NULL,
	Apellido2 VARCHAR(20) NOT NULL,
	Provincia VARCHAR(50) NOT NULL,
	Canton VARCHAR(50) NOT NULL,
	Distrito VARCHAR(50) NOT NULL,
	Indicaciones VARCHAR(120) NOT NULL,
	Telefono INT,
	Padecimientos VARCHAR(300) NOT NULL,
	Activo bit NOT NULL,
	PRIMARY KEY (Cedula)
);




CREATE TABLE COMPA�IA (
	ID INT NOT NULL,
	Nombre VARCHAR(30) NOT NULL,
	Activo bit NOT NULL,
	PRIMARY KEY(ID)
);

CREATE TABLE SUCURSAL (
	ID INT NOT NULL,
	CedAdmin INT NOT NULL,
	IDCompa�ia INT NOT NULL,
	Nombre VARCHAR(30) NOT NULL,
	Descripcion VARCHAR(30) NOT NULL,
	Activo bit NOT NULL,
	PRIMARY KEY(ID)
);


CREATE TABLE DESC_PEDIDO (
	ID INT NOT NULL,
	CedCliente INT NOT NULL,
	IDSucursal INT NOT NULL,
	Telefono INT NOT NULL,
	HoraRecojo INT NOT NULL,
	Estado varchar(15) NOT NULL,
	Activo bit NOT NULL,
	PRIMARY KEY(ID)
);

CREATE TABLE SUC_MEDICAMENTO (
	ID INT NOT NULL,
	NombreMedicamento VARCHAR(30) NOT NULL,
	IDSucursal INT NOT NULL,
	Cantidad INT NOT NULL,
	Activo bit NOT NULL,
	PRIMARY KEY(ID)
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
	ID INT NOT NULL,
	IDPedido INT NOT NULL,
	NombreMedicamento VARCHAR(30) NOT NULL,
	IDReceta INT,
	Activo bit NOT NULL,
	PRIMARY KEY(ID)
);

CREATE TABLE RECETA (
	ID INT NOT NULL,
	/*IDContPedido INT NOT NULL,*/
	CedDoctor INT NOT NULL,
	Foto Varchar(max),
	Activo bit NOT NULL,
	PRIMARY KEY(ID)
);


ALTER TABLE EMPLEADO
ADD CONSTRAINT ROLxEMPLEADO FOREIGN KEY (IDRol) REFERENCES ROL(ID);

ALTER TABLE EMPLEADO
ADD CONSTRAINT COMPA�IAxEMPLEADO FOREIGN KEY (IDCompa�ia) REFERENCES COMPA�IA(ID);

ALTER TABLE EMPLEADO
ADD CONSTRAINT SUCURSALxEMPLEADO FOREIGN KEY (IDSucursal) REFERENCES SUCURSAL(ID);

ALTER TABLE SUCURSAL
ADD CONSTRAINT COMPA�IAxSUCURSAL FOREIGN KEY (IDCompa�ia) REFERENCES COMPA�IA(ID);

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