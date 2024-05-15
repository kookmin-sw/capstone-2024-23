//메인.dart에도 밑의 2개 패키지 설치 요함
import 'package:http/http.dart' as http; // http 사용 패키지
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pradtice/location_permission.dart'; //json 변환 패키지
import 'dart:async';
import 'GetAndroidID.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'STT.dart';
import 'package:flutter_compass/flutter_compass.dart';

String Adress = '국민대';
String nodeLat = '37.470629';
String nodeLon = '127.126781';
int IdxNode = 0;
class NaviTap extends StatefulWidget {
  const NaviTap({super.key});

  @override
  State<NaviTap> createState() => _NaviTapState();
}

class _NaviTapState extends State<NaviTap> {
  Sever sever = Sever();
  Timer? timer;
  Compass compass = Compass();
  @override
  void initState() {
    super.initState();
    sever.onLocationChanged = () {
      setState(() {}); // 위치 정보가 변경될 때마다 UI 업데이트
    };
  }

  @override
  void dispose() {
    timer?.cancel(); // 위젯이 사라질 때 타이머를 취소
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('목적지 : ${Adress}')),
      body: Container(
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
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SttAdress()),
                      );
                      print(Adress);
                    });
                  }, child: Text('목적지 설정'))
                  ,ElevatedButton(onPressed: () {
                    sever.start_navi();
                    setState(() {
                    });
                  }, child: Text('Start-navi')),
                  ElevatedButton(onPressed: () {
                    timer?.cancel(); // 실행 중인 타이머가 있다면 취소
                    // 새로운 타이머 생성 및 시작
                    timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
                      sever.current_location();
                      setState(() {
                      });
                    });
                  }, child: Text('Current-location')),
                  ElevatedButton(onPressed: () {
                    timer?.cancel(); // 타이머 취소
                    sever.cancel_navi();
                  }, child: Text('Cancel-navi')),
                  Text('${sever.distance}M'),
                  Text('IdxNode : $IdxNode'),
                  Text(sever.description),
                  ElevatedButton(onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => testmap()),
                    );
                  }, child: Text('Map')),
                  ElevatedButton(onPressed: (){
                    compass.printdire();
                  }, child: Text('꾹'))
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

  var description = '현재 경로';
  var distance = '0';
  var uuid = '';

  GetID getID = GetID();

  // 콜백 함수를 위한 정의
  Function? onLocationChanged;

  setid() {
    uuid = getID.id;
    print('uuid = $uuid');
  }

  setAdress(String adress){
    Adress = adress;
  }

  Future<void> start_navi() async {
    setid();
    await updateLocation();
    sendStartNaviRequest();
  }

  Future<void> current_location() async {
    await updateLocation();
    sendCurrentLocationRequest();
  }

  Future<void> cancel_navi() async {
    sendCancelNaviRequest();
  }

  Future<void> updateLocation() async {
    await myLocation.getMyCurrentLocation();
    Lat = myLocation.latitude;
    Lon = myLocation.longitude;
    print("위도 : $Lat 경도 : $Lon");
  }

  // 서버에 시작 위치 전송
  Future<void> sendStartNaviRequest() async {
    var url = Uri.parse('http://15.164.219.111:8080/start-navi?startLat=$Lat&startLon=$Lon&endAddress=$Adress&uuid=$uuid');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        print("전송 완료");
        var responseBody = utf8.decode(response.bodyBytes);
        var jsonResponse = jsonDecode(responseBody);
        print(jsonResponse);
        IdxNode = jsonResponse['pointIndex'];
        description = jsonResponse['description'];
      } else {
        print("서버 전송 실패");
      }
    } catch (e) {
      print("에러코드 : $e");
    }
  }

  // 서버에 현재 위치 전송
  Future<void> sendCurrentLocationRequest() async {
    var url = Uri.parse('http://15.164.219.111:8080/current-location?curLat=$Lat&curLon=$Lon&uuid=$uuid&pointIndex=$IdxNode');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        print("전송 완료");
        var responseBody = utf8.decode(response.bodyBytes);
        var jsonResponse = jsonDecode(responseBody);
        print(jsonResponse);
        IdxNode = jsonResponse['pointIndex'];
        description = jsonResponse['description'];
        distance = jsonResponse['distance'];
        nodeLat = jsonResponse['lat'];
        nodeLon = jsonResponse['lon'];
      } else {
        print("서버에 전송 실패");
      }
    } catch (e) {
      print("에러코드 : $e");
    }
  }

  // 서버에 내비게이션 취소 요청 전송
  Future<void> sendCancelNaviRequest() async {
    var url = Uri.parse('http://15.164.219.111:8080/cancel-navi?uuid=$uuid');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        print("전송 완료");
        print(response.body);
      } else {
        print("서버 전송 실패");
      }
    } catch (e) {
      print("에러코드 : $e");
    }
  }

}

