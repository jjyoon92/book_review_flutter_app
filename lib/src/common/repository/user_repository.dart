import 'package:book_review_app/src/common/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  FirebaseFirestore db;

  UserRepository(this.db);

  Future<UserModel?> findUserOne(String uid) async {
    try {
      var doc = await db.collection('users').where('uid', isEqualTo: uid).get();
      if (doc.docs.isEmpty) {
        return null;
      } else {
        return UserModel.fromJson(doc.docs.first
            .data()); // uid에 대한 조건을 배열로 넘겨주는데, uid는 단 하나만 존재하므로 first로 추출.
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> joinUser(UserModel userModel) async {
    try {
      db.collection('users').add(userModel.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<UserModel>> allUserInfos(List<String> uids) async {
    var doc = await db.collection('users').where('uid', whereIn: uids).get();
    if (doc.docs.isEmpty) {
      return [];
    } else {
      return doc.docs
          .map<UserModel>((data) => UserModel.fromJson(data.data()))
          .toList();
    }
  }
}
