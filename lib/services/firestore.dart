import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //get collection notes
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  //create new note
  Future<void> addNote(
      String uid, String country, String subject, String note) {
    return notes.add({
      'uid': uid,
      'country': country,
      'subject': subject,
      'note': note,
      'timestamp': Timestamp.now()
    });
  }

  //get notes
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        notes.orderBy('timestamp', descending: true).snapshots();

    return notesStream;
  }

  //update
  Future<void> updateNote(
      String docID, String newCountry, String newSubject, String newNote) {
    return notes.doc(docID).update({
      'country': newCountry,
      'subject': newSubject,
      'note': newNote,
      'timestamp': Timestamp.now()
    });
  }

  //delete
  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}
