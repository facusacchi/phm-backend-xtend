package appPregunta3.facade.service

import org.springframework.beans.factory.annotation.Autowired
import appPregunta3.dao.RepoListaDeRespuestas
import appPregunta3.exceptions.NotFoundException
import org.springframework.stereotype.Service
import com.fasterxml.jackson.databind.ObjectMapper
import appPregunta3.dominio.Respuesta

@Service
class ListaDeRespuestasService {

	@Autowired
	RepoListaDeRespuestas repoListaDeRespuestas

	def getRespuestasPorUsuario(Long idUser) {
		val listaDeRespuestas = repoListaDeRespuestas.findById(idUser).orElseThrow([
			throw new NotFoundException("Respuestas no encontradas")
		])
		val objectMapper = new ObjectMapper();
		val listaToJson = listaDeRespuestas.respuestas.map(respuesta|objectMapper.readValue(respuesta, Respuesta)).toList
//		listaDeRespuestas.respuestas
		listaToJson
	}

}
