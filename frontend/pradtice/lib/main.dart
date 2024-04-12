import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart'; //권한 설정
import 'package:geolocator/geolocator.dart'; // 위치 패키지
import 'ObjectRecognitionMode.dart'; // 새로 만든 파일 import
import 'location_permission.dart'; // 위치 파일 import
import 'sever.dart'; // 서버 연동 파일 import
import 'package:http/http.dart' as http; // http 사용 패키지
import 'dart:convert'; //json 변환 패키지
import 'dart:async'; //탭 시간차 패키지
import 'package:speech_to_text/speech_recognition_result.dart'; // 음성 인식 패키지
import 'package:speech_to_text/speech_to_text.dart'; // stt -> tts 패키지

// import 'Tmap.dart';
import 'GoogleMap.dart';
import 'TextToSpeech.dart';
import 'GetAndroidID.dart';

void main() {
  runApp(
      MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home : MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //sever.dart 에서의 Sever 클래스 상속
  Sever sever = Sever();
  TTS tts = TTS(message: '기본');

  // GoogleMap.dart 에서의 GoogleMap 클래스 상속
  MyGoogleMap mygoogleMap = MyGoogleMap();

  //앱 실행시 백그라운드 실행

  @override
  void initState() {
    super.initState();
    sever.getData();
    tts.setMessage('화면을 탭하세요');
    tts.speak();
    GetID();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   // _tapCount 변수를 사용하지 않고 바로 Navigator.push를 사용하여
      //   // 싱글 탭 이벤트 처리 시 SttTab() 호출
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => SttTab()),
      //   );
      // },
  child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("메인화면"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0), // 밑줄의 높이 설정
          child: Container(
            color: Colors.black, // 밑줄의 색상 설정
            height: 1.0, // 밑줄의 두께 설정
          ),
        ),
      ),

      body:Container(
          color: Colors.blueGrey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 150.0), // 마이크 아이콘과 모드 버튼들 사이의 간격을 조정
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SttTab()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), // 버튼을 원형으로 만듦
                    padding: EdgeInsets.all(20), // 원형 버튼 내부의 아이콘과의 padding
                  ),
                  child: Icon(Icons.mic, size: 40.0,color: Colors.blueGrey,), // 아이콘 크기를 조정하여 화면 비중 감소
                ),
              ),
              Wrap( // ButtonBar 대신 Wrap 위젯을 사용하여 모드 버튼들을 더 유연하게 배치
                spacing: 70.0, // 가로 간격
                runSpacing: 50.0, // 세로 간격
                alignment: WrapAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ObjectRecognitionMode()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 50),
                      // backgroundColor: Colors.,
                      foregroundColor: Colors.blueGrey,

                    ),
                    child: Text('보행 모드', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyGoogleMap()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 50),
                      // backgroundColor: Colors.,
                      foregroundColor: Colors.blueGrey,

                    ),
                    child: Text('경로 탐색 모드', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ConvenienceMode()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 50),
                      // backgroundColor: Colors.,
                      foregroundColor: Colors.blueGrey,

                    ),
                    child: Text('즐겨찾기 모드', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ConvenienceMode()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 50),
                      // backgroundColor: Colors.,
                      foregroundColor: Colors.blueGrey,

                    ),
                    child: Text('편의 모드', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                  ),
                ],
              )
            ],
          ),
        )



  ),
    );
  }
}

class ConvenienceMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('편의 기능 모드'),
      ),
      body: Center(
        child: Text('여기에 편의 기능 모드의 기능을 구현해주세요.'),
      ),
    );
  }
}


class SttTab extends StatefulWidget {
  const SttTab({Key? key}) : super(key: key);

  @override
  State<SttTab> createState() => _SttTabState();
}

class _SttTabState extends State<SttTab> {
  SpeechToText _speechToText = SpeechToText();
  bool speechEnable = false;
  String _lastWords = '인식된 단어';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    speechEnable = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }



  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Scaffold(
        appBar: AppBar(title: Text('음성인식')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('버튼을 눌러 음성인식 시작',style: TextStyle(fontSize: 20),),
                      Container(height: 10,),
                      Text(_lastWords,style: TextStyle(fontSize: 25),),
                      Container(height: 50,),
                      IconButton(onPressed: (){
                        if(_speechToText.isListening){
                          _stopListening();
                        }else{
                          _startListening();
                        }
                      }, icon: Icon(Icons.mic,size:50),style: IconButton.styleFrom(
                        fixedSize: Size(200,70)
                      ),),
                    ],

                  ),
                ),
              ),
            ),
            TextButton(onPressed: (){
              if(_lastWords=='보행 모드'){
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ObjectRecognitionMode()),
                );
              }
              else if (_lastWords == '경로 탐색 모드') {
              Navigator.pop(context);
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyGoogleMap())
              );
              } else if(_lastWords == '즐겨찾기 모드') {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConvenienceMode()),
                );
              }
              else if (_lastWords == '편의 모드') {
              Navigator.pop(context);
              Navigator.push(
              context,
                MaterialPageRoute(builder: (context) => ConvenienceMode()),
              );
              } else{
                Navigator.pop(context);
              }
            }, child: Text('확인',style: TextStyle(fontSize: 30),),style: TextButton.styleFrom(
                fixedSize: Size(200,70)
            ),)
          ],
        ),
      ),
    );
  }
}
