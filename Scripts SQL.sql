USE pregunta3;

-- 2. TRIGGER ------

CREATE TABLE modificacion(
id_modificacion INT UNSIGNED AUTO_INCREMENT NOT NULL,
id_pregunta bigint NOT NULL,
fecha DATE NOT NULL,
hora TIME NOT NULL,
texto_anterior varchar(150) NOT NULL,
texto_posterior varchar(150) NOT NULL,
CONSTRAINT pk_modificacion
PRIMARY KEY(id_modificacion)
);

delimiter !
CREATE TRIGGER MODIFICACION_TEXTO_PREGUNTA
AFTER UPDATE ON pregunta
FOR EACH ROW 
BEGIN
INSERT INTO modificacion(id_pregunta, fecha, hora, texto_anterior, texto_posterior)
VALUES(OLD.id, curdate(), curtime(), OLD.descripcion, NEW.descripcion);
END; !
delimiter ;

-- FIN TRIGGER ------

-- Vista

create view usuariosConMasDe3Respuestas as
select usuario.id, usuario.nombre, usuario.apellido, count(usuario.id) as cantidad_de_respuestas
from usuario
join usuario_respuestas
on usuario.id = usuario_respuestas.usuario_id
join respuesta
on usuario_respuestas.respuestas_id = respuesta.id
group by usuario.id
having cantidad_de_respuestas > 3;

-- fin vista

