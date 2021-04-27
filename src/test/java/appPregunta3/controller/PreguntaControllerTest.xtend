package appPregunta3.controller

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.test.context.ActiveProfiles
import org.junit.jupiter.api.DisplayName
import org.springframework.test.web.servlet.MockMvc
import org.springframework.beans.factory.annotation.Autowired
import org.junit.jupiter.api.Test
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders
import org.junit.jupiter.api.BeforeEach
import appPregunta3.dao.RepoPregunta

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@DisplayName("Dado un controller de preguntas")
class PreguntaControllerTest {
	
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
	@DisplayName("Buscar pregunta por valor de busqueda, no activa, no respondida por user")
	def void getPreguntasPorStringNoActivas() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/preguntas/{valorBusqueda}/{activas}/{idUser}", "Cual es la masa", "false", "1"))
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.[0].descripcion").value("¿Cual es la masa del sol?"))
	}
	
	@Test
	@DisplayName("Buscar pregunta por valor de busqueda, activa, no respondida por user")
	def void getPreguntasPorStringActivas() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/preguntas/{valorBusqueda}/{activas}/{idUser}", "mas lento", "true", "1"))
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.[0].descripcion").value("¿Que es mas lento que un piropo de tartamudo?"))
	}
	
	@Test
	@DisplayName("Busco pregunta por id")
	def void getPreguntaPorId() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/pregunta/{id}", preguntaId))
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.descripcion").value("¿Por que sibarita es tan rica?"))
	}
	
	@Test
	@DisplayName("Busco pregunta por id inexistente, lanza una 404")
	def void getPreguntaPorIdInexistente() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/pregunta/{id}","9999"))
		.andExpect(status().isNotFound())
	}
	
	@Test
	@DisplayName("Busco todas las preguntas activas")
	def void getTodasLasPreguntasActivas() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/preguntasAll/{activas}/{idUser}", "true", "1"))
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.length()").value(3))
	}
}