use henry_m3;

-- #1
DROP PROCEDURE listarProductos;
DELIMITER $$
CREATE PROCEDURE listarProductos(fechaVenta DATE)
BEGIN
	SELECT DISTINCT p.Producto
	from venta v
	join producto p ON(v.IdProducto = p.IdProducto AND v.Fecha = fechaVenta);
END $$
DELIMITER ;

CALL listarProductos('2018-09-10');

-- #2
DROP FUNCTION margenBruto;
DELIMITER $$
CREATE FUNCTION margenBruto(precio DECIMAL(15,2), margen DECIMAL (8,2)) RETURNS DECIMAL (15,2)
BEGIN
	DECLARE margenBruto DECIMAL (15,2);
    SET margenBruto = precio * margen;
    RETURN margenBruto;
END $$
DELIMITER ;

SELECT margenBruto(100, 1.3);

SELECT c.Fecha, pr.Nombre AS Proveedor, p.Producto, c.Precio, margenBruto(c.Precio, 1.2) as PrecioConMargen
from compra c
JOIN producto p ON(c.IdProducto = p.IdProducto)
JOIN proveedor pr ON(c.IdProveedor = pr.IdProveedor);

-- #3
SELECT p.IdProducto, p.Producto, p.Precio, margenBruto(p.Precio, 1.2) as PrecioConMargen
from producto p
JOIN tipo_producto tp ON(p.IdTipoProducto = tp.IdTipoProducto AND tp.TipoProducto = 'Impresión');

-- #4
DROP PROCEDURE listarCategoria;
DELIMITER $$
CREATE PROCEDURE listarCategoria(categoria VARCHAR(25))
BEGIN
	SELECT v.*, p.Producto
    from venta v
    JOIN producto p ON(v.IdProducto = p.IdProducto)--  AND v.Outlier = 1)
    JOIN tipo_producto tp ON(p.IdTipoProducto = tp.IdTipoProducto)
    WHERE v.Outlier = 1
    AND tp.TipoProducto collate utf8mb4_spanish_ci  = categoria;
END $$
DELIMITER ;
CALL listarCategoria('Limpieza');

-- #5 Se cuelga 
INSERT INTO fact_venta
SELECT idVenta, Fecha, Fecha_Entrega, IdCanal, IdCliente, IdEmpleado, IdProducto, Precio, Cantidad
FROM venta
WHERE Outlier = 1;

-- #6
DROP PROCEDURE ventasGrupoEtario;
DELIMITER $$
CREATE PROCEDURE ventasGrupoEtario(grupo VARCHAR(25))
BEGIN
	SELECT c.Rango_Etario, sum(v.Precio * v.Cantidad) AS Total_Ventas
    from venta v
    JOIN cliente c ON(v.IdCliente = c.IdCliente
					AND c.Rango_Etario collate utf8mb4_spanish_ci LIKE concat('%', grupo, '%'))
	GROUP BY c.Rango_Etario;
END $$
DELIMITER ;

SELECT DISTINCT Rango_Etario FROM cliente;
CALL ventasGrupoEtario('51%60');

-- #7
SELECT DISTINCT Rango_Etario FROM dim_cliente;
SET @grupo_etario = '1_Hasta 30 años';
SELECT *
FROM dim_cliente
WHERE Rango_Etario collate utf8mb4_spanish_ci = @grupo_etario;







