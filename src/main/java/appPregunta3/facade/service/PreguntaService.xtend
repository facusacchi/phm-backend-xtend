package appPregunta3.facade.service

import appPregunta3.dao.RepoPregunta	
import appPregunta3.dominio.Pregunta
import appPregunta3.dominio.Solidaria
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import static extension appPregunta3.validaciones.ValidacionPregunta.*
import java.util.Set
import appPregunta3.dominio.Modificacion
import appPregunta3.dao.RepoModificacion
import java.time.LocalDateTime

@Service
class PreguntaService extends TemplateService {
	@Autowired
	RepoPregunta repoPregunta
	
	@Autowired
	RepoModificacion repoModificacion
	
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
		val preguntas = preguntasActivas(todasLasPreguntas(idUser)).toSet
		preguntas
	}
	
	def todasLasPreguntas(Long idUser) {
		val preguntasRespondidas = serviceUsuario.findAllPreguntasRespondidasPor(idUser).toSet
		val preguntas = repoPregunta.findAllNoRespondidasPor(preguntasRespondidas)
		preguntas
	}
	
	def actualizarPregunta(Pregunta preguntaModificada, String id) {
		preguntaModificada.validarCamposVacios
		val pregunta = buscarPregunta(id)
		val autor = buscarUsuario(pregunta.autorId)
		if(preguntaModificada instanceof Solidaria) {
			validarPuntajeAsignado(preguntaModificada, autor)
		}
		val modificacion = new Modificacion(
									LocalDateTime.now,
									pregunta.descripcion,
									preguntaModificada.descripcion,
									pregunta.respuestaCorrecta,
									preguntaModificada.respuestaCorrecta,
									pregunta.opciones,
									preguntaModificada.opciones
								)
		
		pregunta => [
			descripcion = preguntaModificada.descripcion
			opciones = preguntaModificada.opciones
			respuestaCorrecta = preguntaModificada.respuestaCorrecta
			puntos = preguntaModificada.puntos
		]
		
		repoPregunta.save(pregunta)
		repoModificacion.save(modificacion)
	}
	
	def crearPregunta(Pregunta bodyPregunta, Long idAutor) {
		val autor = buscarUsuario(idAutor)
		bodyPregunta.validarCamposVacios
		if(bodyPregunta instanceof Solidaria) {
			validarPuntajeAsignado(bodyPregunta, autor)
		}
		bodyPregunta.nombreAutor = autor.nombre
		bodyPregunta.apellidoAutor = autor.apellido
		bodyPregunta.userNameAutor = autor.userName
		bodyPregunta.autorId = autor.id
		repoPregunta.save(bodyPregunta)
	}
	
	def preguntasActivas(Set<Pregunta> preguntas) {
		return preguntas.filter[pregunta | pregunta.estaActiva].toList
	}
	
}
