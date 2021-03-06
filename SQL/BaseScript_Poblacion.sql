INSERT INTO CLIENTE VALUES (604310114,'07-07-1996','HYRULE','DIEGO','ALONSO','SOLIS','JIMENEZ','PUNTARENAS','CORREDORES','CORREDOR','1Km CAMINO A RIO BONITO EN BARRIO LA UNION',86442282,1);
INSERT INTO CLIENTE VALUES (704410874,'28-05-1995','AYOMACHI','JOSE','ANDREA','VARGAZ','OZ','CARTAGO','PASILLOS','PASILLO','1Km CAMINO AL CASTILLO DEL MAGO',87565622,1);
INSERT INTO CLIENTE VALUES (604550117,'08-05-1960','NOHEART','HOJA','LATA','HOMBRE','DE','OZZ','OZZY','ORDE','500m SURESTE DEL CAMPO DE MAIZ',30425688,1);
INSERT INTO CLIENTE VALUES (309810454,'15-02-1965','NOBRAIN','ESPANTA','PAJAROS','PAJA','TRAPO','OZZ','OZZY','ORDE','LADO ESTE DEL CAMPO DE MAIZ',56448713,1);

INSERT INTO COMPA�IA VALUES (1,'Phischel',1);
INSERT INTO COMPA�IA VALUES (2,'BombaTica',1);

INSERT INTO ROL VALUES (1,'Administrador',1);
INSERT INTO ROL VALUES (2,'Doctor',1);
INSERT INTO ROL VALUES (3,'Dependiente',1);

INSERT INTO MEDICAMENTO VALUES ('Acetaminofen','Bayer',0, 300, 1);
INSERT INTO MEDICAMENTO VALUES ('Panadol','Bayer',0, 1000, 1);
INSERT INTO MEDICAMENTO VALUES ('Dorival','Bayer',0, 500, 1);
INSERT INTO MEDICAMENTO VALUES ('Anti-Fludes','Bayer',0, 100, 1);
INSERT INTO MEDICAMENTO VALUES ('Gavirol','Bayer',1, 300, 1);

INSERT INTO EMPLEADO VALUES (604310114,'07-07-1996','HYRULE','DIEGO','ALONSO','SOLIS','JIMENEZ','PUNTARENAS','CORREDORES','CORREDOR','1Km CAMINO A RIO BONITO EN BARRIO LA UNION',86442282,1,1,NULL,1);
INSERT INTO EMPLEADO VALUES (704410874,'28-05-1995','AYOMACHI','JOSE','ANDREA','VARGAZ','OZ','CARTAGO','PASILLOS','PASILLO','1Km CAMINO AL CASTILLO DEL MAGO',87565622,2,1,NULL,1);
INSERT INTO EMPLEADO VALUES (604550117,'08-05-1960','NOHEART','HOJA','LATA','HOMBRE','DE','OZZ','OZZY','ORDE','500m SURESTE DEL CAMPO DE MAIZ',30425688,1,2,NULL,1);
INSERT INTO EMPLEADO VALUES (309810454,'15-02-1965','NOBRAIN','ESPANTA','PAJAROS','PAJA','TRAPO','OZZ','OZZY','ORDE','LADO ESTE DEL CAMPO DE MAIZ',56448713,3,2,NULL,1);

INSERT INTO SUCURSAL(CedAdmin,IDCompa�ia,Nombre,Descripcion,Provincia,Canton,Distrito,Indicaciones,Activo) VALUES (604310114,1,'San Pedro','Sucursal para distribuci�n','San Jos�','San Pedro','Misterio','300m sur del palo de mango',1);
INSERT INTO SUCURSAL(CedAdmin,IDCompa�ia,Nombre,Descripcion,Provincia,Canton,Distrito,Indicaciones,Activo) VALUES (704410874,1,'Pavas','Sucursal de proximidad','San Jos�','San Pedro','Otro','Del abastecedor el Rey 200 m oeste',1);
INSERT INTO SUCURSAL(CedAdmin,IDCompa�ia,Nombre,Descripcion,Provincia,Canton,Distrito,Indicaciones,Activo) VALUES (604550117,2,'Neilly','Sucursal para distribuci�n','Puntarenas','Corredores','Corredor','Del Banco Nacional 100 m sur',1);
INSERT INTO SUCURSAL(CedAdmin,IDCompa�ia,Nombre,Descripcion,Provincia,Canton,Distrito,Indicaciones,Activo) VALUES (309810454,2,'Canoas','Sucursal de proximidad','Puntarenas','Paso Canoas','La Cuesta','Del Deposito BHX 150 m suroeste',1);


