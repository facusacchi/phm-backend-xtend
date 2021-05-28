package appPregunta3.dominio

import org.eclipse.xtend.lib.annotations.Accessors
import com.fasterxml.jackson.annotation.JsonIgnore
import java.time.LocalDate
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.format.DateTimeFormatter
import com.fasterxml.jackson.annotation.JsonView
import appPregunta3.serializer.View
import org.springframework.data.annotation.Id
import org.springframework.data.redis.core.RedisHash

//@RedisHash("Respuesta")
@Accessors
class Respuesta {

//	Long id
	@JsonIgnore
	LocalDate fechaRespuesta

	@JsonView(View.Usuario.Perfil)
	Integer puntos

	@JsonView(View.Usuario.Perfil)
	String pregunta

	String opcionElegida

//	@Id
//	Long idUsuario
	static String DATE_PATTERN = "yyyy-MM-dd"

	@JsonView(View.Usuario.Perfil)
	@JsonProperty("fechaRespuesta")
	def getFechaAsString() {
		formatter.format(this.fechaRespuesta)
	}

	@JsonProperty("fechaRespuesta")
	def setFechaAsDate(String fecha) {
		fechaRespuesta = LocalDate.parse(fecha, formatter)
	}

	def formatter() {
		DateTimeFormatter.ofPattern(DATE_PATTERN)
	}

	def esCorrecta(String respuestaCorrecta) {
		respuestaCorrecta.toLowerCase == opcionElegida.toLowerCase
	}
}
