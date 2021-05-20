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
