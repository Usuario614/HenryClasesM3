use henry_m3;

SET @anio = 2019;
SELECT @anio;

SELECT *
from venta
WHERE year(Fecha) = @anio;

use henry;

DROP PROCEDURE getTotalAlumnos;
DELIMITER $$
CREATE PROCEDURE getTotalAlumnos()
BEGIN
	DECLARE total_alumnos INT DEFAULT 0;
    
    SELECT count(*)
    into total_alumnos
    from alumno;
    
    SELECT total_alumnos;
END$$
DELIMITER ;

CALL getTotalAlumnos();

SHOW databases;
SHOW schemas;
SHOW tables;
SHOW variables;


