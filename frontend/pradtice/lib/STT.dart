import 'package:flutter/material.dart';
import 'ObjectRecognitionMode.dart';
import 'sever.dart'; // 서버 연동 파일 import
import 'dart:async'; //탭 시간차 패키지
import 'package:speech_to_text/speech_recognition_result.dart'; // 음성 인식 패키지
import 'package:speech_to_text/speech_to_text.dart'; // stt -> tts 패키지

// import 'Tmap.dart';
import 'GoogleMap.dart';
import 'TextToSpeech.dart';

class SttTab extends StatefulWidget {
  const SttTab({Key? key}) : super(key: key);

  @override
  State<SttTab> createState() => _SttTabState();
}

class _SttTabState extends State<SttTab> {
  SpeechToText _speechToText = SpeechToText();
  bool speechEnable = false;
  String _lastWords = '음성인식';
  Sever sever = Sever();
  bool _isListening = false;
  TTS tts = TTS(message: '화면을 누르면서 기능을 말씀해주세요.');

  @override
  void initState() {
    super.initState();
    _initSpeech();
    tts.speak();
  }

  void _initSpeech() async {
    speechEnable = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _isListening = true;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
    tts.setMessage('  $_lastWords  가 맞으면 한번, 틀리면 두번 터치를 해주세요.');
    tts.speak();
    showDialog(context: context,
        builder: (context) => GestureDetector(
          onTap: (){
            Navigator.pop(context);
            Navigator.pop(context);
            if(_lastWords=='보행 모드'){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ObjectReco(tabnum: 0)),);
            }
            else if (_lastWords == '경로 탐색 모드') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NaviTap()));
            } else if (_lastWords == '테스트 모드'){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SttAdress()));
            }
          },
          onDoubleTap: (){
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => SttTab()));
          },
        ));
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _startListening(),
      onTapUp: (_) => _stopListening(),
      child: Dialog(
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
                        Text('화면을 누르면서 음성인식 시작',style: TextStyle(fontSize: 20),),
                        Container(height: 10,),
                        Text(_lastWords,style: TextStyle(fontSize: 25),),
                        Container(height: 50,),
                        Icon(
                          _isListening ? Icons.mic : Icons.mic_off,
                          size: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



}

// class _SttTabState extends State<SttTab> {
//
//   SpeechToText _speechToText = SpeechToText();
//   bool speechEnable = false;
//   String _lastWords = '인식된 단어';
//
//   @override
//   void initState() {
//     super.initState();
//     _initSpeech();
//   }
//
//   void _initSpeech() async {
//     speechEnable = await _speechToText.initialize();
//     setState(() {});
//   }
//
//   void _startListening() async {
//     await _speechToText.listen(onResult: _onSpeechResult);
//     setState(() {});
//   }
//
//   void _stopListening() async {
//     await _speechToText.stop();
//     setState(() {});
//   }
//
//   void _onSpeechResult(SpeechRecognitionResult result) {
//     setState(() {
//       _lastWords = result.recognizedWords;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: Scaffold(
//         appBar: AppBar(title: Text('음성인식')),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               child: Center(
//                 child: Container(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('버튼을 눌러 음성인식 시작',style: TextStyle(fontSize: 20),),
//                       Container(height: 10,),
//                       Text(_lastWords,style: TextStyle(fontSize: 25),),
//                       Container(height: 50,),
//                       IconButton(onPressed: (){
//                         if(_speechToText.isListening){
//                           _stopListening();
//                         }else{
//                           _startListening();
//                         }
//                       }, icon: Icon(Icons.mic,size:50),style: IconButton.styleFrom(
//                           fixedSize: Size(200,70)
//                       ),),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             TextButton(onPressed: (){
//               // 이 부분은 실제 위젯과 경로에 맞게 수정해야 합니다.
//               if(_lastWords=='보행 모드'){
//                 Navigator.pop(context);
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => ObjectReco()),);
//               }
//               else if (_lastWords == '경로 탐색 모드') {
//                 Navigator.pop(context);
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => NaviTap()));
//               } else if (_lastWords == '테스트 모드'){
//                 Navigator.pop(context);
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => SttAdress()));
//               } else{
//                 Navigator.pop(context);
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => SttAdress()));
//               }
//             }, child: Text('확인',style: TextStyle(fontSize: 30),),style: TextButton.styleFrom(
//                 fixedSize: Size(200,70)
//             ),)
//           ],
//         ),
//       ),
//     );
//   }
// }

