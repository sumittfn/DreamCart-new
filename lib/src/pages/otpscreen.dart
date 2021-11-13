// import 'package:Dreamcart/generated/i18n.dart';
// import 'package:Dreamcart/src/pages/pages.dart';
// import 'package:Dreamcart/src/repository/user_repository.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:otp_screen/otp_screen.dart';
// import 'package:Dreamcart/route_generator.dart';
//
// class OtpCheckWidget extends StatelessWidget {
//   Future<String> validateOtp(String otp) async {
//     await Future.delayed(Duration(milliseconds: 2000));
//     print("Current otp ::::::>>>> " + currentUser.value.otp.toString());
//     if (otp == currentUser.value.otp.toString()) {
//       return null;
//     } else {
//       return "The entered Otp is wrong";
//     }
//   }
//
//   // action to be performed after OTP validation is success
//   void moveToNextScreen(context) {
//     // Navigator.push(
//     //     context,
//     //     MaterialPageRoute(
//     //         builder: (context) => PagesWidget(
//     //               currentTab: 1,
//     //             )));
//     Navigator.of(context).pushNamed('/Pages', arguments: 1);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: OtpScreen(
//       routeCallback: moveToNextScreen,
//       validateOtp: validateOtp,
//       otpLength: 4,
//       title: "Phone Number Verification",
//       subTitle: "Enter the code sent to \n " + currentUser.value.phone,
//     ));
//   }
// }
