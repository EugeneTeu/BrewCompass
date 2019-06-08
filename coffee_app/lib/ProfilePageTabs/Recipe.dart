import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  String id;
  String date;
  String beanName;
  String steps;
  final DocumentReference reference;

  Recipe.fromMap(Map<String, dynamic> map, {this.reference}) 
    : this.id = map['id'],
    this.date = map['date'],
    this.beanName = map['beanName'],
    this.steps = map['steps'];


  Recipe.fromSnapshot(DocumentSnapshot snapshot) 
    : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Recipe for <$beanName, Date Brewed:$date, id: $id>";
}