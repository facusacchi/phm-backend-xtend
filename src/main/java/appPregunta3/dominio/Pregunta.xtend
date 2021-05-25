package appPregunta3.dominio

import com.fasterxml.jackson.annotation.JsonIgnore	
import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonProperty
import com.fasterxml.jackson.annotation.JsonSubTypes
import com.fasterxml.jackson.annotation.JsonTypeInfo
import com.fasterxml.jackson.annotation.JsonView
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.util.HashSet
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors
import appPregunta3.serializer.View
import appPregunta3.dominio.Respuesta
import org.springframework.data.mongodb.core.mapping.Document
import org.springframework.data.annotation.Id
import org.springframework.data.annotation.Transient

@JsonIgnoreProperties(ignoreUnknown = true)
@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY, property = "type")
@JsonSubTypes(#[
    @JsonSubTypes.Type(value = Simple, name = "simple"),
    @JsonSubTypes.Type(value = DeRiesgo, name = "deRiesgo"),
    @JsonSubTypes.Type(value = Solidaria, name = "solidaria")
])

@Accessors
@Document(collection = "preguntas")
abstract class Pregunta {
	
	@Id
	@JsonView(#[View.Pregunta.Busqueda, View.Pregunta.Table, View.Pregunta.Edicion])
	String id
	
	String tipo
	
	@JsonView(View.Pregunta.Table, View.Pregunta.Edicion)
	Integer puntos
	
	@JsonView(#[View.Pregunta.Busqueda, View.Pregunta.Table, View.Pregunta.Edicion])
	String descripcion
	
	@JsonView(#[View.Pregunta.Table, View.Pregunta.Edicion])
	String nombreApellidoAutor
	
	@JsonView(#[View.Pregunta.Table, View.Pregunta.Busqueda, View.Pregunta.Edicion])
	Long autorId
	
	@JsonView(View.Pregunta.Edicion)
	String respuestaCorrecta
	
	@JsonIgnore
	LocalDateTime fechaHoraCreacion
	
	@JsonView(View.Pregunta.Table, View.Pregunta.Edicion)
	Set<String> opciones = new HashSet<String>
	
	static String DATE_PATTERN = "yyyy-MM-dd HH:mm:ss"

	@JsonProperty("fechaHoraCreacion")
	def setFecha(String fecha) {
		this.fechaHoraCreacion = LocalDateTime.parse(fecha, formatter)
	}

	@JsonProperty("fechaHoraCreacion")
	def getFechaAsString() {
		formatter.format(this.fechaHoraCreacion)
	}

	def formatter() {
		DateTimeFormatter.ofPattern(DATE_PATTERN)
	}
	
	@JsonView(View.Pregunta.Table)
	def estaActiva() {
		fechaHoraCreacion.plusMinutes(5).isAfter(LocalDateTime.now())
	}
	
	def cumpleCondicionDeBusqueda(String valorBusqueda) {
		descripcion.toLowerCase.contains(valorBusqueda.toLowerCase)
	}	
	
	def agregarOpcion(String opcion) {
		opciones.add(opcion)
	}
	
	def void gestionarRespuestaDe(Usuario user, Respuesta respuesta) {
		user.sumarPuntaje(puntos)
		respuesta.puntos = puntos
	}
	
	def void setAutor(Usuario autor)
}

class Simple extends Pregunta {
	
	new() {
		this.puntos = 10
		this.tipo = "simple"
	}
	
	override setAutor(Usuario autor) {}
	
}

class DeRiesgo extends Pregunta {
	
	@Transient
	Integer puntosRestados
	
	@JsonIgnore
	@Transient
	Usuario autor
	
	new() {
		this.puntos = 100
		this.puntosRestados = 50
		this.tipo = "deRiesgo"
	}
	
	override gestionarRespuestaDe(Usuario user, Respuesta respuesta) {
		super.gestionarRespuestaDe(user, respuesta)
		if(user.respondioAntesDeUnMinuto(this)) {
			this.autor.restarPuntaje(puntosRestados)
		}
	}
	
	override setAutor(Usuario autor) {
		this.autor = autor
	}
}

class Solidaria extends Pregunta {
	
	@JsonIgnore
	@Transient
	Usuario autor
	
	new() {
		this.puntos = puntos
		this.tipo = "solidaria"
	}
	
	override gestionarRespuestaDe(Usuario user, Respuesta respuesta) {
		super.gestionarRespuestaDe(user, respuesta)
		this.autor.restarPuntaje(puntos)
	}
	
	override setAutor(Usuario autor) {
		this.autor = autor
	}
	
}

