package appPregunta3.dominio

import org.springframework.data.redis.core.RedisHash
import org.springframework.data.annotation.Id
import java.util.Set
import java.util.HashSet
import org.eclipse.xtend.lib.annotations.Accessors
import com.fasterxml.jackson.databind.ObjectMapper

@RedisHash("ListaDeRespuestas")
@Accessors
class ListaDeRespuestas {
	@Id
	Long idUsuario

	Set<String> respuestas = new HashSet<String>
	
	def agregarRespuesta(Respuesta respuesta) {
		val respuestaJson = convertirAJson(respuesta)
		respuestas.add(respuestaJson)
	}
	
	def String convertirAJson(Respuesta respuesta) {
		val objectMapper = new ObjectMapper()
		val respuestaAsString = objectMapper.writeValueAsString(respuesta)
		respuestaAsString
	}
}
