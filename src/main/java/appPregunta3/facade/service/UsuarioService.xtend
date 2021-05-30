package appPregunta3.facade.service

import appPregunta3.dao.RepoUsuario
import appPregunta3.dominio.Respuesta
import appPregunta3.dominio.Usuario
import appPregunta3.facade.service.TemplateService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import static extension appPregunta3.validaciones.ValidacionUsuario.*
import static extension appPregunta3.validaciones.ValidacionRespuesta.*
import appPregunta3.exceptions.NotFoundException
import com.fasterxml.jackson.databind.ObjectMapper
import appPregunta3.dto.UsuarioDTO

@Service
class UsuarioService extends TemplateService {
	
	@Autowired
	RepoUsuario repoUsuario
	
	@Autowired
	ListaDeRespuestasService listaDeRespuestasService
	
//##########  METHODS OF ENDPOINTS ###############################################################

	def loguearUsuario(Usuario user) {
		user.validarLogin
		val usuario = repoUsuario.findByUserNameAndPassword(user.userName, user.password).orElseThrow([
			throw new NotFoundException("Usuario o contraseña incorrectos")
		])
		usuario
	}
	
	def responder(Long idUser, String idPregunta, Respuesta respuesta) {
		validarAntesDeResponder(respuesta)
		val pregunta = buscarPregunta(idPregunta)
		val usuario = buscarUsuario(idUser)
		val respuestaConFecha = usuario.responder(pregunta, respuesta)
		val esCorrecta = respuesta.esCorrecta(pregunta.respuestaCorrecta)
		repoUsuario.save(usuario)
		listaDeRespuestasService.agregarRespuestaAlUsuario(respuestaConFecha, idUser)
		esCorrecta
	}
	
	def buscarUsuarioPorId(Long idUser) {
		val usuario = buscarUsuario(idUser)
		val listaDeRespuestas = listaDeRespuestasService.getRespuestasPorUsuario(idUser)
		val objectMapper = new ObjectMapper();
		val respuestas = listaDeRespuestas.respuestas.map(respuesta|objectMapper.readValue(respuesta, Respuesta)).toList
		val usuarioDTO = new UsuarioDTO(usuario, respuestas)
		usuarioDTO
	}	
	
	def actualizarUsuario(Long idUser, Usuario user) {
		validarAntesDeActualizar(idUser,user)
		val usuario = buscarUsuario(idUser) 
		actualizarCampos(usuario, user) 
		repoUsuario.save(usuario)
		usuario
	}
	
	def buscarUsuariosNoAmigos(Long idUsuarioLogueado) {
		val usuariosNoAmigos = repoUsuario.findNoAmigosDe(idUsuarioLogueado)
		usuariosNoAmigos
	}
	
	def agregarAmigo(Long idUser, Long nuevoAmigoId) {
		val nuevoAmigo = buscarUsuario(nuevoAmigoId)
		val usuarioLogueado = buscarUsuario(idUser)
		validarCamposDeUsuarios(nuevoAmigo, usuarioLogueado)
		usuarioLogueado.agregarAmigo(nuevoAmigo)
		repoUsuario.save(usuarioLogueado)
		usuarioLogueado
	}

//################################################################################################
	
	def validarAntesDeResponder(Respuesta respuesta) {
		respuesta.validarRecursoNulo
		respuesta.validarCamposVacios
	}
	
	def actualizarCampos(Usuario userOld, Usuario userNew) {
		userOld.nombre = userNew.nombre
		userOld.apellido = userNew.apellido
		userOld.fechaDeNacimiento = userNew.fechaDeNacimiento
	}
	
	def validarAntesDeActualizar(Long idUser, Usuario user) {
		user.validarCamposVacios		
	}
	
	
	def validarCamposDeUsuarios(Usuario nuevoAmigo, Usuario usuarioLogueado) {
		nuevoAmigo.validarCamposVacios
		usuarioLogueado.validarCamposVacios
	}
	
	def findAllPreguntasRespondidasPor(Long idUser) {
		val listaDeRespuestas = listaDeRespuestasService.getRespuestasPorUsuario(idUser)
		val objectMapper = new ObjectMapper();
		val respuestas = listaDeRespuestas.respuestas.map(respuesta|objectMapper.readValue(respuesta, Respuesta)).toList
		respuestas.map[respuesta | respuesta.pregunta].toSet
	}
	
}
