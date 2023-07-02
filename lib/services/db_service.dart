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
  static String folderFollowing = "following";
  static String folderFollowers = "followers";

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

    var querySnapshot1 = await fireStore
        .collection(folderUsers)
        .doc(uid)
        .collection(folderFollowers)
        .get();
    member.followersCount = querySnapshot1.docs.length;

    var querySnapshot2 = await fireStore
        .collection(folderUsers)
        .doc(uid)
        .collection(folderFollowing)
        .get();
    member.followingCount = querySnapshot2.docs.length;
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
      Post post = Post.fromJson(result.data());
      if(post.uid == uid) post.mine = true;
      posts.add(post);
    });

    return posts;
  }

  static Future likePost(Post post, bool liked) async {
    String uid = AuthService.currentUserId();
    post.liked = liked;

    await fireStore
        .collection(folderUsers)
        .doc(uid)
        .collection(folderFeed)
        .doc(post.id)
        .set(post.toJson());
    if (uid == post.uid) {
      await fireStore
          .collection(folderUsers)
          .doc(uid)
          .collection(folderPost)
          .doc(post.id)
          .set(post.toJson());
    }
  }

  static Future<List<Post>> loadLikes() async {
    String uid = AuthService.currentUserId();
    List<Post> posts = [];

    var querySnapshot = await fireStore
        .collection(folderUsers)
        .doc(uid)
        .collection(folderFeed)
        .where("liked", isEqualTo: true)
        .get();

    querySnapshot.docs.forEach((result) {
      Post post = Post.fromJson(result.data());
      if (post.uid == uid) post.mine = true;
      posts.add(post);
    });
    return posts;
  }

  static Future<Member> followMember(Member someOne) async {
    Member me = await loadMember();
    await fireStore
        .collection(folderUsers)
        .doc(me.uid)
        .collection(folderFollowing)
        .doc(someOne.uid)
        .set(someOne.toJson());

    await fireStore
        .collection(folderUsers)
        .doc(someOne.uid)
        .collection(folderFollowers)
        .doc(me.uid)
        .set(someOne.toJson());

    return someOne;
  }

  static Future<Member> unfollowMember(Member someOne) async {
    Member me = await loadMember();
    await fireStore
        .collection(folderUsers)
        .doc(me.uid)
        .collection(folderFollowing)
        .doc(someOne.uid)
        .delete();

    await fireStore
        .collection(folderUsers)
        .doc(someOne.uid)
        .collection(folderFollowers)
        .doc(me.uid)
        .delete();

    return someOne;
  }

  static Future storePostsToMyFeed(Member someOne) async {

    List<Post> posts = [];

    var querySnapshot = await fireStore
        .collection(folderUsers)
        .doc(someOne.uid)
        .collection(folderPost)
        .get();

    querySnapshot.docs.forEach((result) {
      var post = Post.fromJson(result.data());
      post.liked = false;
      posts.add(post);
    });

    for(Post post in posts){
      storeFeed(post);
    }
  }
  static Future removePostsFromMyFeed(Member someone) async {
    List<Post> posts = [];
    var querySnapshot = await fireStore
        .collection(folderUsers)
        .doc(someone.uid)
        .collection(folderPost)
        .get();

    querySnapshot.docs.forEach((result) {
      posts.add(Post.fromJson(result.data()));
    });

    for (Post post in posts) {
      removeFeed(post);
    }
  }

  static Future removeFeed(Post post) async {
    String uid = AuthService.currentUserId();

    return await fireStore
        .collection(folderUsers)
        .doc(uid)
        .collection(folderFeed)
        .doc(post.id)
        .delete();
  }

  static Future removePost(Post post) async {
    String uid = AuthService.currentUserId();
    await removeFeed(post);
    return await fireStore
        .collection(folderUsers)
        .doc(uid)
        .collection(folderPost)
        .doc(post.id)
        .delete();
  }
}
