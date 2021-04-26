package appPregunta3.controller

import appPregunta3.dominio.Respuesta
import appPregunta3.dominio.Usuario
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.test.context.ActiveProfiles
import org.junit.jupiter.api.DisplayName
import org.springframework.test.web.servlet.MockMvc
import org.junit.jupiter.api.Test
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders
import org.springframework.http.MediaType

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@DisplayName("Dado un controller de usuarios")
class UsuarioControllerTest {

	@Autowired
	MockMvc mockMvc

	@Test
	@DisplayName("hacer sign in de un usuario")
	def void loguearUsuario(){
		mockMvc
		.perform(
			MockMvcRequestBuilders.post("/login")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"userName":"pepito","password":"123"}')
		)
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.userName").value('pepito'))	
	}
	
//	@JsonView(View.Usuario.Perfil)
//	@PutMapping(value="/perfilDeUsuario/{idUser}/pregunta/{idPregunta}")
//	def responder(@PathVariable Long idUser, @PathVariable Long idPregunta, @RequestBody Respuesta respuesta) {
//		val esCorrecta = usuarioService.responder(idUser, idPregunta, respuesta)
//		ResponseEntity.ok(esCorrecta)
//	}
//
//	@JsonView(View.Usuario.Perfil)
//	@GetMapping("/perfilDeUsuario/{idUser}")
//	def buscarUsuarioPorId(@PathVariable Long idUser) {
//		val usuario = usuarioService.buscarUsuarioPorId(idUser)
//		ResponseEntity.ok(usuario)
//	}
//
//	@JsonView(View.Usuario.Perfil)
//	@PutMapping(value="/perfilDeUsuario/{idUser}")
//	def actualizarUsuario(@RequestBody Usuario usuarioBody, @PathVariable Long idUser) {
//		val usuario = usuarioService.actualizarUsuario(idUser, usuarioBody)
//		ResponseEntity.ok.body(usuario)
//	}
//
//	@JsonView(View.Usuario.TablaNoAmigos)
//	@GetMapping(value="/usuarios/noAmigos/{idUser}")
//	def buscarUsuariosNoAmigos(@PathVariable Long idUser) {
//		val usuariosNoAmigos = usuarioService.buscarUsuariosNoAmigos(idUser)
//		ResponseEntity.ok(usuariosNoAmigos)
//	}
//
//	@JsonView(View.Usuario.Perfil)
//	@PutMapping(value="/usuarios/{idUser}/agregarAmigo/{nuevoAmigoId}")
//	def agregarAmigo(@PathVariable Long idUser, @PathVariable Long nuevoAmigoId) {
//		val usuario = usuarioService.agregarAmigo(idUser, nuevoAmigoId)
//		ResponseEntity.ok.body(usuario)
//	}
}
