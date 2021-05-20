# Entrega 2 - MongoDB
## Consultas
1. Saber qué pregunta se modificó más.

2. Saber cuántas preguntas de un año determinado son del tipo solidaria. 

3. Saber qué preguntas están habilitadas para responder a partir de una determinada fecha.
```js
db.getCollection('preguntas').find({fechaHoraCreacion: { $gte: new Date((new Date().getTime()-(300000))), $lte: new Date()}})
```
