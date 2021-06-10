package appPregunta3.dao

import org.springframework.data.repository.CrudRepository
import appPregunta3.dominio.ListaDeRespuestas

interface RepoListaDeRespuestas extends CrudRepository<ListaDeRespuestas, Long> {}