class testmap extends StatefulWidget {
  @override
  _testmapState createState() => _testmapState();
}

class _testmapState extends State<testmap> {
  GoogleMapController? mapController; // GoogleMap 컨트롤러
  Set<Marker> markers = {}; // 마커를 관리할 Set
  // 임시로 초기 위치를 설정합니다. 나중에 실제 데이터로 업데이트해야 합니다.

  final LatLng _center = const LatLng(37.5665, 126.9780);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _updateMarkers(); // 맵이 생성될 때 마커 업데이트
  }

  // 마커를 업데이트하는 함수
  void _updateMarkers() async {

    double lat = double.parse(nodeLat);
    double lon = double.parse(nodeLon); // 예시 경도

    // 마커 Set을 업데이트합니다.
    setState(() {
      markers.clear(); // 기존 마커를 지우고 새로운 위치에 마커를 추가합니다.
      markers.add(
        Marker(
          markerId: MarkerId('$IdxNode'),
          position: LatLng(lat, lon),

        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps Sample App'),
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: markers,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _updateMarkers, // 버튼을 누를 때마다 마커 업데이트
        label: Text('위치 업데이트'),
        icon: Icon(Icons.location_on),
      ),
    );
  }
}

class Compass {
  String direct = '??';

  Compass(){
    initState();
  }
  void printdire() {
    print(direct);
}
  void initState(){
    FlutterCompass.events!.listen((CompassEvent event) {
      direct = getDirect(event.heading);
    });
  }



String getDirect(double? varangle){
    if(varangle == null){
      return '??';
    }
    double angle = varangle + 180;
    if (angle >=337.5 || angle < 22.5){
      return '남';
    } else if (angle >= 22.5 && angle < 67.5){
      return '남서';
    } else if (angle >= 67.5 && angle < 112.5){
      return '서';
    } else if (angle >= 112.5 && angle < 157.5){
      return '북서';
    } else if (angle >= 157.5 && angle < 202.5){
      return '북';
    } else if (angle >= 202.5 && angle < 247.5){
      return '북동';
    } else if (angle >= 247.5 && angle < 292.5){
      return '동';
    } else if (angle >= 292.5 && angle < 337.5){
      return '남동';
    } else {
      return '??';
    }
  }

}











// class NaviTap extends StatefulWidget {
//   const NaviTap({super.key});
//
//   @override
//   State<NaviTap> createState() => _NaviTapState();
// }
//
// class _NaviTapState extends State<NaviTap> {
//   Sever sever = Sever();
//   Timer? timer;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('내비게이션'),),
//       body:Container(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Wrap(
//                 spacing: 70.0, // 가로 간격
//                 runSpacing: 50.0, // 세로 간격
//                 alignment: WrapAlignment.center,
//                 children: <Widget>[
//                   ElevatedButton(onPressed: (){
//                     setState(() {
//                       sever.start_navi();
//                       setState(() {
//                       });
//                     });
//                   }, child: Text('Start-navi')),
//                   ElevatedButton(onPressed: (){
//                     timer?.cancel(); // 실행 중인 타이머가 있다면 취소
//                     // 새로운 타이머 생성 및 시작
//                     timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
//                       setState(() {
//                         sever.current_location();
//                       });
//                     });
//                   }, child: Text('Current-location')),
//                   ElevatedButton(onPressed: (){
//                     timer?.cancel(); // 타이머 취소
//                     setState(() {
//                       sever.cancel_navi();
//                     });
//                   }, child: Text('Cancel-navi')),
//                   Text(sever.distance+'M'),
//                   Text('IdxNode : ${sever.IdxNode}'),
//                   Text(sever.description),
//                   ElevatedButton(onPressed: (){
//                     Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => testmap()),
//                     );
//                   }, child: Text('Map'))
//                 ]
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
// class Sever {
//
//   MyLocation myLocation = MyLocation();
//
//   double Lat = 0;
//   double Lon = 0;
//   String nodeLat ='37.470629';
//   String nodeLon = '127.126781';
//   String Adress = '국민대';
//   int IdxNode = 0;
//   var description = '현재 경로';
//   var distance = '0';
//   var uuid = '';
//
//   GetID getID = GetID();
//
//   setid(){
//     uuid = getID.id;
//     print('uuid = $uuid');
//   }
//
//
//   Future<void> start_navi() async {
//     setid();
//     myLocation.getMyCurrentLocation();
//     Lat = myLocation.latitude;
//     Lon = myLocation.longitude;
//     var url = Uri.parse('http://15.164.219.111:8080/start-navi?startLat=$Lat&startLon=$Lon&endAddress=$Adress&uuid=$uuid');
//     try{
//       var response = await http.get(url);
//       if (response.statusCode != 200) {
//         print("서버 전송 실패");
//       } else {
//         print("전송 완료");
//         var responseBody = utf8.decode(response.bodyBytes);
//         var jsonResponse = jsonDecode(responseBody);
//         print(jsonResponse);
//         IdxNode = jsonResponse['pointIndex'];
//         description = jsonResponse['description'];
//
//       }
//     }catch(e){
//       print("에러코드 : $e");
//     }
//   }
//
//   Future<void> current_location() async {
//     myLocation.getMyCurrentLocation();
//     Lat = myLocation.latitude;
//     Lon = myLocation.longitude;
//     print("위도 : $Lat 경도 : $Lon");
//     var url = Uri.parse('http://15.164.219.111:8080/current-location?curLat=$Lat&curLon=$Lon&uuid=$uuid&pointIndex=$IdxNode');
//     try{
//       var response = await http.get(url);
//       if (response.statusCode != 200) {
//         // 요청이 성공하면 응답을 출력합니다.
//         print("서버에 전송 실패");
//       } else {
//         print("전송 완료");
//         var responseBody = utf8.decode(response.bodyBytes);
//         var jsonResponse = jsonDecode(responseBody);
//         print(jsonResponse);
//         IdxNode = jsonResponse['pointIndex'];
//         description = jsonResponse['description'];
//         distance = jsonResponse['distance'];
//         nodeLat = jsonResponse['lat'];
//         nodeLon = jsonResponse['lon'];
//       }
//     }catch(e){
//       print("에러코드 : $e");
//     }
//   }
//
//   Future<void> cancel_navi() async {
//     try{
//       var url = Uri.parse('http://15.164.219.111:8080/cancel-navi?uuid=$uuid');
//       var response = await http.get(url);
//       if ( response.statusCode != 200){
//         print("서버 전송 실패");
//       } else {
//         print("전송 완료");
//         print(response.body);
//       }
//     }catch(e){
//       print("에러코드 : $e");
//     }
//   }
//
// }

// class testmap extends StatefulWidget {
//   const testmap({super.key});
//
//   @override
//   State<testmap> createState() => _testmapState();
// }
//
// class _testmapState extends State<testmap> {
//
//   Completer<GoogleMapController> _controller = Completer();
//   Set<Marker> _markers = {};
//   Sever sever = Sever();
//
//   @override
//   void initState() {
//     super.initState();
//     loca();
//   }
//
//   Future<void> loca() async {
//     setState(() {
//       _centerloca(LatLng(sever.Lat, sever.Lon));
//       nodeloca(LatLng(double.parse(sever.nodeLat),double.parse(sever.nodeLon)));
//     });
//   }
//   void _centerloca(LatLng posi){
//     setState(() {
//       _center = CameraPosition(
//           target: posi,
//           zoom: 14
//       );
//     });
//   }
//   void nodeloca(LatLng posi){
//     setState(() {
//       nodeloc = CameraPosition(
//           target:posi,
//           zoom: 14
//       );
//     });
//   }
//   CameraPosition _center = CameraPosition(
//       target:LatLng(37.4645493,127.80803),
//       zoom: 14
//   );
//   CameraPosition nodeloc = CameraPosition(
//       target: LatLng(37.5665, 126.9780),
//       zoom: 14
//   );
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(myLocationEnabled: true,
//           initialCameraPosition: _center,
//           markers: {
//             Marker(
//                 markerId: MarkerId('IdxNode : ${sever.IdxNode}'),
//                 position: LatLng(double.parse(sever.nodeLat),double.parse(sever.nodeLon))
//             )
//           }
//       ),
//     );
//   }
// }
