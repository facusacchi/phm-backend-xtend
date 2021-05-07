package appPregunta3.dao

import org.springframework.data.mongodb.repository.MongoRepository
import appPregunta3.dominio.Modificacion

interface RepoModificacion extends MongoRepository<Modificacion, String> {

}