//메인.dart에도 밑의 2개 패키지 설치 요함
import 'package:http/http.dart' as http; // http 사용 패키지
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pradtice/location_permission.dart'; //json 변환 패키지
import 'GetAndroidID.dart';
import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class NaviTap extends StatefulWidget {
  const NaviTap({super.key});

  @override
  State<NaviTap> createState() => _NaviTapState();
}

class _NaviTapState extends State<NaviTap> {
  Sever sever = Sever();
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('내비게이션'),),
      body:Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Wrap(
                spacing: 70.0, // 가로 간격
                runSpacing: 50.0, // 세로 간격
                alignment: WrapAlignment.center,
                children: <Widget>[
                  ElevatedButton(onPressed: (){
                    sever.start_navi();
                  }, child: Text('Start-navi')),
                  ElevatedButton(onPressed: (){
                    timer?.cancel(); // 실행 중인 타이머가 있다면 취소
                    // 새로운 타이머 생성 및 시작
                    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
                      sever.current_location();
                    });
                  }, child: Text('Current-location')),
                  ElevatedButton(onPressed: (){
                    timer?.cancel(); // 타이머 취소
                    sever.cancel_navi();
                  }, child: Text('Cancel-navi')),
                  Text(sever.distance+'M'),
                  Text('IdxNode : ${sever.IdxNode}'),
                  Text(sever.description),
                  ElevatedButton(onPressed: (){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => testmap()),
                    );
                  }, child: Text('Map'))
                ]
            )
          ],
        ),
      ),
    );
  }
}



class Sever {

  MyLocation myLocation = MyLocation();

  double Lat = 0;
  double Lon = 0;
  String nodeLat ='37.470629';
  String nodeLon = '127.126781';
  String Adress = '국민대';
  int IdxNode = 0;
  var description = '현재 경로';
  var distance = '0';
  var uuid = '';


  Future<void> start_navi() async {
    myLocation.getMyCurrentLocation();
    Lat = myLocation.latitude;
    Lon = myLocation.longitude;
    var url = Uri.parse('http://15.164.219.111:8080/start-navi?startLat=$Lat&startLon=$Lon&endAddress=$Adress&uuid=$uuid');
    try{
      var response = await http.get(url);
      if (response.statusCode != 200) {
        print("서버 전송 실패");
      } else {
        print("전송 완료");
        var responseBody = utf8.decode(response.bodyBytes);
        var jsonResponse = jsonDecode(responseBody);
        print(jsonResponse);
        IdxNode = jsonResponse['pointIndex'];
        description = jsonResponse['description'];
      }
    }catch(e){
      print("에러코드 : $e");
    }
  }

  Future<void> current_location() async {
    myLocation.getMyCurrentLocation();
    Lat = myLocation.latitude;
    Lon = myLocation.longitude;
    print("위도 : $Lat 경도 : $Lon");
    var url = Uri.parse('http://15.164.219.111:8080/current-location?curLat=$Lat&curLon=$Lon&uuid=$uuid&pointIndex=$IdxNode');
    try{
      var response = await http.get(url);
      if (response.statusCode != 200) {
        // 요청이 성공하면 응답을 출력합니다.
        print("서버에 전송 실패");
      } else {
        print("전송 완료");
        var responseBody = utf8.decode(response.bodyBytes);
        var jsonResponse = jsonDecode(responseBody);
        print(jsonResponse);
        IdxNode = jsonResponse['pointIndex'];
        description = jsonResponse['description'];
        distance = jsonResponse['distance'];
        nodeLat = jsonResponse['lat'];
        nodeLon = jsonResponse['lon'];
      }
    }catch(e){
      print("에러코드 : $e");
    }
  }

  Future<void> cancel_navi() async {
    try{
      var url = Uri.parse('http://15.164.219.111:8080/cancel-navi?uuid=$uuid');
      var response = await http.get(url);
      if ( response.statusCode != 200){
        print("서버 전송 실패");
      } else {
        print("전송 완료");
        print(response.body);
      }
    }catch(e){
      print("에러코드 : $e");
    }
  }

  getID(){
    GetID getid = GetID();
    uuid = getid.id;
    print('uuid : '+uuid);
  }

}

class testmap extends StatefulWidget {
  const testmap({super.key});

  @override
  State<testmap> createState() => _testmapState();
}

class _testmapState extends State<testmap> {

  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Sever sever = Sever();

  @override
  void initState() {
    super.initState();
    loca();
  }

  Future<void> loca() async {
    setState(() {
      _centerloca(LatLng(sever.Lat, sever.Lon));
      nodeloca(LatLng(double.parse(sever.nodeLat),double.parse(sever.nodeLon)));
    });
  }
  void _centerloca(LatLng posi){
    setState(() {
      _center = CameraPosition(
        target: posi,
        zoom: 14
      );
    });
  }
  void nodeloca(LatLng posi){
    setState(() {
      nodeloc = CameraPosition(
        target:posi,
        zoom: 14
      );
    });
  }
  CameraPosition _center = CameraPosition(
      target:LatLng(37.4645493,127.80803),
      zoom: 14
  );
  CameraPosition nodeloc = CameraPosition(
    target: LatLng(37.5665, 126.9780),
    zoom: 14
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(myLocationEnabled: true,
        initialCameraPosition: _center,
        markers: {
          Marker(
            markerId: MarkerId('IdxNode : ${sever.IdxNode}'),
            position: LatLng(double.parse(sever.nodeLat),double.parse(sever.nodeLon))
          )
        }
      ),
    );
  }
}
