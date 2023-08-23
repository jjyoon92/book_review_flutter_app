import 'dart:convert';
import 'dart:math';

import 'package:book_review_app/src/common/model/user_model.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth;

  AuthenticationRepository(this._firebaseAuth);

  Stream<UserModel?> get user {
    return _firebaseAuth.authStateChanges().map<UserModel?>((user) {
      return user == null
          ? null
          : UserModel(
              name: user.displayName,
              uid: user.uid,
              email: user.email,
            );
    });
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }


  Future<void> signInWithGoogle() async {
    // 인증 흐름을 시작합니다.
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // 요청에서 인증 정보를 얻습니다.
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    // 새 자격 증명을 생성합니다.
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
  }

  /// 암호학적으로 안전한 난수 Nonce를 생성하여 자격증명 요청에 포함할 수 있습니다.
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// [input]의 sha256 해시를 16진수 표기법으로 반환합니다.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signInWithApple() async {
    // Apple에서 반환된 자격증명으로부터 재생 공격(replay attack)을 방지하기 위해,
    // 자격증명 요청에 Nonce를 포함합니다. Firebase와 함께 로그인할 때,
    // Apple에서 반환된 id token의 Nonce는 `rawNonce`의 sha256 해시와 일치해야 합니다.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // 현재 Apple 계정에 대한 자격증명을 요청합니다.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Apple에서 반환된 자격증명을 기반으로 `OAuthCredential`을 생성합니다.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Firebase로 사용자를 로그인시킵니다. 앞서 생성한 Nonce가
    // `appleCredential.identityToken` 안의 Nonce와 일치하지 않으면 로그인이 실패합니다.
    await _firebaseAuth.signInWithCredential(oauthCredential);
  }

}
