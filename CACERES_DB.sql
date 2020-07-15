use master

Create database CACERES_DB

go

use CACERES_DB

go

Create table Categoria(
Id bigint not null primary key identity (1,1),
Nombre varchar(100) not null,
Eliminado bit not null,
)

go


Create Table Producto( 
Id int not null primary key identity (1,1),      
Nombre varchar(100) not null, 
Descripcion varchar(100) not null, 
IdCategoria bigint not null foreign key references Categoria(Id), 
--IdSubCategoria int null foreign key references SubCategoria(Id), 
Precio money not null,    
ImagenUrl varchar (600) not null,
--Cantidad int null,
Stock int not null,
Eliminado bit not null,
)

go

create table Direccion(
Id int not null primary key identity (1,1),
Calle varchar(100) not null,
Altura int not null,
CodigoPostal varchar(50) null,
Provincia varchar(100) not null,
Localidad varchar (100) not null,
)

go

Create table Contacto(
Id int not null primary key identity (1,1),
Email varchar(100) not null,
Telefono varchar(100) not null,
)

go

Create table  TipoUsuario(
Id int not null primary key identity (1,1),
Nombre varchar(50)
)

go

Create table Usuario(
Id int not null primary key identity (1,1),
IngresoSesion varchar(100) not null ,
Nombre varchar(100) null,
Apellido varchar(100) null,
Dni varchar (50) null,
Contraseña varchar(100) not null,
IdTipoUsuario int not null foreign key references TipoUsuario(Id),
Eliminado bit not null,
)

go

Create table Datos_Por_Usuario(
IdUsuario int not null foreign key references Usuario(Id), 
IdContacto int null foreign key references Contacto(Id),
IdDireccion int null foreign key references Direccion(Id),
primary key (IdUsuario)

)


--Create table Cliente(
--Id int not null primary key identity (1,1),
--Dni bigint null,
--Nombre varchar(100) not null,
--Apellido varchar(100) not null,
--IngresoSesion varchar(100) not null ,
--Contraseña varchar(100) not null,
--IdTipoUsuario int not null foreign key references TipoUsuario(Id),
--IdDireccion int null foreign key references Direccion(Id),
--IdContacto int null foreign key references Contacto(Id),
--Eliminado bit not null,
--)

--go

--Create table Administrador(
--Id int not null primary key identity (1,1),
--Nombre varchar(100) not null,
--Apellido varchar(100) not null,
--IngresoSesion varchar(100) not null ,
--Contraseña varchar(100) not null,
--IdTipoUsuario int not null foreign key references TipoUsuario(Id),
--Eliminado bit not null,
--)


go
create table Proveedor(
Id int not null primary key identity (1,1),
Nombre varchar(100) not null,
IdDireccion int not null foreign key references Direccion(Id),
IdContacto int not null foreign key references Contacto(Id),
Eliminado bit not null
)

go

--create table Materiales(
--Id int not null primary key identity (1,1),
--Nombre varchar(100) not null,
--Descripcion varchar(100) null,
--IdProveedor int not null foreign key references Proveedor(Id),
--Stock float not null,
--Eliminado bit not null,
--)


Create table Ventas(

Id int not null primary key identity (1,1),
IdCliente int not null foreign key references Usuario(Id),
--IdProducto int not null foreign key references Producto(Id),
Cantidad int not null,
Total money not null,
Fecha date not null
)

go

Create table Productos_Por_Ventas(
IdVenta int not null foreign key references Ventas(Id),
IdProducto int not null foreign key references Producto(Id),
CantidadUnidades int not null,
Precio money not null


primary key (IdVenta,IdProducto)
)

go

--Create table Ventas_x_Usuario(
--IdVenta int not null foreign key references Ventas(Id),
--IdCliente int not null foreign key references Usuario(Id)

--primary key (IdVenta,IdCliente)
--)
--go

go
------------------------------------------STORE---PROCEDURE-----------------------------------------------------------------

create procedure spListarProductos --PRODUCTO-LISTAR
as

