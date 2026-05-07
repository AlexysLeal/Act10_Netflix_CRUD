import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pelicula_model.dart';

class PeliculaService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('peliculas');

  Stream<List<Pelicula>> getPeliculas() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Pelicula.fromMap(
          doc.data() as Map<String, dynamic>,
          docId: doc.id,
        );
      }).toList();
    });
  }

  Future<void> addPelicula(Pelicula pelicula) async {
    final docRef = _collection.doc();
    await docRef.set(pelicula.copyWith(idPelicula: docRef.id).toMap());
  }

  Future<void> updatePelicula(Pelicula pelicula) async {
    await _collection.doc(pelicula.idPelicula).update(pelicula.toMap());
  }

  Future<void> deletePelicula(String id) async {
    await _collection.doc(id).delete();
  }
}
