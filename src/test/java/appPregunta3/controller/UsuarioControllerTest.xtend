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
import org.springframework.transaction.annotation.Transactional

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
	
	@Test
	@DisplayName("usuario no ingresa su userName y devuelve un 400")
	def void loguearUsuarioSinUserName(){
		mockMvc
		.perform(
			MockMvcRequestBuilders.post("/login")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"password":"123"}')
		)
		.andExpect(status.badRequest)
	}
	
	@Test
	@DisplayName("login de usuario devuelve Not Found")
	def void loguearUsuarioNoEncontrado(){
		mockMvc
		.perform(
			MockMvcRequestBuilders.post("/login")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"userName":"pepita","password":"456"}')
		)
		.andExpect(status.notFound)
	}
	
//	@JsonView(View.Usuario.Perfil)
//	@PutMapping(value="/perfilDeUsuario/{idUser}/pregunta/{idPregunta}")
//	def responder(@PathVariable Long idUser, @PathVariable Long idPregunta, @RequestBody Respuesta respuesta) {
//		val esCorrecta = usuarioService.responder(idUser, idPregunta, respuesta)
//		ResponseEntity.ok(esCorrecta)
//	}
    @Test
	@DisplayName("se puede obtener un usuario por el id")
	def void buscarUsuarioPorId() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/perfilDeUsuario/{idUser}", "1"))
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.id").value("1"))
		.andExpect(jsonPath("$.nombre").value("Pepe"))
	}
//
//	@JsonView(View.Usuario.Perfil)
//	@GetMapping("/perfilDeUsuario/{idUser}")
//	def buscarUsuarioPorId(@PathVariable Long idUser) {
//		val usuario = usuarioService.buscarUsuarioPorId(idUser)
//		ResponseEntity.ok(usuario)
//	}

    @Test
	@DisplayName("se puede actualizar un usuario por id con un body válido")
	@Transactional
	def void actualizarUsuario() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.put("/perfilDeUsuario/{idUsuario}","1")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"nombre": "petete", "apellido": "pal","fechaDeNacimiento": "1995-05-13"}')
		)
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.nombre").value('petete'))
		.andExpect(jsonPath("$.apellido").value('pal'))
		.andExpect(jsonPath("$.fechaDeNacimiento").value('1995-05-13'))
	}
	
	@Test
	@DisplayName("no se puede actualizar un usuario por id inexistente")
	def void actualizarUsuarioInexistente() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.put("/perfilDeUsuario/{idUsuario}","1083")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"nombre": "petete", "apellido": "pal","fechaDeNacimiento": "1995-05-13"}')
		)
		.andExpect(status.notFound)
	}
	
	@Test
	@DisplayName("no se puede actualizar un usuario con campos nulos")
	def void actualizarUsuarioConCamposNulos() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.put("/perfilDeUsuario/{idUsuario}","1083")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"nombre": "petete", "apellido": "pal"}')
		)
		.andExpect(status.badRequest)
	}

    @Test
	@DisplayName("se puede agregar amigos a un usuario")
	@Transactional
	def void agregarAmigo() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.put("/usuarios/{idUsuario}/agregarAmigo/{nuevoAmigoId}","1","6")
		)
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("usuario.id").value(1))
	}

//	@JsonView(View.Usuario.TablaNoAmigos)
//	@GetMapping(value="/usuarios/noAmigos/{idUser}")
//	def buscarUsuariosNoAmigos(@PathVariable Long idUser) {
//		val usuariosNoAmigos = usuarioService.buscarUsuariosNoAmigos(idUser)
//		ResponseEntity.ok(usuariosNoAmigos)
//	}

}
