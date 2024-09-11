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

    return docRef.set(movie);
  }

  static Future<void> deleteTask(int id) {
    return getMoviesCollection().doc(id as String?).delete();
  }

  static Future<QuerySnapshot<MovieModel>> getMovie() {
    var movieCollection = getMoviesCollection();
    return movieCollection.get();
    // .where("date",isEqualTo: date.millisecondsSinceEpoch)
    //     .snapshots();
  }

  static Future<bool> isMovieInWatchList(String movieId) async {
    var moviewQuery = await getMovie();
    for (var doc in moviewQuery.docs) {
      if (movieId == doc.data().id) {
        return true;
      }
    }
    return false;

    // .where("date",isEqualTo: date.millisecondsSinceEpoch)
    //     .snapshots();
  }

  static Future<void> updateMovie(MovieModel movie) {
    return getMoviesCollection().doc(movie.id as String).update(movie.toJson());
  }
}

//movie.id = docRef.id as int;