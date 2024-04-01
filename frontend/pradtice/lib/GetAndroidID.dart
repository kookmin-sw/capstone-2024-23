import 'package:android_id/android_id.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class GetID {
  static const _androidIdPlugin = AndroidId();
  String id = '';

  GetID() {
    setID().then((_) {
      // GET 방식으로 서버에 전송
      SendToServer();
      print(id);
    });
  }

  Future<void> setID() async {
    String AndroidID;
    try {
      AndroidID = await _androidIdPlugin.getId() ?? 'Unknown ID';
    } on PlatformException {
      AndroidID = 'Failed to get Android ID.';
    }
    id = AndroidID;
  }

  Future<void> SendToServer() async {
    // URL에 파라미터를 포함하여 GET 요청을 보냅니다.
    var url = Uri.parse('http://15.164.219.111:8080/checkMember?uuid=$id');

    try {
      var response = await http.get(url);
      if (response.statusCode != 200) {
        print("서버에 전송 실패");
      } else {
        print("서버에 전송 완료");
        print(jsonDecode(response.body));
      }
    } catch (e) {
      print("에러 코드 : $e");
    }
  }
}
