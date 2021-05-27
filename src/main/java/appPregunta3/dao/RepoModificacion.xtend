package appPregunta3.dao

import org.springframework.data.mongodb.repository.MongoRepository
import appPregunta3.dominio.Modificacion
import java.util.Collection

interface RepoModificacion extends MongoRepository<Modificacion, String> {
	
	def Collection<Modificacion> findByIdUsuario(Long idUsuario)

}