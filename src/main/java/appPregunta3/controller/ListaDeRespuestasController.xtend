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
import org.springframework.web.bind.annotation.ResponseBody
import org.springframework.http.MediaType

@RestController
@CrossOrigin(origins = "http://localhost:3000")
@RequestMapping("/respuestas")
class ListaDeRespuestasController {
	
	@Autowired
	ListaDeRespuestasService listaDeRespuestasService
	
	@GetMapping(value="/usuario/{idUser}")
//	, produces=MediaType.APPLICATION_JSON_VALUE)
	@JsonView(value=View.Usuario.Perfil)
//	@ResponseBody
	def getRespuestasPorUsuario(@PathVariable Long idUser) {
		val respuestas = listaDeRespuestasService.getRespuestasPorUsuario(idUser)
		ResponseEntity.ok(respuestas)
	}
}