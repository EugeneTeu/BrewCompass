import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  int id;
  String date;
  String beanName;
  String brewer;
  List steps;
  String tastingNotes;
  String userId;
  final DocumentReference reference;

  Recipe.fromMap(Map<String, dynamic> map, {this.reference}) 
    : this.id = map['id'],
    this.date = map['date'],
    this.brewer = map['brewer'],
    this.beanName = map['beanName'],
    this.steps = map['steps'],
    this.tastingNotes = map['tastingNotes'],
    this.userId =map['userId'];


  Recipe.fromSnapshot(DocumentSnapshot snapshot) 
    : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Recipe for <$beanName, date: $date, id: $id>";
}