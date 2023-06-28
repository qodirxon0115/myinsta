import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myinsta/model/post_model.dart';
import 'package:myinsta/services/auth_service.dart';
import 'package:myinsta/services/utils_service.dart';

import '../model/member_model.dart';

class DBService {
  static final fireStore = FirebaseFirestore.instance;

  static String folderUsers = "users";
  static String folderPost = "posts";
  static String folderFeed = "feeds";

  // Member Related

  static Future storeMember(Member member) async {
    member.uid = AuthService.currentUserId();
    Map<String, String> params = await Utils.deviceParams();

    member.deviceId = params["deviceId"]!;
    member.deviceType = params["deviceType"]!;
    member.deviceToken = params["deviceToken"]!;
    return fireStore
        .collection(folderUsers)
        .doc(member.uid)
        .set(member.toJson());
  }

  static Future<Member> loadMember() async {
    String uid = AuthService.currentUserId();
    var value = await fireStore.collection(folderUsers).doc(uid).get();
    Member member = Member.fromJson(value.data()!);
    return member;
  }

  static Future updateMember(Member member) async {
    String uid = AuthService.currentUserId();
    return fireStore.collection(folderUsers).doc(uid).update(member.toJson());
  }

  static Future<List<Member>> searchMembers(String keyword) async {
    List<Member> members = [];
    String uid = AuthService.currentUserId();

    var querySnapshot = await fireStore
        .collection(folderUsers)
        .orderBy("email")
        .startAt([keyword]).get();
    print(querySnapshot.docs.length);

    querySnapshot.docs.forEach((result) {
      Member newMember = Member.fromJson(result.data());
      if (newMember.uid != uid) {
        members.add(newMember);
      }
    });

    return members;
  }

  static Future<Post> storePost(Post post) async {
    Member me = await loadMember();
    post.uid = me.uid;
    post.fullName = me.fullName;
    post.imgUser = me.imgUrl;
    post.date = Utils.currentDate();

    String postId = fireStore
        .collection(folderUsers)
        .doc(me.uid)
        .collection(folderPost)
        .doc()
        .id;
    post.id = postId;

    await fireStore
        .collection(folderUsers)
        .doc(me.uid)
        .collection(folderPost)
        .doc(postId)
        .set(post.toJson());

    return post;
  }

  static Future<Post> storeFeed(Post post) async {
    String uid = AuthService.currentUserId();

    await fireStore
        .collection(folderUsers)
        .doc(uid)
        .collection(folderFeed)
        .doc(post.id)
        .set(post.toJson());
    return post;
  }

  static Future<List<Post>> loadPosts() async {
    List<Post> posts = [];
    String uid = AuthService.currentUserId();
    var querySnapshot = await fireStore
        .collection(folderUsers)
        .doc(uid)
        .collection(folderPost)
        .get();

    querySnapshot.docs.forEach((result) {
      posts.add(Post.fromJson(result.data()));
    });
    return posts;
  }

  static Future<List<Post>> loadFeeds() async {
    List<Post> posts = [];
    String uid = AuthService.currentUserId();
    var querySnapshot = await fireStore
        .collection(folderUsers)
        .doc(uid)
        .collection(folderFeed)
        .get();

    querySnapshot.docs.forEach((result) {
      posts.add(Post.fromJson(result.data()));
    });

    return posts;
  }
}
