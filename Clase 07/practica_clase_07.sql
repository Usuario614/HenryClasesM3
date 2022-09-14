use henry_m3;

SELECT v.Fecha, c.Nombre_y_Apellido, (v.Precio*v.Cantidad) AS Venta
FROM venta v
-- INNER JOIN cliente c ON(v.IdCliente = c.IdCliente);
LEFT JOIN cliente c ON(v.IdCliente = c.IdCliente);
-- RIGHT JOIN cliente c ON(v.IdCliente = c.IdCliente);
-- CROSS JOIN cliente c ON(v.IdCliente = c.IdCliente);

SELECT v.Fecha, c.Nombre_y_Apellido, (v.Precio*v.Cantidad) AS Venta
FROM cliente c
-- INNER JOIN venta v ON(v.IdCliente = c.IdCliente);
LEFT JOIN venta v ON(v.IdCliente = c.IdCliente)
UNION
SELECT v.Fecha, c.Nombre_y_Apellido, (v.Precio*v.Cantidad) AS Venta
FROM cliente c
-- INNER JOIN venta v ON(v.IdCliente = c.IdCliente);
RIGHT JOIN venta v ON(v.IdCliente = c.IdCliente);

SELECT v.Fecha, c.Nombre_y_Apellido, (v.Precio*v.Cantidad) AS Venta
FROM cliente c
LEFT JOIN venta v ON(v.IdCliente = c.IdCliente)
WHERE v.IdVenta IS NULL;


