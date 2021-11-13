// import 'package:Dreamcart/generated/i18n.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:speech_recognition/speech_recognition.dart';
//
// import 'elements/CircularLoadingWidget.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   final GlobalKey _scaffoldState = GlobalKey();
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.pink,
//       ),
//       home: Scaffold(
//         key: _scaffoldState,
//         appBar: AppBar(
//           title: Text("Voice Recognizer"),
//         ),
//         body: Container(
//           child: Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 RaisedButton(
//                   onPressed: () {
//                     Navigator.push(_scaffoldState.currentContext,
//                         MaterialPageRoute(builder: (context) {
//                       return SpeachRecognize();
//                     }));
//                   },
//                   child: Text(
//                     "Simple Speech",
//                     style: TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                   // color: Colors.pink,
//                 ),
//                 RaisedButton(
//                   onPressed: () {
//                     Navigator.push(_scaffoldState.currentContext,
//                         MaterialPageRoute(builder: (context) {
//                       return ListSearch();
//                     }));
//                   },
//                   child: Text(
//                     "Voice Search",
//                     style: TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                   color: Colors.pink,
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class SpeachRecognize extends StatefulWidget {
//   @override
//   _SpeachRecognizeState createState() => _SpeachRecognizeState();
// }
//
// class _SpeachRecognizeState extends State {
//   SpeechRecognition _speech;
//   bool _speechRecognitionAvailable = false;
//   bool _isListening = false;
//
//   String transcription = '';
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     activateSpeechRecognizer();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       // theme: ThemeData(primaryColor: Colors.pink),
//       home: Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             title: Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                   color: Colors.transparent,
//                   border: Border.all(
//                     color: Theme.of(context).focusColor.withOpacity(0.2),
//                   ),
//                   borderRadius: BorderRadius.circular(4)),
//               child: Row(
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(right: 12, left: 0),
//                     child: Icon(Icons.search,
//                         color: Theme.of(context).accentColor),
//                   ),
//                   Expanded(
//                     child: Text(
//                       _isListening
//                           ? 'Listening...'
//                           : transcription ,
//                       maxLines: 1,
//                       style: Theme.of(context)
//                           .textTheme
//                           .caption
//                           .merge(TextStyle(fontSize: 14)),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (context) {
//                         return SpeachRecognize();
//                       }));
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(
//                           right: 5, left: 5, top: 3, bottom: 3),
//                       child: InkWell(
//                           onTap: _speechRecognitionAvailable && !_isListening
//                               ? () => start()
//                               : () => stop(),
//                           child: Icon(Icons.mic,
//                               color: Theme.of(context).accentColor)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // actions: [
//             //
//             //
//             // ],
//           ),
//           body: CircularLoadingWidget(height: 288)),
//     );
//   }
//
//   Widget _buildVoiceInput({String label, VoidCallback onPressed}) {
//     return Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Row(
//           children: [
//             FlatButton(
//               child: Text(
//                 label,
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//             IconButton(
//               icon: Icon(Icons.mic, color: Theme.of(context).accentColor),
//               onPressed: onPressed,
//             ),
//           ],
//         ));
//   }
//
//   void activateSpeechRecognizer() {
//     requestPermission();
//
//     _speech = new SpeechRecognition();
//     _speech.setAvailabilityHandler((result) {
//       setState(() {
//         _speechRecognitionAvailable = result;
//       });
//     });
//     _speech.setCurrentLocaleHandler(onCurrentLocale);
//     _speech.setRecognitionStartedHandler(onRecognitionStarted);
//     _speech.setRecognitionResultHandler(onRecognitionResult);
//     _speech.setRecognitionCompleteHandler(onRecognitionComplete);
//     _speech
//         .activate()
//         .then((res) => setState(() => _speechRecognitionAvailable = res));
//   }
//
//   void start() {
//     _speech.listen(locale: 'en_US').then((result) {
//       print('Started listening => result $result');
//     });
//   }
//
//   void cancel() {
//     _speech.cancel().then((result) {
//       setState(() {
//         _isListening = result;
//       });
//     });
//   }
//
//   void stop() {
//     _speech.stop().then((result) {
//       setState(() {
//         _isListening = result;
//       });
//     });
//   }
//
//   void onSpeechAvailability(bool result) =>
//       setState(() => _speechRecognitionAvailable = result);
//
//   void onCurrentLocale(String locale) =>
//       setState(() => print("current locale: $locale"));
//
//   void onRecognitionStarted() => setState(() => _isListening = true);
//
//   void onRecognitionResult(String text) {
//     setState(() {
//       transcription = text;
//
//       //stop(); //stop listening now
//     });
//   }
//
//   void onRecognitionComplete() => setState(() => _isListening = false);
//
//   void requestPermission() async {
//     PermissionStatus permission = await PermissionHandler()
//         .checkPermissionStatus(PermissionGroup.microphone);
//
//     if (permission != PermissionStatus.granted) {
//       await PermissionHandler()
//           .requestPermissions([PermissionGroup.microphone]);
//     }
//   }
// }
//
// // import 'package:flutter/material.dart';
// // // import 'package:permission_handler/permission_handler.dart';
// // // import 'package:speech_recognition/speech_recognition.dart';
//
// class ListSearch extends StatefulWidget {
//   @override
//   State createState() {
//     // TODO: implement createState
//     return ListSearchState();
//   }
// }
//
// class ListSearchState extends State {
//   List _listWidgets = List();
//   List _listSearchWidgets = List();
//   SpeechRecognition _speech;
//   bool _speechRecognitionAvailable = false;
//   bool _isListening = false;
//   bool _isSearch = false;
//
//   String transcription = '';
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _listWidgets.add("PavBhaji");
//     _listWidgets.add("Barfi");
//     _listWidgets.add("Dabeli");
//     _listWidgets.add("Vada Pav");
//     _listWidgets.add("Tea");
//     _listWidgets.add("Oil");
//     _listWidgets.add("AppBar");
//     _listWidgets.add("Scaffold");
//     _listWidgets.add("MaterialApp");
//
//     _listSearchWidgets.addAll(_listWidgets);
//     activateSpeechRecognizer();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return MaterialApp(
//       theme: ThemeData(primaryColor: Colors.pink),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Search By Voice'),
//           centerTitle: true,
//           actions: [
//             _buildVoiceInput(
//               onPressed: _speechRecognitionAvailable && !_isListening
//                   ? () => start()
//                   : () => stop(),
//               label: _isListening ? 'Listening...' : '',
//             ),
//           ],
//         ),
//         body: ListView.builder(
//             itemCount: _listSearchWidgets.length,
//             itemBuilder: (ctx, pos) {
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Card(
//                   child: ListTile(
//                     leading: Icon(
//                       Icons.description,
//                       color: Colors.pink,
//                     ),
//                     title: Text("${_listSearchWidgets[pos]}"),
//                   ),
//                 ),
//               );
//             }),
//       ),
//     );
//   }
//
//   Widget _buildVoiceInput({String label, VoidCallback onPressed}) {
//     return Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Row(
//           children: [
//             FlatButton(
//               child: Text(
//                 label,
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//             IconButton(
//               icon: Icon(Icons.mic),
//               onPressed: onPressed,
//             ),
//             (_isSearch)
//                 ? IconButton(
//                     icon: Icon(Icons.clear),
//                     onPressed: () {
//                       setState(() {
//                         _isSearch = false;
//                         _listSearchWidgets.clear();
//                         _listSearchWidgets.addAll(_listWidgets);
//                       });
//                     },
//                   )
//                 : Text(""),
//           ],
//         ));
//   }
//
//   void activateSpeechRecognizer() {
//     requestPermission();
//
//     _speech = new SpeechRecognition();
//     _speech.setAvailabilityHandler((result) {
//       setState(() {
//         _speechRecognitionAvailable = result;
//       });
//     });
//     _speech.setCurrentLocaleHandler(onCurrentLocale);
//     _speech.setRecognitionStartedHandler(onRecognitionStarted);
//     _speech.setRecognitionResultHandler(onRecognitionResult);
//     _speech.setRecognitionCompleteHandler(onRecognitionComplete);
//     _speech
//         .activate()
//         .then((res) => setState(() => _speechRecognitionAvailable = res));
//   }
//
//   void start() {
//     _isSearch = true;
//     _speech.listen(locale: 'en_US').then((result) {
//       print('Started listening => result $result');
//     });
//   }
//
//   void cancel() {
//     _speech.cancel().then((result) {
//       setState(() {
//         _isListening = result;
//       });
//     });
//   }
//
//   void stop() {
//     _speech.stop().then((result) {
//       setState(() {
//         _isListening = result;
//       });
//     });
//   }
//
//   void onSpeechAvailability(bool result) =>
//       setState(() => _speechRecognitionAvailable = result);
//
//   void onCurrentLocale(String locale) =>
//       setState(() => print("current locale: $locale"));
//
//   void onRecognitionStarted() => setState(() => _isListening = true);
//
//   void onRecognitionResult(String text) {
//     setState(() {
//       transcription = text;
//       _listSearchWidgets.clear();
//       for (String k in _listWidgets) {
//         if (k.toUpperCase().contains(text.toUpperCase()))
//           _listSearchWidgets.add(k);
//       }
//       //stop(); //stop listening now
//     });
//   }
//
//   void onRecognitionComplete() => setState(() => _isListening = false);
//
//   void requestPermission() async {
//     PermissionStatus permission = await PermissionHandler()
//         .checkPermissionStatus(PermissionGroup.microphone);
//
//     if (permission != PermissionStatus.granted) {
//       await PermissionHandler()
//           .requestPermissions([PermissionGroup.microphone]);
//     }
//   }
// }