select a.id, a.Nombre, a.Descripcion, C.Nombre as DescCat, C.Id as IdCat,  a.ImagenUrl, a.Precio, a.Eliminado, a.Stock from Producto as A 
inner join Categoria as C on C.Id = a.IdCategoria
where a.Eliminado != 1

go

create procedure spListarCategoria --CATEGORIA-LISTAR
as

select c.id, c.nombre,c.eliminado from Categoria as c where c.Eliminado != 1

go

create procedure spListarSubCategoria --SUBCATEGORIA-LISTAR
as

select s.id, s.nombre,s.eliminado from SubCategoria as s where s.Eliminado != 1

go

--create drop procedure spListarCliente -- CLIENTE
--as
--Select c.Id, C.Dni, C.Nombre, C.Apellido, C.IngresoSesion, C.Contraseña,
--	   t.Id as TipoClienteId, t.Nombre as TipoClienteNombre, D.Id as DireccionID, D.Calle, D.Altura, D.CodigoPostal, D.Provincia, D.Localidad,con.Id as ContactoID,con.Email, con.Telefono,Eliminado
--from Cliente as C
--inner join TipoUsuario as t on t.Id = C.IdTipoUsuario
--left join Direccion as d on d.Id = C.IdDireccion
--left join Contacto as con on con.Id = C.IdContacto
--where C.eliminado not like 1
--select * from Cliente

----go

Create procedure spListarCliente -- CLIENTE-LISTAR
as

Select u.Id, u.Dni, u.Nombre, u.apellido, t.Id as IdTipoUsuario , t.Nombre, u.IngresoSesion, U.Contraseña,
D.Id as DireccionID, D.Calle, D.Altura, D.CodigoPostal, D.Provincia, D.Localidad, c.Id as ContactoID,c.Email, c.Telefono,
u.Eliminado

from Usuario as u
inner join TipoUsuario as t on t.Id = U.IdTipoUsuario
left join Datos_Por_Usuario as Datos on Datos.IdUsuario = u.Id
left join Direccion as D on D.Id = Datos.IdDireccion
left join Contacto as C on C.Id = Datos.IdContacto
where u.eliminado like 0 and t.id = 2



go



Create procedure spListarUsuario -- USUARIO-LISTAR
as

Select u.Id,  u.Nombre, u.apellido, t.Id as IdTipoUsuario , t.Nombre, u.IngresoSesion, U.Contraseña,
u.Eliminado

from Usuario as u
inner join TipoUsuario as t on t.Id = U.IdTipoUsuario
left join Datos_Por_Usuario as Datos on Datos.IdUsuario = u.Id
where u.Eliminado != 1


go


--Create procedure spListarAdministrador --ADMINISTRADOR
--as
--Select A.Id, A.Nombre, A.Apellido, A.IngresoSesion, a.Contraseña, T.Id

--from Administrador as A
--inner join TipoUsuario as T on t.Id = a.IdTipoUsuario
--where A.Eliminado not like 1


--go


create procedure  spListarDireccion -- DIRECCION-LISTAR
as
select D.Id,D.Calle, D.Altura, D.CodigoPostal, D.Provincia,D.Localidad
from Direccion as d

go
create procedure spListarVentas
as
Select * from Ventas

go
create procedure spListarContacto -- CONTACTO-LISTAR
as
select c.Id, c.Email, c.Telefono
from contacto as c

go
--create procedure spListarProveedor -- PROVEEDOR
--as
--select p.Id, p.Nombre, d.Id as IdDireccion, d.Calle, d.Altura, d.CodigoPostal, d.Localidad, d.Provincia, Cont.Id as IdContacto, Cont.Email, Cont.Telefono, P.Eliminado
--from Proveedor as p
--inner join Direccion as D on p.IdDireccion = D.Id
--inner join Contacto as Cont on p.IdContacto = Cont.Id
--Where p.Eliminado !=1

--go


--Create procedure spListarMaterial -- MATERIAL
--as 
--select M.Id, M.Nombre, m.Descripcion, m.Stock, P.Id as IDPROVEEDOR, p.Nombre, m.Eliminado 
--from Materiales as M
--inner join Proveedor as P on p.Id = M.IdProveedor
--where M.eliminado = 0