UPDATE EMPLEADO SET IDSucursal = 1 WHERE EMPLEADO.Cedula = 604310114;
UPDATE EMPLEADO SET IDSucursal = 2 WHERE EMPLEADO.Cedula = 704410874;
UPDATE EMPLEADO SET IDSucursal = 3 WHERE EMPLEADO.Cedula = 604550117;
UPDATE EMPLEADO SET IDSucursal = 4 WHERE EMPLEADO.Cedula = 309810454;

INSERT INTO RECETA(CedDoctor,Foto,Activo) VALUES (704410874,'NO PICTURE',1);


INSERT INTO DESC_PEDIDO(CedCliente,IDSucursal,Telefono,HoraRecojo,FechaRecojo,Estado,Activo) VALUES (604310114,1,86442282,'15:00','07-07-2017','Facturado',1);
INSERT INTO DESC_PEDIDO(CedCliente,IDSucursal,Telefono,HoraRecojo,FechaRecojo,Estado,Activo) VALUES (604310114,2,86442282,'15:00','08-07-2017','Nuevo',1);
INSERT INTO DESC_PEDIDO(CedCliente,IDSucursal,Telefono,HoraRecojo,FechaRecojo,Estado,Activo) VALUES (309810454,3,56448713,'15:00','09-07-2017','Retirado',1);

INSERT INTO CONT_PEDIDO(IDPedido,NombreMedicamento,Cantidad,IDReceta,Activo) VALUES (1,'Gavirol',1,1,1);
INSERT INTO CONT_PEDIDO(IDPedido,NombreMedicamento,Cantidad,IDReceta,Activo) VALUES (1,'Anti-Fludes',8,NULL,1);
INSERT INTO CONT_PEDIDO(IDPedido,NombreMedicamento,Cantidad,IDReceta,Activo) VALUES (2,'Dorival',4,NULL,1);
INSERT INTO CONT_PEDIDO(IDPedido,NombreMedicamento,Cantidad,IDReceta,Activo) VALUES (3,'Panadol',4,NULL,1);


INSERT INTO PADECIMIENTOS(CedulaCliente,Descripcion,FechaPadecimiento,Activo) VALUES (604310114,'Dolor de cabeza','28-12-2017', 1);
INSERT INTO PADECIMIENTOS(CedulaCliente,Descripcion,FechaPadecimiento,Activo) VALUES (604310114,'Mareos','04-01-2017', 1);
INSERT INTO PADECIMIENTOS(CedulaCliente,Descripcion,FechaPadecimiento,Activo) VALUES (309810454,'Vomito','09-11-2017', 1);
INSERT INTO PADECIMIENTOS(CedulaCliente,Descripcion,FechaPadecimiento,Activo) VALUES (604310114,'Fatiga Muscular','05-05-2017', 1);
INSERT INTO PADECIMIENTOS(CedulaCliente,Descripcion,FechaPadecimiento,Activo) VALUES (604310114,'Migra�as','12-03-2017', 1);
INSERT INTO PADECIMIENTOS(CedulaCliente,Descripcion,FechaPadecimiento,Activo) VALUES (704410874,'Migra�as','7-06-2017', 1);
INSERT INTO PADECIMIENTOS(CedulaCliente,Descripcion,FechaPadecimiento,Activo) VALUES (704410874,'Sangrado Nasal','7-06-2017', 1);
INSERT INTO PADECIMIENTOS(CedulaCliente,Descripcion,FechaPadecimiento,Activo) VALUES (704410874,'Irritaci�n Ocular','7-06-2017', 1);

INSERT INTO SUC_MEDICAMENTO(NombreMedicamento,IDSucursal,Cantidad,Activo) VALUES ('Gavirol',1,300,1);
INSERT INTO SUC_MEDICAMENTO(NombreMedicamento,IDSucursal,Cantidad,Activo) VALUES ('Anti-Fludes',2,100,1);
INSERT INTO SUC_MEDICAMENTO(NombreMedicamento,IDSucursal,Cantidad,Activo) VALUES ('Dorival',3,500,1);
INSERT INTO SUC_MEDICAMENTO(NombreMedicamento,IDSucursal,Cantidad,Activo) VALUES ('Panadol',4,1000,1);
INSERT INTO SUC_MEDICAMENTO(NombreMedicamento,IDSucursal,Cantidad,Activo) VALUES ('Acetaminofen',1,300,1);