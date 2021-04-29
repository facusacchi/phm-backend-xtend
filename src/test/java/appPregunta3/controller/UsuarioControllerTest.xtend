package appPregunta3.controller

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.test.context.ActiveProfiles
import org.junit.jupiter.api.DisplayName
import org.springframework.test.web.servlet.MockMvc
import org.junit.jupiter.api.Test
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders
import org.springframework.http.MediaType
import javax.transaction.Transactional

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status
import appPregunta3.dao.RepoPregunta
import org.junit.jupiter.api.BeforeEach

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@DisplayName("Dado un controller de usuarios")
class UsuarioControllerTest {

	@Autowired
	MockMvc mockMvc
	
	@Autowired
	RepoPregunta repoPregunta
	
	Long preguntaId
	
	@BeforeEach()
	def void init() {
		preguntaId = repoPregunta.findAll.head.id
	}

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
	
	@Test
	@DisplayName("responder una pregunta correctamente")
	@Transactional
	def void responderCorrectamente() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.put("/perfilDeUsuario/{idUser}/pregunta/{idPregunta}", "1", preguntaId)
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"opcionElegida":"Es existencial","pregunta":"¿Por que sibarita es tan rica?"}')
		)
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(content.string("true"))		
	}
	
	@Test
	@DisplayName("responder una pregunta incorrectamente")
	@Transactional
	def void responderIncorrectamente() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.put("/perfilDeUsuario/{idUser}/pregunta/{idPregunta}", "1", preguntaId)
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"opcionElegida":"Por la masa","pregunta":"¿Por que sibarita es tan rica?"}')
		)
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(content.string("false"))		
	}
	
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
	
	@Test
	@DisplayName("No se puede obtener un usuario por el id Inexistente, not found")
	def void buscarUsuarioPorIdNoEncontrado() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/perfilDeUsuario/{idUser}", "1456"))
		.andExpect(status.notFound)
	}

	@Test
	@DisplayName("al buscar un usuario por id incorrecto devuelve 400")
	def void buscarUsuarioPorIdIncorrecto() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/perfilDeUsuario/{idUser}", "idInvalido"))
		.andExpect(status.badRequest)
	}
	
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
		.andExpect(jsonPath("$.id").value(1))
	}

	@Test
	@DisplayName("buscar todos los no amigos de un usuario")
	def void buscarNoAmigos() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/usuarios/noAmigos/{idUser}", "1"))
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.length()").value(6))
	}

}
