import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {

  Recipe(this.reference);

  Recipe.fromMap(Map<String, dynamic> map, {this.reference}) 
    : /*this.id = map['id'],*/
    this.displayName = map['displayName'],
    this.isShared = map['isShared'],
    this.date = map['date'],
    this.brewer = map['brewer'],
    this.beanName = map['beanName'],
    this.steps = map['steps'],
    this.tastingNotes = map['tastingNotes'],
    this.userId = map['userId'],
    this.userPhotoUrl = map['userPhotoUrl'];

  Recipe.fromSnapshot(DocumentSnapshot snapshot) 
    : this.fromMap(snapshot.data, reference: snapshot.reference);

  String beanName;
  String brewer;
  String date;
  String displayName;
  String userPhotoUrl;
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
      'userPhotoUrl' : userPhotoUrl,
    };
  }

  Recipe.dummyRecipe() :
    this.beanName = "This recipe has been deleted/removed by its owner",
    this.brewer = "Na",
    this.date = "Na",
    this.displayName = "Na",
    this.isShared = false,
    reference = null,
    this.steps = [],
    this.tastingNotes = "Na",
    this.userId = "Na";
  
}