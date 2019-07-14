import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  Recipe.fromMap(Map<String, dynamic> map, {this.reference}) 
    : /*this.id = map['id'],*/
    this.displayName = map['displayName'],
    this.isShared = map['isShared'],
    this.date = map['date'],
    this.brewer = map['brewer'],
    this.beanName = map['beanName'],
    this.steps = map['steps'],
    this.tastingNotes = map['tastingNotes'],
    this.userId = map['userId'];

  Recipe.fromSnapshot(DocumentSnapshot snapshot) 
    : this.fromMap(snapshot.data, reference: snapshot.reference);

  String beanName;
  String brewer;
  String date;
  String displayName;
  //int id;
  bool isShared;

  final DocumentReference reference;
  List steps;
  String tastingNotes;
  String userId;

  @override
  String toString() => "Recipe for <$beanName, date: $date, userId: $userId>";

  //map to json format
  toJson() {
    return {
     /* 'id' : id,*/
     "displayName" : displayName,
      'isShared' : isShared,
      'date' : date,
      'beanName' : beanName,
      'brewer' : brewer,
      'steps' : steps,
      'tasting Notes' : tastingNotes,
      'userId' : userId,
    };
  }
}