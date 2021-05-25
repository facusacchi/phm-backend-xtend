package appPregunta3.dominio

import java.util.HashSet
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors
import org.springframework.data.mongodb.core.mapping.Document
import org.springframework.data.annotation.Id
import java.time.LocalDateTime
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.format.DateTimeFormatter
import com.fasterxml.jackson.annotation.JsonIgnore

@Document(collection="modificaciones")
@Accessors(PUBLIC_GETTER)
class Modificacion {

	@Id
	String id
	Long idUsuario
	@JsonIgnore
	LocalDateTime fecha
	String preguntaId
	String preguntaOld
	String preguntaNew
	String respuestaCorrectaOld
	String respuestaCorrectaNew
	Set<String> opcionesOld = new HashSet<String>
	Set<String> opcionesNew = new HashSet<String>
	static String DATE_PATTERN = "yyyy-MM-dd"
	
	new (){}
	
	new(Long _idUsuario, LocalDateTime _fecha, String preguntaId, String _preguntaOld, String _preguntaNew, String _respuestaCorrectaOld, String _respuestaCorrectaNew, Set<String> _opcionesOld, Set<String> _opcionesNew) {
		idUsuario = _idUsuario
		fecha = _fecha
		this.preguntaId = preguntaId
		preguntaOld = _preguntaOld
		preguntaNew = _preguntaNew
		respuestaCorrectaOld = _respuestaCorrectaOld
		respuestaCorrectaNew = _respuestaCorrectaNew
		opcionesOld = _opcionesOld
		opcionesNew = _opcionesNew
	}
	
	@JsonProperty("fecha")
	def getFechaAsString() {
		formatter.format(this.fecha)
	}
	
	def formatter() {
		DateTimeFormatter.ofPattern(DATE_PATTERN)
	}
}
