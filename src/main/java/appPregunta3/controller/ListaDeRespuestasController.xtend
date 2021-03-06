package appPregunta3.controller

import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.beans.factory.annotation.Autowired
import appPregunta3.facade.service.ListaDeRespuestasService
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import com.fasterxml.jackson.annotation.JsonView
import appPregunta3.serializer.View
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.http.ResponseEntity
import com.fasterxml.jackson.databind.ObjectMapper
import appPregunta3.dominio.Respuesta

@RestController
@CrossOrigin(origins = "http://localhost:3000")
@RequestMapping("/respuestas")
class ListaDeRespuestasController {
	
	@Autowired
	ListaDeRespuestasService listaDeRespuestasService
	
	@GetMapping(value="/usuario/{idUser}")
	@JsonView(value=View.Usuario.Perfil)
	def getRespuestasPorUsuario(@PathVariable Long idUser) {
		val listaDeRespuestas = listaDeRespuestasService.getRespuestasPorUsuario(idUser)
		val objectMapper = new ObjectMapper();
		val listaToJson = listaDeRespuestas.respuestas.map(respuesta|objectMapper.readValue(respuesta, Respuesta)).toList
		ResponseEntity.ok(listaToJson)
	}
	
}