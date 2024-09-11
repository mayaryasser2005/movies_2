import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies_2/firebase_model/movie_model.dart';

class FirebaseFunctions {
  static CollectionReference<MovieModel> getMoviesCollection() {
    return FirebaseFirestore.instance
        .collection("List Movies")
        .withConverter<MovieModel>(
      fromFirestore: (snapshot, _) {
        return MovieModel.fromJson(snapshot.data()!);
      },
      toFirestore: (movie, _) {
        return movie.toJson();
      },
    );
  }

  static Future<void> addMovie(MovieModel movie) {
    var collection = getMoviesCollection();
    var docRef = collection.doc();
    movie.id = docRef.id;
    return docRef.set(movie);
  }

  static Future<void> deleteTask(String id) {
    return getMoviesCollection().doc(id).delete();
  }
}
