package appPregunta3.dao

import appPregunta3.dominio.Usuario
import org.springframework.data.repository.CrudRepository
import java.util.Optional
import org.springframework.data.jpa.repository.EntityGraph
import org.springframework.stereotype.Repository
import org.springframework.data.jpa.repository.Query
import java.util.Set

@Repository
interface RepoUsuario extends CrudRepository<Usuario, Long> {

	def Optional<Usuario> findByUserNameAndPassword(String userName, String password);
	
	def Optional<Usuario> findByUserName(String userName);
	
//	@EntityGraph(attributePaths=#["amigos"])
//	override findAll()
	
	@EntityGraph(attributePaths=#["amigos","respuestas"])
	override findById(Long id)
	
	@Query("SELECT u FROM Usuario u WHERE u not in (
	SELECT a FROM Usuario u INNER JOIN u.amigos a WHERE u.id = ?1) AND u.id != ?1")
	def Set<Usuario> findNoAmigosDe(Long userId)
}
