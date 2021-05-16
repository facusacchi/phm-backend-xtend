package appPregunta3.dao

import appPregunta3.dominio.Pregunta
//import org.springframework.stereotype.Repository
import org.springframework.data.mongodb.repository.MongoRepository
import org.springframework.data.mongodb.repository.Query
import java.util.Collection
import java.util.Set

//@Repository
interface RepoPregunta extends MongoRepository<Pregunta, String> {

	def Collection<Pregunta> findByDescripcionContainsIgnoreCase(String descripcion)

//	override Set<Pregunta> findAll()
//	override findById(Long id)

	@Query("{ descripcion: { $nin:?0 } }")
	def Set<Pregunta> findAllNoRespondidasPor(Set<String> preguntasRespondidas)
}
