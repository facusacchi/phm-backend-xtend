# Entrega 2 - MongoDB
## Consultas
1. Saber qué pregunta se modificó más.
```js
db.modificaciones.aggregate (
	[
               { $group: { _id: '$preguntaId', vecesEditada: { $sum : 1 } } },
               { $sort: { vecesEditada: -1 } },
               { $limit: 1 }                 
        ]
)
```
2. Saber cuántas preguntas de un año determinado son del tipo solidaria. 
```js
function solidariasPorAnio(anio) {
  return db
    .getCollection("preguntas")
    .find({
      $and: [
        { tipo: "solidaria" },

        { fechaHoraCreacion: { $gte: new Date(anio, 0, 1) } },

        { fechaHoraCreacion: { $lt: new Date(anio + 1, 0, 1) } },
      ],
    })
    .count();
}

solidariasPorAnio(2021);
```
3. Saber qué preguntas están habilitadas para responder a partir de una determinada fecha.
```js
db.getCollection('preguntas').find({fechaHoraCreacion: { $gte: new Date((new Date().getTime()-(300000))), $lte: new Date()}})
```
