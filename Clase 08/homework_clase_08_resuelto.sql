use henry;

SELECT MIN(fechaIngreso) AS fecha
FROM alumno;

SELECT idAlumno, fechaIngreso
FROM alumno
WHERE fechaIngreso = MIN(fechaIngreso);

SELECT idAlumno, nombre, apellido,fechaIngreso
FROM alumno
WHERE fechaIngreso = (SELECT MIN(fechaIngreso) AS fecha
                        FROM alumno);
                        
use henry_m3;
-- Instrucción SQL N° 1
-- INSERT INTO fact_venta (IdFecha, Fecha, IdSucursal, IdProducto, IdProductoFecha, IdSucursalFecha, IdProductoSucursalFecha)
SELECT	c.IdFecha, 
		g.Fecha,
		g.IdSucursal, 
        NULL AS IdProducto, 
        NULL AS IdProductoFecha, 
        g.IdSucursal * 100000000 + c.IdFecha IdSucursalFecha,
        NULL AS IdProductoSucursalFecha
FROM 	gasto g JOIN calendario c
	ON (g.Fecha = c.fecha)
WHERE g.IdSucursal * 100000000 + c.IdFecha = (	SELECT	v.IdSucursal * 100000000 + c.IdFecha 
													FROM venta v JOIN calendario c ON (v.Fecha = c.fecha)
													WHERE v.Outlier = 1);

SELECT	v.IdSucursal * 100000000 + c.IdFecha
FROM venta v
JOIN calendario c ON (v.Fecha = c.fecha)
WHERE v.Outlier = 1;

-- Instrucción SQL N° 2
INSERT INTO fact_venta (IdFecha, Fecha, IdSucursal, IdProducto, IdProductoFecha, IdSucursalFecha, IdProductoSucursalFecha)
SELECT	c.IdFecha, 
		co.Fecha,
		NULL AS IdSucursal, 
        co.IdProducto, 
        co.IdProducto * 100000000 + c.IdFecha AS  IdProductoFecha, 
        NULL IdSucursalFecha,
        NULL AS IdProductoSucursalFecha
FROM 	compra co JOIN calendario c
	ON (co.Fecha = c.fecha)
WHERE co.IdProducto * 100000000 + c.IdFecha NOT IN (SELECT	v.IdProducto * 100000000 + c.IdFecha 
													FROM venta v JOIN calendario c ON (v.Fecha = c.fecha)
													WHERE v.Outlier = 1);

-- Instrucción SQL N° 3
SELECT 	co.TipoProducto,
		co.PromedioVentaConOutliers,
        so.PromedioVentaSinOutliers,
        co.PromedioVentaConOutliers / so.PromedioVentaSinOutliers AS diferencia
        
FROM
	(	SELECT 	tp.TipoProducto, AVG(v.Precio * v.Cantidad) as PromedioVentaConOutliers
		FROM 	venta v 
		JOIN producto p
		ON (v.IdProducto = p.IdProducto)
		JOIN tipo_producto tp
		ON (p.IdTipoProducto = tp.IdTipoProducto)
		GROUP BY tp.TipoProducto
	) co
JOIN
	(	SELECT 	tp.TipoProducto, AVG(v.Precio * v.Cantidad) as PromedioVentaSinOutliers
		FROM 	venta v 
		JOIN producto p
		ON (v.IdProducto = p.IdProducto and v.Outlier = 1)
		JOIN tipo_producto tp
		ON (p.IdTipoProducto = tp.IdTipoProducto)
		GROUP BY tp.TipoProducto
	) so
ON co.TipoProducto = so.TipoProducto;

#4
SELECT v.Fecha, SUM(v.Precio*v.Cantidad) AS total_ventas
from venta v
WHERE v.Fecha  = (SELECT MIN(v.Fecha) from venta v)
GROUP BY v.Fecha
UNION
SELECT v.Fecha, SUM(v.Precio*v.Cantidad) AS total_ventas
from venta v
WHERE v.Fecha  = (SELECT MAX(v.Fecha) from venta v)
GROUP BY v.Fecha;

#5
SELECT v.Fecha, p.Producto, SUM(v.Precio * v.Cantidad) AS total_ventas
FROM venta v
LEFT JOIN producto p ON(v.IdProducto = p.IdProducto)
WHERE v.Fecha IN (SELECT MIN(v.Fecha) from venta v
				UNION
                SELECT MAX(v.Fecha) from venta v)
GROUP BY v.Fecha, p.Producto;

#6
SELECT Fecha, SUM(Precio * Cantidad) as total_ventas
from venta
GROUP BY Fecha
ORDER BY total_ventas desc
LIMIT 1;






