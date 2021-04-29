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
import org.springframework.http.MediaType
import javax.transaction.Transactional

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
	@DisplayName("Buscar pregunta por id")
	def void getPreguntaPorId() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/pregunta/{id}", preguntaId))
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.descripcion").value("¿Por que sibarita es tan rica?"))
	}
	
	@Test
	@DisplayName("Buscar pregunta por id inexistente, lanza status 404")
	def void getPreguntaPorIdInexistente() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/pregunta/{id}","9999"))
		.andExpect(status().isNotFound())
	}
	
	@Test
	@DisplayName("Buscar pregunta con id null, lanza status 400")
	def void getPreguntaPorIdNull() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/pregunta/{id}", "null"))
		.andExpect(status().isBadRequest())
	}
	
	@Test
	@DisplayName("Buscar todas las preguntas activas")
	def void getTodasLasPreguntasActivas() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/preguntasAll/{activas}/{idUser}", "true", "1"))
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.length()").value(3))
	}
	
	@Test
	@DisplayName("Actualizar una pregunta")
	@Transactional
	def void actualizarPregunta() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.put("/pregunta/{id}", preguntaId)
			.contentType(MediaType.APPLICATION_JSON)
			.content('{	"id":' + preguntaId + ',
						"respuestaCorrecta":"Es existencial",
						"descripcion":"¿Por que sibarita es tan fea?",
						"opciones":["Por la salsa","Por la muzza","No hay motivo","Por la masa","Es existencial"],
						"type":"simple"}')
		)
		.andExpect(status.isOk)
		.andExpect(content.contentType("text/plain;charset=UTF-8"))
		.andExpect(content.string("Pregunta actualizada correctamente"))		
	}
	
	@Test
	@DisplayName("Intentar actualizar una pregunta con opción correcta vacía, devuelve 400")
	def void actualizarPreguntaOpcionCorrectaVaciaError() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.put("/pregunta/{id}", preguntaId)
			.contentType(MediaType.APPLICATION_JSON)
			.content('{	"id":' + preguntaId + ',
						"respuestaCorrecta":"",
						"descripcion":"¿Por que sibarita es tan fea?",
						"opciones":["Por la salsa","Por la muzza","No hay motivo","Por la masa","Es existencial"],
						"type":"simple"}')
		)
		.andExpect(status.badRequest)
	}
	
	@Test
	@DisplayName("Crear una nueva pregunta satisfactoriamente")
	@Transactional
	def void creoPreguntaSatisfactoriaente() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.post("/{idAutor}/pregunta", "1")
				.contentType(MediaType.APPLICATION_JSON)
				.content('{
    						"descripcion": "nueva",
    						 "respuestaCorrecta": "correcta",
    						 "opciones": [
            								"correcta",
				            				"opcion1",
            								"opcion2"
    									],
    						 "type": "simple"
						}')
		)
		.andExpect(status.isOk)
		.andExpect(content.contentType("text/plain;charset=UTF-8"))
		.andExpect(content.string("Pregunta creada correctamente"))
	}
	
	@Test
	@DisplayName("Intentar crear una pregunta con descripción vacía, devuelve 400")
	def void crearPreguntaDescripcionVaciaError() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.post("/{idAutor}/pregunta", "1")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{
    						"descripcion": "",
    						 "respuestaCorrecta": "correcta",
    						 "opciones": [
            								"correcta",
				            				"opcion1",
            								"opcion2"
    									],
    						 "type": "simple"
						}')
		)
		.andExpect(status.badRequest)
	}
	
	@Test
	@DisplayName("Intentar crear una pregunta sin opciones, devuelve 400")
	def void crearPreguntaSinOpcionesError() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.post("/{idAutor}/pregunta", "1")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{
    						"descripcion": "sin opciones",
    						 "respuestaCorrecta": "correcta",
    						 "opciones": [],
    						 "type": "simple"
						}')
		)
		.andExpect(status.badRequest)
	}
	
	@Test
	@DisplayName("Intentar crear una pregunta con body inválido, devuelve 400")
	def void crearPreguntaInvalidaError() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.post("/{idAutor}/pregunta", "1")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{}')
		)
		.andExpect(status.badRequest)
	}
}