package appPregunta3.dominio

import java.time.LocalDate
import java.util.HashSet
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors
import org.springframework.data.mongodb.core.mapping.Document
import org.springframework.data.annotation.Id

@Document(collection = "modificaciones")
@Accessors(PUBLIC_GETTER)
class Modificacion {
	
	new(
		LocalDate fecha,
		String preguntaOld,
		String preguntaNew,
		Set<String> opcionesOld,
		Set<String> opcionesNew
	) { }
	
	@Id
	String id
	LocalDate fecha	
	String preguntaOld
	String preguntaNew
	Set<String> opcionesOld = new HashSet<String>
	Set<String> opcionesNew = new HashSet<String>	
}