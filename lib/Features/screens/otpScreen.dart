// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class OtpScreen extends StatefulWidget {
//   const OtpScreen({Key? key}) : super(key: key);
//
//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }
//
// class _OtpScreenState extends State<OtpScreen> {
//   TextEditingController _otpController = TextEditingController();
//   String _errorMessage = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: Image.asset(
//               'assets/loginscreenimage.png', // replace with your image asset
//               fit: BoxFit.cover,
//             ),
//           ),
//
//           SafeArea(
//             child: Center(
//               child: Container(
//                 height: 370,
//                 width: 300,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: Colors.white,
//                   border: Border.all(
//                     color: Colors.grey, // Set border color
//                     width: 1, // Set border width
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'OTP Verification',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Row(
//                         children: [
//                           Text(
//                             'Enter the OTP sent to ',
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             '+91 000 000 0000',
//                           )
//                         ],
//                       ),
//                       SizedBox(height: 20),
//                       TextFormField(
//                         controller: _otpController,
//                         decoration: InputDecoration(
//                           labelText: 'Enter your OTP',
//                           alignLabelWithHint: true,
//                           contentPadding: EdgeInsets.symmetric(vertical: 15),
//                         ),
//                         keyboardType: TextInputType.phone,
//                       ),
//                       SizedBox(height: 20),
//                       MaterialButton(
//                         minWidth: double.infinity,
//                         onPressed: () {
//                           // Static OTP verification
//                           String enteredOtp = _otpController.text;
//                           if (enteredOtp == '1122') {
//                             // Navigate to home screen if OTP is correct
//                             Navigator.pushNamed(context, 'home');
//                           } else {
//                             setState(() {
//                               _errorMessage = 'Invalid OTP. Please try again.';
//                             });
//                           }
//                         },
//                         child: Text(
//                           'Verify',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20,
//                           ),
//                         ),
//                         color: Color(0xffEEEEEE),
//                         textColor: Colors.white,
//                         height: 50,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       if (_errorMessage.isNotEmpty)
//                         SizedBox(height: 10),
//                       Text(
//                         _errorMessage,
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController _otpController = TextEditingController();
  String _errorMessage = '';
  String _phoneNumber = '';

  @override
  void initState() {
    super.initState();
    _getPhoneNumber();
  }
  _getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _phoneNumber = prefs.getString('phoneNumber') ?? ''; // If phone number is not found, set it to an empty string
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/login_background.png', // replace with your image asset
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Center(
              child: Container(
                height: 370,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey, // Set border color
                    width: 1, // Set border width
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'OTP Verification',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Enter the OTP sent to ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _phoneNumber, // Display retrieved phone number here
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _otpController,
                        decoration: InputDecoration(
                          labelText: 'Enter your OTP',
                          alignLabelWithHint: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 20),
                      MaterialButton(
                        minWidth: double.infinity,
                        onPressed: () async {
                          // Static OTP verification
                          String enteredOtp = _otpController.text;
                          if (enteredOtp == '1122') {
                            // Save OTP in shared preferences
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString('otp', enteredOtp);
                            // Save OTP verification completion flag in shared preferences
                            await prefs.setBool('hasCompletedOTP', true);
                            // Navigate to home screen if OTP is correct
                            Navigator.pushReplacementNamed(context, 'home');
                          } else {
                            setState(() {
                              _errorMessage = 'Invalid OTP. Please try again.';
                            });
                          }
                        },
                        child: Text(
                          'Verify',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        color: Color(0xffEEEEEE),
                        textColor: Colors.white,
                        height: 50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      if (_errorMessage.isNotEmpty)
                        SizedBox(height: 10),
                      Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

