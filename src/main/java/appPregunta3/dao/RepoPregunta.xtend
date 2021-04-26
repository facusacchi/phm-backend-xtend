package appPregunta3.dao

import appPregunta3.dominio.Pregunta
import java.util.List
import java.util.Set
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository
import org.springframework.data.jpa.repository.EntityGraph
import org.springframework.data.jpa.repository.Query

@Repository
interface RepoPregunta extends CrudRepository<Pregunta, Long> {

	@EntityGraph(attributePaths=#["autor"])
	def List<Pregunta> findByDescripcionContainsIgnoreCase(String descripcion)

	@EntityGraph(attributePaths=#["opciones", "autor"])
	override Set<Pregunta> findAll()

	@EntityGraph(attributePaths=#["opciones", "autor"])
	override findById(Long id)

	@EntityGraph(attributePaths=#["autor"])
	@Query("SELECT p FROM Pregunta p WHERE p.descripcion not in 
	(SELECT r.pregunta FROM Usuario u INNER JOIN u.respuestas r WHERE p.descripcion = r.pregunta AND u.id = ?1)")
	def List<Pregunta> findAllNoRespondidasPor(Long idUser)
}
