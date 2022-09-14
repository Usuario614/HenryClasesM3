use henry_m3;
-- Subqueries
-- Comparando contra una lista
SELECT *
FROM cliente
WHERE IdCliente NOT IN
	(SELECT DISTINCT idCliente
	from venta);

-- Comparando contra un valor    
SELECT *
from cliente
WHERE edad >=
	(select round(avg(edad)) from cliente);

-- Vistas
ALTER VIEW clientes_alto_gasto AS
select  distinct  c.idcliente , c.nombre_y_apellido, (v.precio*v.cantidad) as venta
from venta v
join cliente c on (c.idcliente = v.idcliente)
where v.precio*v.cantidad > (select avg(v.precio*v.cantidad) from venta v)
AND year(v.Fecha) = 2020;

CREATE VIEW clientes_no_compraron AS
SELECT *
FROM cliente
WHERE IdCliente NOT IN
	(SELECT DISTINCT idCliente
	from venta);

