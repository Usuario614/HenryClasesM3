use henry_m3;

-- #1
SELECT DISTINCT c.IdCliente, c.Nombre_y_Apellido, v.IdProducto, v.Precio
from venta v
JOIN cliente c ON(v.IdCliente = c.IdCliente);

-- #2
SELECT c.IdCliente, c.Nombre_y_Apellido,
		SUM(v.Cantidad) as cantidad_productos_null,
        SUM(ifnull(v.Cantidad, 0)) as cantidad_productos
from cliente c
LEFT JOIN venta v ON (v.IdCliente = c.IdCliente)
GROUP BY c.IdCliente, c.Nombre_y_Apellido;

-- #3
SELECT c.IdCliente, c.Nombre_y_Apellido, YEAR(v.Fecha), count(v.IdVenta) as total_compras
from venta v
JOIN cliente c ON (v.IdCliente = c.IdCliente)
GROUP BY c.IdCliente, c.Nombre_y_Apellido, YEAR(v.Fecha)
ORDER BY YEAR(v.Fecha) DESC;

-- #4
SELECT c.IdCliente, c.Nombre_y_Apellido, p.Producto, p.IdProducto,
		SUM(v.Cantidad) as cantidad_productos,
        round(avg(v.Precio),2) as precio_promedio
from venta v
JOIN producto p ON(v.IdProducto = p.IdProducto)
JOIN cliente c ON (v.IdCliente = c.IdCliente)
GROUP BY c.IdCliente, c.Nombre_y_Apellido, p.Producto, p.IdProducto
ORDER BY c.IdCliente;

-- #5
-- SELECT Localidad from localidad
-- GROUP BY Localidad
-- HAVING count(*) > 1;

SELECT p.Provincia, l.Localidad, 
		SUM(v.Cantidad) as cantidad_productos,
        SUM(v.Precio*v.Cantidad) as total_ventas,
        count(v.IdVenta) as volumen_venta
from venta v
LEFT JOIN sucursal s ON(v.IdSucursal = s.IdSucursal)
-- LEFT JOIN cliente c ON (v.IdCliente = c.IdCliente)
-- LEFT JOIN localidad l ON (l.IdLocalidad = c.IdLocalidad)
LEFT JOIN localidad l ON (l.IdLocalidad = s.IdLocalidad)
LEFT JOIN provincia p ON (l.IdProvincia = p.IdProvincia)
WHERE v.Outlier = 1
GROUP BY  p.Provincia, l.Localidad
ORDER BY  p.Provincia, l.Localidad;

-- #6
SELECT p.Provincia,
		SUM(v.Cantidad) as cantidad_productos,
        SUM(v.Precio*v.Cantidad) as total_ventas,
        count(v.IdVenta) as volumen_venta
from venta v
-- LEFT JOIN sucursal s ON(v.IdSucursal = s.IdSucursal)
LEFT JOIN cliente c ON (v.IdCliente = c.IdCliente)
LEFT JOIN localidad l ON (l.IdLocalidad = c.IdLocalidad)
-- LEFT JOIN localidad l ON (l.IdLocalidad = s.IdLocalidad)
LEFT JOIN provincia p ON (l.IdProvincia = p.IdProvincia)
WHERE v.Outlier = 1
GROUP BY  p.Provincia
HAVING total_ventas > 100000
ORDER BY  p.Provincia;

-- #7
SELECT c.Rango_Etario, SUM(v.Cantidad) as cantidad_productos, SUM(v.Precio*v.Cantidad) as total_ventas
from venta v
JOIN cliente c ON(v.IdCliente = c.IdCliente) 
WHERE v.Outlier = 1
GROUP BY c.Rango_Etario
ORDER BY c.Rango_Etario;

-- #8
SELECT p.IdProvincia, p.Provincia,
		count(c.IdCliente) as cantidad_clientes
from provincia p
LEFT JOIN localidad l ON(p.IdProvincia = l.IdProvincia)
LEFT JOIN cliente c ON(l.IdLocalidad = c.IdLocalidad)
GROUP BY p.IdProvincia, p.Provincia
ORDER BY p.Provincia;
