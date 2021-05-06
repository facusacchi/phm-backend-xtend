package appPregunta3.dominio

import org.eclipse.xtend.lib.annotations.Accessors		
import com.fasterxml.jackson.annotation.JsonIgnore
import java.time.LocalDate
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.format.DateTimeFormatter
import com.fasterxml.jackson.annotation.JsonView
import appPregunta3.serializer.View
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.GenerationType
import javax.persistence.TableGenerator

@Entity
@Accessors
class Respuesta {
	
	@Id @GeneratedValue(strategy = GenerationType.TABLE, generator = "respuesta-generator")
	@TableGenerator(name = "respuesta-generator",
      table = "dep_ids",
      pkColumnName = "seq_id",
      valueColumnName = "seq_value")
	Long id
	
	@JsonIgnore
	LocalDate fechaRespuesta
	
	@JsonView(View.Usuario.Perfil)
	Integer puntos
	
	@JsonView(View.Usuario.Perfil)
	String pregunta 
	
	String opcionElegida
	
	static String DATE_PATTERN = "yyyy-MM-dd"
	
	@JsonView(View.Usuario.Perfil)
	@JsonProperty("fechaRespuesta")
	def getFechaAsString() {
		formatter.format(this.fechaRespuesta)
	}

	def formatter() {
		DateTimeFormatter.ofPattern(DATE_PATTERN)
	}
	
	def esCorrecta(String respuestaCorrecta) {
		respuestaCorrecta.toLowerCase == opcionElegida.toLowerCase 
	}
}