--go

--SP AGREGAR

create procedure spAgregar --PRODUCTO-AGREGAR

@Nombre varchar(100), 
@Descripcion varchar(100), 
@IdCategoria bigint, 
@Precio money,    
@ImagenUrl varchar (300)
as 
Insert into Producto  (Nombre,Descripcion,IdCategoria,Precio,ImagenUrl,Stock,Eliminado)
		values(@Nombre, @Descripcion, @IdCategoria, @Precio, @ImagenUrl,0,0)
go




create procedure spAgregarCategoria --CATEGORIA-AGREGAR

@Nombre varchar(100)
as 
Insert into Categoria values(@Nombre,0)
go

create procedure spAgregarSubCategoria --SUBCATEGORIA-AGREGAR

@Nombre varchar(100)
as 
Insert into SubCategoria values(@Nombre,0)
go

Create procedure spAgregarDatosCliente --DATOS-CLIENTE--AGREGAR
@IdUsuario int,
@IdContacto int,
@IdDireccion int
as
insert into Datos_Por_Usuario (IdUsuario, IdContacto,IdDireccion)
values (@IdUsuario,@IdContacto,@IdDireccion)

go


Create procedure spAgregarCliente --CLIENTE-AGREGAR

--@Dni bigint,
@Nombre varchar(100),
@Apellido varchar(100),
@IngresoSesion varchar(100),
@Contraseña varchar(100),
@Dni varchar(50),
@IdTipoUsuario int

--@IdDireccion int,
--@IdContacto int
as

insert into Usuario (Nombre,Apellido,Dni,IngresoSesion,Contraseña,IdTipoUsuario,Eliminado)
values (@Nombre, @Apellido,@Dni,@IngresoSesion,@Contraseña,@IdTipoUsuario,0)

go

Create procedure spAgregarAdministrador --ADMINISTRADOR--AGREGAR

@Nombre varchar(100),
@Apellido varchar(100),
@IngresoSesion varchar(100),
@Contraseña varchar(100),

@Eliminado bit
as 
insert into Usuario(Nombre, Apellido,IngresoSesion,Contraseña,IdTipoUsuario,Eliminado)
values (@Nombre,@Apellido,@IngresoSesion,@Contraseña,1,0)

go


insert into TipoUsuario values ('Admin'),('Cliente') 
go

exec spAgregarAdministrador 'Pedro', 'Caceres', 'Cacerespedro@gmail.com','0176',0

go

create procedure spAgregarVenta --VENTA-AGREGAR
@IdCliente int,
@Cantidad int ,
@Total money,
@Fecha date
as

insert into Ventas(IdCliente,Cantidad,Total,Fecha)
values (@IdCliente, @Cantidad,@Total,@Fecha)

go

go
create procedure spAgregarProductos_Por_Ventas --PRODUCTOS-POR-VENTAS--AGREGAR
@IdVenta int,
@IdProducto int,
@CantidadUnidades int,
@Precio money

as
insert into Productos_Por_Ventas(IdVenta,IdProducto,CantidadUnidades,Precio)
values (@IdVenta, @IdProducto,@CantidadUnidades,@Precio)

go



go


--Create procedure spVentas_x_Usuario --
--@IdCliente int,
--@IdVenta int
--as
--insert into Ventas_x_Usuario(IdCliente,IdVenta)
--values (@IdCliente,@IdVenta)

--go


create procedure spAgregarDireccion --DIRECCION---AGREGAR

@Calle varchar(100),
@Altura int,
@CodigoPostal varchar(50),
@Provincia varchar(100),
@Localidad varchar (100)
as
Select * from Productos_Por_Ventas
insert into Direccion values (@Calle, @Altura, @CodigoPostal, @Provincia, @Localidad) 

go



create procedure spAgregarContacto -- CONTACTO--AGREGAR
@Email varchar(100),
@Telefono varchar(100)
as 
insert into contacto values (@Email,@Telefono)

go

--Create Procedure spAgregarProveedor -- PROVEEDOR--AGREGAR

