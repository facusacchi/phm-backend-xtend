package appPregunta3.dao

import appPregunta3.dominio.Pregunta
//import org.springframework.stereotype.Repository
import org.springframework.data.mongodb.repository.MongoRepository
import org.springframework.data.mongodb.repository.Query
import java.util.Collection
import java.util.Set

interface RepoPregunta extends MongoRepository<Pregunta, String> {

	def Collection<Pregunta> findByDescripcionContainsIgnoreCase(String descripcion)

	@Query("{ descripcion: { $nin:?0 } }")
	def Set<Pregunta> findAllNoRespondidasPor(Set<String> preguntasRespondidas)
}
