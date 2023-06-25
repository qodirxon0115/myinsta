import 'package:firebase_storage/firebase_storage.dart';
import 'package:myinsta/services/auth_service.dart';
import 'package:myinsta/services/utils_service.dart';

import '../model/member_model.dart';

class DBService {
  static final fireStore = FirebaseStorage.instance;

  static String folderUsers = "users";

  static Future storeMember(Member member) async {
    member.uid = AuthService.currentUserId();
    Map<String, String> params = await Utils.deviceParames();

    member.deviceId = params["deviceId"]!;
    member.deviceType = params["deviceType"]!;
    member.deviceToken = params["deviceToken"]!;
    return fireStore
        .collection(folderUsers)
        .doc(member.uid)
        .set(member.toJson());
  }

  static Future<Member> loadMember()async{
    String uid = AuthService.currentUserId();
    var value = await fireStore.collection(folderUsers).doc(uid).get();
    Member member = Member.fromJson(value.data()!);
    return member;
  }

  static Future<Member> updateMember(Member member) async{
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


}
