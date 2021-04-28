package appPregunta3.controller

import appPregunta3.facade.service.UsuarioService	
import com.fasterxml.jackson.annotation.JsonView
import appPregunta3.dominio.Respuesta
import appPregunta3.dominio.Usuario
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
@CrossOrigin(origins="http://localhost:3000")
class UsuarioController {

	@Autowired
	UsuarioService usuarioService

	@JsonView(View.Usuario.Login)
	@PostMapping("/login")
	def loguearUsuario(@RequestBody Usuario usuarioBody) {
		val usuario = usuarioService.loguearUsuario(usuarioBody)		
		ResponseEntity.ok(usuario)
	}
	
	@JsonView(View.Usuario.Perfil)
	@PutMapping("/perfilDeUsuario/{idUser}/pregunta/{idPregunta}")
	def responder(@PathVariable Long idUser, @PathVariable Long idPregunta, @RequestBody Respuesta respuesta) {
		val esCorrecta = usuarioService.responder(idUser, idPregunta, respuesta)
		ResponseEntity.ok(esCorrecta)
	}

	@JsonView(View.Usuario.Perfil)
	@GetMapping("/perfilDeUsuario/{idUser}")
	def buscarUsuarioPorId(@PathVariable Long idUser) {
		val usuario = usuarioService.buscarUsuarioPorId(idUser)
		ResponseEntity.ok(usuario)
	}

	@JsonView(View.Usuario.Perfil)
	@PutMapping("/perfilDeUsuario/{idUsuario}")
	def actualizarUsuario(@RequestBody Usuario usuarioBody, @PathVariable Long idUsuario) {
		val usuario = usuarioService.actualizarUsuario(idUsuario, usuarioBody)
		ResponseEntity.ok.body(usuario)
	}

	@JsonView(View.Usuario.TablaNoAmigos)
	@GetMapping("/usuarios/noAmigos/{idUsuario}")
	def buscarUsuariosNoAmigos(@PathVariable Long idUsuario) {
		val usuariosNoAmigos = usuarioService.buscarUsuariosNoAmigos(idUsuario)
		ResponseEntity.ok(usuariosNoAmigos)
	}

	@JsonView(View.Usuario.Perfil)
	@PutMapping("/usuarios/{idUsuario}/agregarAmigo/{nuevoAmigoId}")
	def agregarAmigo(@PathVariable Long idUsuario, @PathVariable Long nuevoAmigoId) {
		val usuario = usuarioService.agregarAmigo(idUsuario, nuevoAmigoId)
		ResponseEntity.ok.body(usuario)
	}
}