--@Nombre varchar(100),
--@IdDireccion int,
--@IdContacto int

--as

--insert into Proveedor values (@Nombre, @IdDireccion, @IdContacto,0)

--go

Create procedure spAgregarMaterial -- MATERIAL

@Nombre varchar(100),
@Descripcion varchar(100),
@IdProveedor int,
@Stock float
as

insert into Materiales values (@Nombre, @Descripcion, @IdProveedor, @Stock, 0)

go
--SP ELIMINAR 
create procedure spEliminar --PRODUCTO

@ID int
as
Update Producto Set Eliminado = 1 where ID =  @ID
go

create procedure spEliminarCategoria --CATEGORIA

@ID int
as
Update Categoria Set Eliminado = 1 where ID =  @ID
go

create procedure spEliminarSubCategoria --SUBCATEGORIA

@ID int
as
Update Categoria Set Eliminado = 1 where ID =  @ID

go

Create procedure spEliminarCliente --CLIENTE

@ID int

as

Update Usuario Set Eliminado = 1 where ID =  @ID

go

Create procedure spEliminarMaterial -- MATERIAL

@ID int

as

Update Materiales Set Eliminado = 1 where ID =  @ID

go
Create procedure spEliminarProveedor --Proveedor
@ID int

as

Update Proveedor Set Eliminado = 1 where ID =  @ID

go
--SP MODIFICAR
create procedure spModificar --PRODUCTO

@ID int,
@Nombre varchar(100), 
@Descripcion varchar(100), 
@IdCategoria bigint, 
@Stock int, 
@Precio money,    
@ImagenUrl varchar (300)
as

Update Producto  Set Nombre = @Nombre, Descripcion = @Descripcion, IdCategoria = @IdCategoria,
					Stock = @Stock, Precio = @Precio, ImagenUrl = @ImagenUrl where ID =  @ID

go

create procedure spModificarStockProducto ---STOCK MODIFICAR
@Id int,
@Stock int

as
Update Producto Set Stock = @Stock
where Producto.Id = @Id

go

create procedure spModificarCategoria --CATEGORIA

@ID int,
@Nombre varchar(100)
as
Update Categoria Set Nombre = @Nombre where ID = @ID

go
Create procedure spModificarDatosCliente --DATOS CLIENTE
@IdUsuario int,
@IdContacto int,
@IdDireccion int
as
Update Datos_Por_Usuario set IdContacto = @IdContacto, IdDireccion = @IdDireccion where IdUsuario = @IdUsuario
go
go
create procedure spSubCategoria --SUBCATEGORIA

@ID int,
@Nombre varchar(100)
as
Update SubCategoria Set Nombre = @Nombre where ID = @ID

go

Create procedure spModificarCliente --CLIENTE
@ID int,
@Dni bigint,
@Nombre varchar(100),
@Apellido varchar(100),
@IngresoSesion varchar(100),
@Contraseña varchar(100),
@IdTipoUsuario int,
@IdDireccion int,
@IdContacto int
as
update Cliente set Dni = @Dni, Apellido = @Apellido, Nombre =  @Nombre , IngresoSesion =  @IngresoSesion,
Contraseña = @Contraseña, IdDireccion = @IdDireccion
where ID = @ID

go

--Create Procedure spModificarProveedor -- PROVEEDOR
--@ID int,
--@Nombre varchar(100),
--@IdDireccion int,
--@IdContacto int

--as

--update Proveedor set Nombre = @Nombre, IdDireccion = @IdDireccion, IdContacto = @IdContacto where Id= @ID
--go

--Create procedure spModificarMaterial -- MATERIAL
--@ID int,
--@Nombre varchar(100),
--@Descripcion varchar(100),
--@IdProveedor int,
--@Stock float
--as

--Update Materiales set Nombre = @Nombre, Descripcion = @Descripcion, IdProveedor = @IdProveedor, Stock = @Stock where Id = @Id

--go




--create  procedure spListarCompras

--@IdCliente int

