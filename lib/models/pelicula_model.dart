class Pelicula {
  final String idPelicula;
  final String nombre;
  final String genero;
  final String duracion;
  final double calificacion;
  final String urlPoster;

  Pelicula({
    required this.idPelicula,
    required this.nombre,
    required this.genero,
    required this.duracion,
    required this.calificacion,
    required this.urlPoster,
  });

  factory Pelicula.fromMap(Map<String, dynamic> map, {String? docId}) {
    return Pelicula(
      idPelicula: docId ?? map['Id_pelicula'] ?? '',
      nombre: map['Nombre'] ?? '',
      genero: map['Genero'] ?? '',
      duracion: map['duracion'] ?? '',
      calificacion: double.tryParse(map['calificacion'].toString()) ?? 0.0,
      urlPoster: map['url_poster'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'Id_pelicula': idPelicula,
        'Nombre': nombre,
        'Genero': genero,
        'duracion': duracion,
        'calificacion': calificacion,
        'url_poster': urlPoster,
      };

  Pelicula copyWith({
    String? idPelicula,
    String? nombre,
    String? genero,
    String? duracion,
    double? calificacion,
    String? urlPoster,
  }) {
    return Pelicula(
      idPelicula: idPelicula ?? this.idPelicula,
      nombre: nombre ?? this.nombre,
      genero: genero ?? this.genero,
      duracion: duracion ?? this.duracion,
      calificacion: calificacion ?? this.calificacion,
      urlPoster: urlPoster ?? this.urlPoster,
    );
  }
}
