package dominio

import java.util.HashSet
import java.util.Set
import java.time.LocalDate
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList
import java.util.List
import com.fasterxml.jackson.annotation.JsonIgnore
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.format.DateTimeFormatter

@Accessors
class Usuario extends Entity {
	
	String nombre
	String apellido
	@JsonIgnore LocalDate fechaDeNacimiento
	String userName
	String password
	Set<Usuario> amigos = new HashSet<Usuario>
	int puntaje
	List<Pregunta> preguntasRespondidas = new ArrayList<Pregunta>
	static String DATE_PATTERN = "yyyy-MM-dd"
	
	@JsonProperty("fechaDeNacimiento")
	def getFechaAsString() {
		formatter.format(this.fechaDeNacimiento)
	}
	
	@JsonProperty("fechaDeNacimiento")
	def setFecha(String fecha) {
		this.fechaDeNacimiento = LocalDate.parse(fecha, formatter)
	}

	def formatter() {
		DateTimeFormatter.ofPattern(DATE_PATTERN)
	}
	
	def sumarPuntaje(int puntos) {
		puntaje += puntos
	}
	
	def restarPuntaje(int puntos) {
		puntaje -= puntos
	}
	
	override cumpleCondicionDeBusqueda(String valorBusqueda) {
		nombre.toLowerCase.contains(valorBusqueda.toLowerCase) || apellido.toLowerCase.equals(valorBusqueda.toLowerCase)
	}
	
	def agregarPreguntaRespondida(Pregunta pregunta) {
		preguntasRespondidas.add(pregunta)
	}
	
	def agregarAmigo(Usuario usuario){
		amigos.add(usuario)
	}
}