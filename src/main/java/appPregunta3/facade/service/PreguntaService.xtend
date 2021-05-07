package appPregunta3.facade.service

import appPregunta3.dao.RepoPregunta	
import appPregunta3.dominio.Pregunta
import appPregunta3.dominio.Solidaria
import appPregunta3.dominio.Usuario
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import static extension appPregunta3.validaciones.ValidacionPregunta.*
import java.util.Set

@Service
class PreguntaService extends TemplateService {
	@Autowired
	RepoPregunta repoPregunta
	
	@Autowired
	UsuarioService serviceUsuario
	
	def getPreguntasActivasPorString(String valorBusqueda, Long idUser) {
		val user = buscarUsuario(idUser)
		val preguntas = this.repoPregunta.findByDescripcionContainsIgnoreCase(valorBusqueda).toList
		val preguntasNoRespondidas = preguntas.filter[ pregunta | !user.preguntasRespondidas
			.contains(pregunta.descripcion.toLowerCase)
		].toSet
		val preguntasActivasNoRespondidas = preguntasActivas(preguntasNoRespondidas)
		preguntasActivasNoRespondidas
	}
	
	def getPreguntasAllPorString(String valorBusqueda, Long idUser) {
		val user = buscarUsuario(idUser)
		val preguntas = this.repoPregunta.findByDescripcionContainsIgnoreCase(valorBusqueda).toList
		val preguntasNoRespondidas = preguntas.filter[ pregunta | !user.preguntasRespondidas
			.contains(pregunta.descripcion.toLowerCase)
		].toList
		preguntasNoRespondidas
	}
	
	def preguntaPorId(String id) {
		val pregunta = buscarPregunta(id)
		pregunta
	}
	
	def todasLasPreguntasActivas(Long idUser) {
		val user = buscarUsuario(idUser)
		val preguntas = filtrarPorActivasYNoRespondidas(user)
		preguntas
	}
	
	def todasLasPreguntas(Long idUser) {
		val user = buscarUsuario(idUser)
		val preguntasRespondidas = serviceUsuario.findAllPreguntasRespondidasPor(user.id).toSet
		val preguntas = repoPregunta.findAllNoRespondidasPor(preguntasRespondidas).toSet
		preguntas
	}
	
	def actualizarPregunta(Pregunta preguntaModificada, String id) {
		preguntaModificada.validarCamposVacios
		val pregunta = buscarPregunta(id)
		val autor = buscarUsuario(pregunta.autor.id)
		if(preguntaModificada instanceof Solidaria) {
			validarPuntajeAsignado(preguntaModificada, autor)
		}
		pregunta => [
			descripcion = preguntaModificada.descripcion
			opciones = preguntaModificada.opciones
			respuestaCorrecta = preguntaModificada.respuestaCorrecta
			puntos = preguntaModificada.puntos
		]
		repoPregunta.save(pregunta)
	}
	
	def crearPregunta(Pregunta bodyPregunta, Long idAutor) {
		val autor = buscarUsuario(idAutor)
		bodyPregunta.validarCamposVacios
		if(bodyPregunta instanceof Solidaria) {
			validarPuntajeAsignado(bodyPregunta, autor)
		}
		bodyPregunta.autor = autor
		repoPregunta.save(bodyPregunta)
	}
	
	def filtrarPorActivasYNoRespondidas(Usuario user) {
		return preguntasActivas(todasLasPreguntas(user.id)).toSet
	}
	
	def preguntasActivas(Set<Pregunta> preguntas) {
		return preguntas.filter[pregunta | pregunta.estaActiva].toList
	}
	
}