--as
--Select v.Id, sum(p.Precio * v.Cantidad) as Subtotal, v.Fecha, sum(v.Cantidad) as Cantidad
--from Cliente as C
--inner join Ventas_x_Usuario as VxU on VxU.IdCliente = c.Id
--inner join Productos_Por_Ventas as PxV on Pxv.IdVenta = VxU.IdVenta
--inner join Producto as P on P.Id = PxV.IdProducto
--inner join Ventas as v on v.IdProducto =P.Id

--where c.Id = @IdCliente
--group by v.Id,v.Fecha

--go


create procedure spListarCompras

@IdCliente int

as
Select distinct v.Id, v.Total, v.Fecha, v.Cantidad
from Ventas as V

inner join Usuario as u on u.Id = v.IdCliente
inner join Productos_Por_Ventas as PxV on PxV.IdVenta = v.Id
inner join Producto as P on P.Id = PxV.IdProducto 

where v.IdCliente = @IdCliente

go

create procedure spListarVentasAdministrador
as
select v.Id, c.Apellido,c.nombre, v.total, v.Cantidad, v.fecha
from Ventas as V

inner join Usuario as c on c.Id = v.IdCliente
inner join Productos_Por_Ventas as PxV on PxV.IdVenta = v.Id
inner join Producto as P on P.Id = PxV.IdProducto 

go

--(cast(datediff(dd,FechaNac,GETDATE()) / 365.25 as int))as 'Edad' 

Create view vwListarRankingProductos

as 

Select top 3 p.Id, p.Nombre, p.Precio, p.Descripcion, Sum(ppv.CantidadUnidades) as CantidadVendidas, v.Fecha
from Producto as p
inner join Productos_Por_Ventas as PpV on PpV.IdProducto = p.Id 
inner join Ventas as v on v.Id = ppv.IdVenta
group by p.id,p.Nombre,p.Precio,p.Descripcion,p.IdCategoria,v.Fecha,v.Id

having 30 > (select (datediff(dd,v.Fecha,GETDATE())) as [Nueva] from ventas as ve 
where ve.Id = v.Id
)
order by CantidadVendidas desc

go

Create view vwListarTotalRecaudadoMes

as

Select sum(PPV.CantidadUnidades * PPV.Precio) as Columna, sum(PPV.CantidadUnidades) as Otra
from Productos_Por_Ventas as PPV
inner join Ventas as v on v.Id = ppv.IdVenta
where 30 > (select (datediff(dd,v.Fecha,GETDATE())) as [Nueva] from ventas as ve 
where ve.Id = v.Id
)
go


Create procedure spListarVentasCliente


@IdVenta int

as

select P.Nombre, p.Precio, v.Fecha, v.Id as Venta, PxV.CantidadUnidades, p.ImagenUrl

from producto as p
inner join  Productos_Por_Ventas as PxV on PxV.IdProducto = p.Id
inner join Ventas as V on v.Id = PxV.IdVenta


Where v.Id = @IdVenta
go

--Create view vwListarRankingMayorRecaudacion

--as

--Select top 5 p.Id, p.Nombre, p.Precio, p.Descripcion, sum(ppv.CantidadUnidades) as CantidadUnidades, Sum(ppv.CantidadUnidades * PpV.Precio) as PrecioRecaudado
--from Producto as p
--inner join Productos_Por_Ventas as PpV on PpV.IdProducto = p.Id
--inner join ventas as v on v.

--group by p.id,p.Nombre,p.Precio,p.Descripcion,ppv.CantidadUnidades
--order by PrecioRecaudado desc
--where v.
--go
go

create trigger tr_DescontarStock
on Productos_Por_Ventas
after insert
as
begin
	declare @Cantidad int
	declare @IdProducto int
	select @Cantidad = CantidadUnidades, @IdProducto = IdProducto from inserted
	update Producto set  Stock -= @Cantidad where Id = @IdProducto


end

