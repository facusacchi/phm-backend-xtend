package appPregunta3.controller

import org.springframework.web.bind.annotation.RestController	
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.http.ResponseEntity
import dao.RepoPregunta
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.SerializationFeature
import dominio.Pregunta
import org.springframework.web.bind.annotation.PostMapping
import dao.RepoUsuario
import com.fasterxml.jackson.annotation.JsonView
import serializer.View
import dominio.Solidaria
import org.springframework.beans.factory.annotation.Autowired
import exceptions.NotFoundException

@RestController
@CrossOrigin(origins = "http://localhost:3000")
class PreguntaController {
	
	@Autowired
	RepoPregunta repoPregunta
	
	@Autowired
	RepoUsuario repoUsuario
	
	// VALIDAR PARAMETROS EN EL PATH NULOS
	@GetMapping(value="/preguntas/{valorBusqueda}/{activas}/{idUser}")
	@JsonView(value=View.Pregunta.Busqueda)
	def getPreguntasPorString(@PathVariable String valorBusqueda, @PathVariable String activas, @PathVariable Long idUser) {
		
		val user = this.repoUsuario.findById(idUser)
		//val user = RepoUsuario.instance.getById(idUser)
		if(user === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body('''No se encontro usuario con ese id''')
		}
		var activa = false
		if (activas=='true') {
			activa = true
		}
		val preguntas = this.repoPregunta.findByDescripcionAndActivaAndAutor(valorBusqueda, activa, user).toList
		//val preguntas = RepoPregunta.instance.search(valorBusqueda, activas, user) 
		if(preguntas === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body('''No se encontraron preguntas que coincidan con los valores de busqueda''')
		}
		ResponseEntity.ok(preguntas)
	}
	
	// VALIDAR PARAMETROS EN EL PATH NULOS
	@GetMapping("/pregunta/{id}")
	@JsonView(value=View.Pregunta.Table)
	def preguntaPorId(@PathVariable Long id) {
		
		val pregunta = repoPregunta.findById(id).orElseThrow([
		throw new NotFoundException("Pregunta con id: " + id + " no encontrada")
		])
		pregunta.activa = pregunta.estaActiva
		ResponseEntity.ok(pregunta)
	}
	
	// REVISAR ESTE ENDPOINT, NO TRAE LO QUE SE ESTA PIDIENDO, Y VALIDAR PARAMETROS EN EL PATH NULOS
	@GetMapping("/preguntasAll/{activas}/{idUser}")
	@JsonView(value=View.Pregunta.Busqueda)
	def todasLasPreguntas(@PathVariable Boolean activas, @PathVariable Long idUser) {
		
		val user = repoUsuario.findById(idUser).orElseThrow([
		throw new NotFoundException("Usuario con id: " + idUser + " no encontrado")
		])
		
		val preguntas = repoPregunta.findByActivas(activas)
		if (preguntas === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body('''No se encontraron preguntas''')
		}
		ResponseEntity.ok(preguntas)
	}
	
	// VALIDAR PARAMETROS EN EL PATH NULOS
	@PutMapping(value="/pregunta/{id}")
	def actualizar(@RequestBody Pregunta preguntaModificada, @PathVariable Long id) {
		
		val pregunta = repoPregunta.findById(id).orElseThrow([
		throw new NotFoundException("Pregunta con id: " + id + " no encontrada")
		])
		
		preguntaModificada.validar
		pregunta => [
			descripcion = preguntaModificada.descripcion
			opciones = preguntaModificada.opciones
			respuestaCorrecta = preguntaModificada.respuestaCorrecta
			puntos = preguntaModificada.puntos
		]
		repoPregunta.save(pregunta)
		ResponseEntity.ok(pregunta)
	}
	
	// VALIDAR PARAMETROS EN EL PATH NULOS
	@PostMapping(value="/{idAutor}/pregunta")
	def crearPregunta(@RequestBody Pregunta bodyPregunta, @PathVariable Long idAutor) {
		
		if(bodyPregunta === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body('''Error en el body''')
		}
		val usuario = repoUsuario.findById(idAutor).orElseThrow([
		throw new NotFoundException("Usuario con id: " + idAutor + " no encontrado")
		])
		
		bodyPregunta.validar
		if(bodyPregunta instanceof Solidaria) {
			bodyPregunta.validar(usuario)
		}
		bodyPregunta.autor = usuario
		repoPregunta.save(bodyPregunta)
		ResponseEntity.ok(bodyPregunta)
	}
	
	// ESTO YA NO SE USA MAS
	static def mapper() {
		new ObjectMapper => [
			configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
			configure(SerializationFeature.INDENT_OUTPUT, true)
		]
	}
}
