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

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@DisplayName("Dado un controller de usuarios")
class PreguntaControllerTest {
	
	@Autowired
	MockMvc mockMvc
	
	@Test
	@DisplayName("hacer sign in de un usuario")
	def void getPreguntasPorStringNoActivasNoRespondidas() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/preguntas/{valorBusqueda}/{activas}/{idUser}", "Cual es la masa", "false", "1"))
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.[0].descripcion").value("¿Cual es la masa del sol?"))
	}
	
}