go

 insert into Usuario values ('test@cliente.com','Acliente','Testing','231231321','0176',2,0)
 insert into Usuario values ('cliente@test.com','Acliente','Testing','231231321','0176',2,0)
 insert into Usuario values ('cliente4@test.com','Acliente','Testing','2231321','0176',2,0)
 insert into Usuario values ('cliente5@test.com','Bcliente','Testing','28831321','0176',2,0)
 insert into Usuario values ('cliente6@test.com','Ccliente','Testing','299231321','0176',2,0)
 insert into Usuario values ('cliente7@test.com','Dcliente','Testing','210231321','0176',2,0)
 insert into Usuario values ('cliente8@test.com','Ecliente','Testing','211231321','0176',2,0)
 insert into Usuario values ('cliente9@test.com','Fcliente','Testing','238931321','0176',2,0)
 insert into Usuario values ('cliente10@test.com','Gcliente','Testing','2392231321','0176',2,0)
 insert into Usuario values ('cliente11@test.com','Hcliente','Testing','237431321','0176',2,0)

 go
insert into CATEGORIA values ('Topes',0),('Macetas',0), ('Postes',0)

go

insert into Producto values ('Tope de estacionamiento', 'de hormigón', 1, 500, 'https://casadeladocreto.com/fotos/tope2.png',100,0)
insert into Producto values ('Poste olimpico', 'de hormigón', 3, 1100, 'https://tucumanalambres.com.ar/wp-content/uploads/2020/02/poste-de-hormigon-olimpico-alambrado-alambres-tucuman.jpg',100,0)
insert into Producto values ('Poste esquinero', 'de hormigón', 3, 700, 'https://laforestamaderas.com.ar/wp-content/uploads/2019/05/poste-esquinero-olimpico.jpg',100,0)
insert into Producto values ('Maceta Cubo', ' medianas para el Jardin', 2, 300, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRu2Y0Y5J4FCBr3t3ljU9LCGS_SBcj2jKHTaA&usqp=CAU',100,0)
insert into Producto values ('Maceta Souvenir', ' de cemento para Souvenir', 2, 150, 'https://i.ytimg.com/vi/hRWOayivDTk/hqdefault.jpg',100,0)
insert into Producto values ('Maceta de interior', ' de cemento para Souvenir', 2, 150, 'https://i.ytimg.com/vi/hRWOayivDTk/hqdefault.jpg',100,0)

go



insert into Ventas values (2,3,400,'2020-07-03')
insert into Ventas values (3,6,3200,'2020-06-27')
insert into Ventas values (4,8,8500,'2020-07-03')
insert into Ventas values (5,4,6300,'2020-06-28')
insert into Ventas values (6,5,20000,'2020-05-15')
insert into Ventas values (7,2,27850,'2020-05-03')
insert into Ventas values (8,3,3600,'2020-03-03')
insert into Ventas values (9,2,2000,'2020-03-03')
insert into Ventas values (10,1,700,'2020-07-03')
insert into Ventas values (11,10,9000,'2020-05-03')
insert into Ventas values (2,3,3950,'2020-07-14')
insert into Ventas values (3,2,1220,'2020-03-02')
insert into Ventas values (4,8,16800,'2020-04-16')
insert into Ventas values (5,6,13500,'2019-08-19')
insert into Ventas values (6,1,1000,'2020-05-03')
insert into Ventas values (7,1,300,'2020-04-03')
insert into Ventas values (8,3,4000,'2020-01-03')
insert into Ventas values (9,2,5000,'2020-07-03')
insert into Ventas values (10,9,11000,'2020-02-03')
insert into Ventas values (11,12,17330,'2020-06-03')
insert into Ventas values (5,1,790,'2020-07-03')
insert into Ventas values (8,10,16000,'2020-05-03')
insert into Ventas values (6,12,23000,'2020-04-03')
insert into Ventas values (6,4,85000,'2020-07-03')



insert into Productos_Por_Ventas values(1,6,1,1250)
insert into Productos_Por_Ventas values(2,5,5,1200)
insert into Productos_Por_Ventas values(3,4,2,900)
insert into Productos_Por_Ventas values(4,3,4,800)
insert into Productos_Por_Ventas values(5,2,7,1500)
insert into Productos_Por_Ventas values(6,1,2,1750)
insert into Productos_Por_Ventas values(7,6,4,2000)
insert into Productos_Por_Ventas values(8,6,3,2750)
insert into Productos_Por_Ventas values(9,5,6,3150)
insert into Productos_Por_Ventas values(10,4,5,600)
insert into Productos_Por_Ventas values(12,2,4,1500)
insert into Productos_Por_Ventas values(13,1,6,350)
insert into Productos_Por_Ventas values(14,2,8,800)
insert into Productos_Por_Ventas values(15,1,5,2000)
insert into Productos_Por_Ventas values(16,2,2,2500)
insert into Productos_Por_Ventas values(17,5,3,4000)
insert into Productos_Por_Ventas values(18,4,6,500)
insert into Productos_Por_Ventas values(19,3,7,850)
insert into Productos_Por_Ventas values(20,6,4,450)
insert into Productos_Por_Ventas values(21,5,2,600)
insert into Productos_Por_Ventas values(22,4,4,1500)
insert into Productos_Por_Ventas values(23,3,3,1850)
insert into Productos_Por_Ventas values(24,2,2,1100)
insert into Productos_Por_Ventas values(1,5,1,700)
insert into Productos_Por_Ventas values(3,6,3,1250)


insert into Productos_Por_Ventas values(1,3,3,2500)
insert into Productos_Por_Ventas values(2,6,3,1250)
insert into Productos_Por_Ventas values(3,5,3,3000)
insert into Productos_Por_Ventas values(4,2,3,800)

insert into Productos_Por_Ventas values(6,4,3,300)
insert into Productos_Por_Ventas values(9,3,3,400)
insert into Productos_Por_Ventas values(10,1,3,1250)

insert into Direccion values ('Washington',213,1617,'Buenos Aires','Tigre')
insert into Direccion values ('Abreu',988,1617,'Buenos Aires','Pacheco')
insert into Direccion values ('Quiroga',41,1617,'Buenos Aires','Del Viso')
insert into Direccion values ('Santa Rosa',512,1617,'Buenos Aires','Villa Adelina')
insert into Direccion values ('Olmos',516,1560,'Buenos Aires','Boulogne')
insert into Direccion values ('Troman',963,1617,'Buenos Aires','Pacheco')
insert into Direccion values ('Pichincha',132,1617,'Buenos Aires','Rincon de Mielberg')
insert into Direccion values ('Rosale',848,1617,'Buenos Aires','Villa Urquiza')
insert into Direccion values ('Rivadavia',854,1617,'Buenos Aires','Los Troncos')
insert into Direccion values ('Asuncion',485,1617,'Buenos Aires','San Isidro')
insert into Direccion values ('Washington',165,1617,'Buenos Aires','Vicente Lopez')

insert into Contacto values ('cacerespedro@gmail.com','15155615')
insert into Contacto values ('cliente2@gmail.com','155464452')
insert into Contacto values ('cliente3@gmail.com','1556742')
insert into Contacto values ('cliente4@gmail.com','155647552')
insert into Contacto values ('cliente5@gmail.com','141152')
insert into Contacto values ('cliente6@gmail.com','154525452')
insert into Contacto values ('cliente6@gmail.com','15898952')
insert into Contacto values ('cliente7@gmail.com','15252152')
insert into Contacto values ('cliente8@gmail.com','159996652')
insert into Contacto values ('cliente9@gmail.com','1798932')
insert into Contacto values ('cliente10@gmail.com','0118515651')


insert into Datos_Por_Usuario values (1,11,7)
insert into Datos_Por_Usuario values (2,10,8)
insert into Datos_Por_Usuario values (3,9,9)
insert into Datos_Por_Usuario values (4,8,10)
insert into Datos_Por_Usuario values (5,7,11)
insert into Datos_Por_Usuario values (6,6,1)
insert into Datos_Por_Usuario values (7,5,2)
insert into Datos_Por_Usuario values (8,4,3)
insert into Datos_Por_Usuario values (9,3,4)
insert into Datos_Por_Usuario values (10,2,5)
insert into Datos_Por_Usuario values (11,1,6)