class SttAdress extends StatefulWidget {
  const SttAdress({super.key});

  @override
  State<SttAdress> createState() => _SttAdressState();
}

class _SttAdressState extends State<SttAdress> {
  SpeechToText _speechToText = SpeechToText();
  bool speechEnable = false;
  String _lastWords = '국민대';
  Sever sever = Sever();
  bool _isListening = false;
  TTS tts = TTS(message: '  화면을 누르면서 목적지를 말씀해주세요.');

  @override
  void initState() {
    super.initState();
    _initSpeech();
    tts.speak();
  }

  void _initSpeech() async {
    speechEnable = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _isListening = true;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
    tts.setMessage('  $_lastWords  가 맞으면 한번, 틀리면 두번 터치를 해주세요.');
    tts.speak();
    showDialog(context: context,
        builder: (context) => GestureDetector(
          onTap: (){
            sever.setAdress(_lastWords);
            Navigator.pop(context);
            Navigator.pop(context);
            sever.start_navi();
            Navigator.push(context, MaterialPageRoute(builder: (context) => ObjectReco(tabnum: 1,)));
          },
          onDoubleTap: (){
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => SttAdress()));
          },
        ));
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _startListening(),
      onTapUp: (_) => _stopListening(),
      child: Dialog(
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
                        Text('화면을 누르면서 음성인식 시작',style: TextStyle(fontSize: 20),),
                        Container(height: 10,),
                        Text(_lastWords,style: TextStyle(fontSize: 25),),
                        Container(height: 50,),
                        Icon(
                          _isListening ? Icons.mic : Icons.mic_off,
                          size: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// class _SttAdressState extends State<SttAdress> {
//
//   SpeechToText _speechToText = SpeechToText();
//   bool speechEnable = false;
//   String _lastWords = '국민대';
//   Sever sever = Sever();
//   @override
//   void initState() {
//     super.initState();
//     _initSpeech();
//   }
//
//   void _initSpeech() async {
//     speechEnable = await _speechToText.initialize();
//     setState(() {});
//   }
//
//   void _startListening() async {
//     await _speechToText.listen(onResult: _onSpeechResult);
//     setState(() {});
//   }
//
//   void _stopListening() async {
//     await _speechToText.stop();
//     setState(() {});
//   }
//
//   void _onSpeechResult(SpeechRecognitionResult result) {
//     setState(() {
//       _lastWords = result.recognizedWords;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: Scaffold(
//         appBar: AppBar(title: Text('음성인식')),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               child: Center(
//                 child: Container(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('버튼을 눌러 음성인식 시작',style: TextStyle(fontSize: 20),),
//                       Container(height: 10,),
//                       Text(_lastWords,style: TextStyle(fontSize: 25),),
//                       Container(height: 50,),
//                       IconButton(onPressed: (){
//                         if(_speechToText.isListening){
//                           _stopListening();
//                         }else{
//                           _startListening();
//                         }
//                       }, icon: Icon(Icons.mic,size:50),style: IconButton.styleFrom(
//                           fixedSize: Size(200,70)
//                       ),),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             TextButton(onPressed: (){
//               sever.setAdress(_lastWords);
//               Navigator.pop(context);
//               sever.start_navi();
//               Navigator.push(context, MaterialPageRoute(builder: (context) => NaviTap()));
//             }, child: Text('확인',style: TextStyle(fontSize: 30),),style: TextButton.styleFrom(
//                 fixedSize: Size(200,70)
//             ),)
//           ],
//         ),
//       ),
//     );
//   }
// }
