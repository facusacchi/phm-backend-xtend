package appPregunta3.controller

import appPregunta3.facade.service.PreguntaService	
import com.fasterxml.jackson.annotation.JsonView
import appPregunta3.dominio.Pregunta
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import appPregunta3.serializer.View

@RestController
@CrossOrigin(origins = "http://localhost:3000")
class PreguntaController {
	
	@Autowired
	PreguntaService preguntaService
	
	@GetMapping(value="/preguntas/activas/{valorBusqueda}/noRespondidasPorUsuario/{idUser}")
	@JsonView(value=View.Pregunta.Busqueda)
	def getPreguntasActivasPorString(@PathVariable String valorBusqueda, @PathVariable Long idUser) {
		val preguntas = this.preguntaService.getPreguntasActivasPorString(valorBusqueda, idUser)
		ResponseEntity.ok(preguntas)
	}
	
	@GetMapping(value="/preguntas/all/{valorBusqueda}/noRespondidasPorUsuario/{idUser}")
	@JsonView(value=View.Pregunta.Busqueda)
	def getPreguntasAllPorString(@PathVariable String valorBusqueda, @PathVariable Long idUser) {
		val preguntas = this.preguntaService.getPreguntasAllPorString(valorBusqueda, idUser)
		ResponseEntity.ok(preguntas)
	}
	
	@GetMapping("/pregunta/{id}")
	@JsonView(value=View.Pregunta.Table)
	def preguntaPorId(@PathVariable String id) {
		val pregunta = preguntaService.preguntaPorId(id) 
		ResponseEntity.ok(pregunta)
	}
	
	@GetMapping("/preguntas/edicion/{id}")
	@JsonView(value=View.Pregunta.Edicion)
	def preguntaEdicionPorId(@PathVariable String id) {
		val pregunta = preguntaService.preguntaPorId(id) 
		ResponseEntity.ok(pregunta)
	}
	
	@GetMapping("/preguntas/activas/noRespondidasPorUsuario/{idUser}")
	@JsonView(value=View.Pregunta.Busqueda)
	def todasLasPreguntasActivas(@PathVariable Long idUser) {
		val preguntas = preguntaService.todasLasPreguntasActivas(idUser)
		ResponseEntity.ok(preguntas)
	}
	
	@GetMapping("/preguntas/all/noRespondidasPorUsuario/{idUser}")
	@JsonView(value=View.Pregunta.Busqueda)
	def todasLasPreguntas(@PathVariable Long idUser) {
		val preguntas = preguntaService.todasLasPreguntas(idUser)
		ResponseEntity.ok(preguntas)
	}
	
	@PutMapping(value="/preguntas/{id}")
	def actualizarPregunta(@RequestBody Pregunta preguntaModificada, @PathVariable String id) {
		preguntaService.actualizarPregunta(preguntaModificada, id)
		ResponseEntity.ok("Pregunta actualizada correctamente")
	}
	
	@PostMapping(value="/preguntas/{idAutor}")
	def crearPregunta(@RequestBody Pregunta bodyPregunta, @PathVariable Long idAutor) {
		preguntaService.crearPregunta(bodyPregunta, idAutor)
		ResponseEntity.ok("Pregunta creada correctamente")
	}
	
}
