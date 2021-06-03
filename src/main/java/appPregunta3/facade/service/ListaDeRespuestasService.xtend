package appPregunta3.facade.service

import org.springframework.beans.factory.annotation.Autowired
import appPregunta3.dao.RepoListaDeRespuestas
import appPregunta3.exceptions.NotFoundException
import org.springframework.stereotype.Service
import appPregunta3.dominio.Respuesta

@Service
class ListaDeRespuestasService {

	@Autowired
	RepoListaDeRespuestas repoListaDeRespuestas

	def getRespuestasPorUsuario(Long idUser) {
		val listaDeRespuestas = repoListaDeRespuestas.findById(idUser).orElseThrow([
			throw new NotFoundException("Respuestas no encontradas")
		])
		listaDeRespuestas
	}
	
	def agregarRespuestaAlUsuario(Respuesta respuesta, Long idUser) {
		val listaDeRespuestas = getRespuestasPorUsuario(idUser)
		listaDeRespuestas.agregarRespuesta(respuesta)
		repoListaDeRespuestas.save(listaDeRespuestas)
	}

}
