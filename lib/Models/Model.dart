import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String followers;
  final String profile;
  final int followings;
  final int posts;

  const UserModel(
      {required this.id,
      required this.name,
      required this.followers,
      required this.profile,
      required this.followings,
      required this.posts});

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      name: json['name'],
      followers: json['followers'],
      profile: json['profile'],
      followings: json['following'],
      posts: json['posts']);
}

class PostModel {
  final int serial;
  final String caption;
  final int likes;
  final int comments;
  final String imageURL;
  const PostModel(
      {required this.serial,
      required this.caption,
      required this.likes,
      required this.comments,
      required this.imageURL});
  static PostModel fromJson(Map<String, dynamic> json) => PostModel(
      serial: json['Sr.No.'],
      caption: json['caption'],
      likes: json['likes'],
      comments: json['comments'],
      imageURL: json['imageURL']);
}

class ChartModel{
  int likes;
  int comments;
  ChartModel(
  {required this.likes,required this.comments}
      );
}
Stream<List<PostModel>> getPostData() {
  return FirebaseFirestore.instance
      .collection('UserData')
      .doc('thisisbillgates')
      .collection('Posts')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => PostModel.fromJson(doc.data())).toList());
}

List<ChartModel>getChartData(){
  List<ChartModel> charts=[];
  getPostData().listen((event) {event.map((e) => charts.add(ChartModel(likes: e.likes, comments: e.comments))).toList();});
  return charts;
}

