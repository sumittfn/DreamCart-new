// import 'dart:async';
// import 'dart:math';
//
// import 'package:Dreamcart/src/elements/CircularLoadingWidget.dart';
// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_recognition_error.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   bool _hasSpeech = false;
//   double level = 0.0;
//   double minSoundLevel = 50000;
//   double maxSoundLevel = -50000;
//   String lastWords = '';
//   String lastError = '';
//   String lastStatus = '';
//   String _currentLocaleId = '';
//   int resultListened = 0;
//   List<LocaleName> _localeNames = [];
//   final SpeechToText speech = SpeechToText();
//
//   @override
//   void initState() {
//     initSpeechState();
//     super.initState();
//   }
//
//   Future<void> initSpeechState() async {
//     var hasSpeech = await speech.initialize(
//         onError: errorListener,
//         onStatus: statusListener,
//         debugLogging: true,);
//     if (hasSpeech) {
//       _localeNames = await speech.locales();
//
//       var systemLocale = await speech.systemLocale();
//       _currentLocaleId = systemLocale.localeId;
//     }
//
//     if (!mounted) return;
//
//     setState(() {
//       _hasSpeech = hasSpeech;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           title: Container(
//             padding: EdgeInsets.all(12),
//             decoration: BoxDecoration(
//                 color: Colors.transparent,
//                 border: Border.all(
//                   color: Theme.of(context).focusColor.withOpacity(0.2),
//                 ),
//                 borderRadius: BorderRadius.circular(4)),
//             child: Row(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.only(right: 12, left: 0),
//                   child: Icon(Icons.search,
//                       color: Theme.of(context).accentColor),
//                 ),
//                 Expanded(
//                   child: Text(
//                     speech.isListening
//                         ? 'Listening...'
//                         : lastWords ,
//                     maxLines: 1,
//                     style: Theme.of(context)
//                         .textTheme
//                         .caption
//                         .merge(TextStyle(fontSize: 14)),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       right: 5, left: 5, top: 3, bottom: 3),
//                   child: InkWell(
//                       onTap:() {
//                         setState(() {
//
//                         });
//                         // _hasSpeech ? null : initSpeechState;
//                         speech.isListening
//                             ? startListening
//                             : stopListening;
//                       },
//                       child: Icon(Icons.mic,
//                           color: Theme.of(context).accentColor)),
//                 ),
//               ],
//             ),
//           ),
//           // actions: [
//           //
//           //
//           // ],
//         ),
//         body: CircularLoadingWidget(height:588 ,),
//       ),
//     );
//   }
//
//   void startListening() {
//     lastWords = '';
//     lastError = '';
//     speech.listen(
//         onResult: resultListener,
//         listenFor: Duration(seconds: 5),
//         pauseFor: Duration(seconds: 5),
//         partialResults: false,
//         localeId: _currentLocaleId,
//         onSoundLevelChange: soundLevelListener,
//         cancelOnError: true,
//         listenMode: ListenMode.confirmation);
//     setState(() {});
//   }
//
//   void stopListening() {
//     speech.stop();
//     setState(() {
//       level = 0.0;
//     });
//   }
//
//   void cancelListening() {
//     speech.cancel();
//     setState(() {
//       level = 0.0;
//     });
//   }
//
//   void resultListener(SpeechRecognitionResult result) {
//     ++resultListened;
//     print('Result listener $resultListened');
//     setState(() {
//       lastWords = '${result.recognizedWords} - ${result.finalResult}';
//     });
//   }
//
//   void soundLevelListener(double level) {
//     minSoundLevel = min(minSoundLevel, level);
//     maxSoundLevel = max(maxSoundLevel, level);
//     // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
//     setState(() {
//       this.level = level;
//     });
//   }
//
//   void errorListener(SpeechRecognitionError error) {
//     // print("Received error status: $error, listening: ${speech.isListening}");
//     setState(() {
//       lastError = '${error.errorMsg} - ${error.permanent}';
//     });
//   }
//
//   void statusListener(String status) {
//     // print(
//     // 'Received listener status: $status, listening: ${speech.isListening}');
//     setState(() {
//       lastStatus = '$status';
//     });
//   }
//
//   void _switchLang(selectedVal) {
//     setState(() {
//       _currentLocaleId = selectedVal;
//     });
//     print(selectedVal);
//   }
// }