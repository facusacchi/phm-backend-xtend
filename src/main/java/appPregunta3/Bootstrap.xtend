package appPregunta3

import dominio.Usuario
import repos.RepoUsuario
import java.time.LocalDate
import dominio.Simple
import java.time.LocalDateTime
import repos.RepoPregunta
import dominio.DeRiesgo
import dominio.Solidaria

class Bootstrap {

	Usuario pepe
	Usuario manolo
	Usuario nancy
	Usuario casandra
	Usuario lucrecia
	Usuario pancho
	Usuario elena

	def void run() {
		crearUsuarios
		crearPreguntas
	}

	def crearUsuarios() {
		pepe = new Usuario => [
			nombre = "Pepe"
			apellido = "Palala"
			userName = "pepito"
			password = "123"
			fechaDeNacimiento = LocalDate.of(1990, 7, 28)
		]
		RepoUsuario.instance.create(pepe)

		manolo = new Usuario => [
			nombre = "Manolo"
			apellido = "Palala"
			userName = "manolito"
			password = "456"
			fechaDeNacimiento = LocalDate.of(1995, 10, 4)
		]
		RepoUsuario.instance.create(manolo)

		nancy = new Usuario => [
			nombre = "Nancy"
			apellido = "Vargas"
			userName = "nan"
			password = "123"
			fechaDeNacimiento = LocalDate.of(1985, 5, 7)
		]
		RepoUsuario.instance.create(nancy)

		casandra = new Usuario => [
			nombre = "Casandra"
			apellido = "Malandra"
			userName = "casalandra"
			password = "774"
			fechaDeNacimiento = LocalDate.of(1985, 5, 7)
		]
		RepoUsuario.instance.create(casandra)

		lucrecia = new Usuario => [
			nombre = "Lucrecia"
			apellido = "Magnesia"
			userName = "lugenesia"
			password = "122"
			fechaDeNacimiento = LocalDate.of(1985, 5, 7)
		]
		RepoUsuario.instance.create(lucrecia)

		pancho = new Usuario => [
			nombre = "Pancho"
			apellido = "Rancho"
			userName = "zafarancho"
			password = "999"
			fechaDeNacimiento = LocalDate.of(1985, 5, 7)
		]
		RepoUsuario.instance.create(pancho)

		elena = new Usuario => [
			nombre = "Elena"
			apellido = "Melena"
			userName = "melinena"
			password = "364"
			fechaDeNacimiento = LocalDate.of(1985, 5, 7)
		]
		RepoUsuario.instance.create(elena)
	}
	
	def crearPreguntas() {
		RepoPregunta.instance.create(new Simple => [
			descripcion = "¿Por que sibarita es tan rica?"
			autor = pepe
			fechaHoraCreacion = LocalDateTime.now
			agregarOpcion("Por la muzza")
			agregarOpcion("Por la salsa")
			agregarOpcion("por la masa")
			agregarOpcion("No hay motivo")
			agregarOpcion("Es existencial")
		])
		
		RepoPregunta.instance.create(new Simple => [
			descripcion = "¿Cual es la masa del sol?"
			autor = pancho
			fechaHoraCreacion = LocalDateTime.now
			agregarOpcion("Mucha")
			agregarOpcion("Poca")
			agregarOpcion("Maso")
			agregarOpcion("No se sabe")
		])
		
		RepoPregunta.instance.create(new DeRiesgo => [
			descripcion = "¿Que es mas lento que un piropo de tartamudo?"
			autor = manolo
			fechaHoraCreacion = LocalDateTime.now
			agregarOpcion("Un caracol")
			agregarOpcion("Higuain")
			agregarOpcion("Una babosa")
			agregarOpcion("Nada")
		])
		
		RepoPregunta.instance.create(new DeRiesgo => [
			descripcion = "Cocodrilo que durmio es..."
			autor = pancho
			fechaHoraCreacion = LocalDateTime.now
			agregarOpcion("Feroz")
			agregarOpcion("Anfibio")
			agregarOpcion("Cartera")
			agregarOpcion("Yacare")
			agregarOpcion("No existe el dicho")
		])
		
		RepoPregunta.instance.create(new Solidaria => [
			descripcion = "Hamlet es una obra de..."
			autor = casandra
			fechaHoraCreacion = LocalDateTime.now
			puntosDonados = 15
			agregarOpcion("Pato donald")
			agregarOpcion("Micky Mouse")
			agregarOpcion("Gallo Claudio")
			agregarOpcion("Coyote")
			agregarOpcion("Shakespare")
		])
		
		RepoPregunta.instance.create(new Solidaria => [
			descripcion = "Mas vale pajaro en mano que..."
			autor = pepe
			fechaHoraCreacion = LocalDateTime.now
			puntosDonados = 30
			agregarOpcion("Pajaro perdido")
			agregarOpcion("Cien volando")
			agregarOpcion("Una avestrus")
			agregarOpcion("Se te escape")
			agregarOpcion("Mano sin pajaro")
		])
	}

}
