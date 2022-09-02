use henry;

CREATE TABLE auditoria_alumno (
IdAuditoria INT NOT NULL AUTO_INCREMENT,
Descripcion VARCHAR(50) NOT NULL,
Fecha_y_hora DATETIME NOT NULL,
Usuario VARCHAR (50) NOT NULL,
PRIMARY KEY (IdAuditoria));

DROP TRIGGER audit_alumno;
CREATE TRIGGER audit_alumno AFTER INSERT ON alumno
FOR EACH ROW
INSERT INTO auditoria_alumno (Descripcion, Fecha_y_hora, Usuario)
VALUES (concat('Nueva inserción: ', NEW.idAlumno, NEW.nombre, NEW.apellido), now(), current_user());
