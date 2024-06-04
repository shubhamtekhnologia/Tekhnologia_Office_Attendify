// import 'package:attendence110/Features/repository/loginApi.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   TextEditingController _mobileController = TextEditingController();
//   String _errorMessage = '';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Positioned to place the image at the top of the screen
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: Image.asset(
//               'assets/loginscreenimage.png', // replace with your image asset
//               fit: BoxFit.cover,
//               // height: MediaQuery.of(context).size.height * 0.4, // adjust the height as needed
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
//                     mainAxisAlignment: MainAxisAlignment.center, // Align children in the center
//                     children: [
//                       Text(
//                         'LOG IN',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         'We will send you an One Time Password \n on this mobile number',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       TextFormField(
//                         controller: _mobileController,
//                         decoration: InputDecoration(
//                           labelText: 'Enter Mobile Number',
//                           alignLabelWithHint: true,
//                           contentPadding: EdgeInsets.symmetric(vertical: 15),
//                         ),
//                         keyboardType: TextInputType.phone,
//                         inputFormatters: [
//                           LengthLimitingTextInputFormatter(10), // Restrict input to 10 characters
//                           FilteringTextInputFormatter.digitsOnly, // Allow only digits
//                         ],
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter a mobile number';
//                           } else if (value.length != 10) {
//                             return 'Mobile number should be 10 digits';
//                           }
//                           return null;
//                         },
//
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         _errorMessage,
//                         style: TextStyle(color: Colors.red),
//                       ),
//                       SizedBox(height: 20),
//
//                       MaterialButton(
//                         minWidth: double.infinity,
//                         onPressed: () async {
//                           String mobileNumber = _mobileController.text;
//                           bool isValid = await LoginAPI.validateMobileNumber(mobileNumber);
//                           if (isValid) {
//                             Navigator.pushNamed(context, 'otp');
//                           } else {
//                             setState(() {
//                               _errorMessage = 'Mobile number is not valid';
//                             });
//                           }
//                         },
//                         child: Text(
//                           'GET OTP',
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
import 'package:flutter/services.dart';
import 'package:attendence110/Features/repository/loginApi.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _mobileController = TextEditingController();
   String _errorMessage='';

  @override
  void initState() {
    super.initState();
    // Check if the user is already logged in
    _checkIfLoggedIn();
  }

  // Function to check if the user is already logged in
  void _checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      // If user is logged in, navigate to OTP screen
      Navigator.pushReplacementNamed(context, 'otp');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Positioned to place the image at the top of the screen
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
                    mainAxisAlignment: MainAxisAlignment.center, // Align children in the center
                    children: [
                      Text(
                        'LOG IN',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'We will send you an One Time Password \n on this mobile number',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _mobileController,
                        decoration: InputDecoration(
                          labelText: 'Enter Mobile Number',
                          alignLabelWithHint: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10), // Restrict input to 10 characters
                          FilteringTextInputFormatter.digitsOnly, // Allow only digits
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a mobile number';
                          } else if (value.length != 10) {
                            return 'Mobile number should be 10 digits';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        _errorMessage,
                        // 'invalid mobile number',
                        // _errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(height: 20),

                      MaterialButton(
                        minWidth: double.infinity,
                        onPressed: () async {
                          String mobileNumber = _mobileController.text;
                          if (mobileNumber.isEmpty) {
                            // If mobile number is empty, display error message
                            setState(() {
                              _errorMessage = 'Please enter a mobile number';
                            });
                          } else if (mobileNumber.length != 10) {
                            // If mobile number is not 10 digits, display error message
                            setState(() {
                              _errorMessage = 'Mobile number should be 10 digits';
                            });
                          } else {
                            // Mobile number is of correct length, validate it
                            bool isValid = await LoginAPI.validateMobileNumber(mobileNumber);
                            if (isValid) {
                              // Save the phone number in shared preferences
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.setString('phoneNumber', mobileNumber);
                              // Set isLoggedIn flag to true to indicate user is logged in
                              await prefs.setBool('isLoggedIn', true);
                              // Clear the text field
                              _mobileController.clear();
                              // Navigate to OTP screen
                              Navigator.pushNamed(context, 'otp');
                              print('shubham dhote$_errorMessage');
                            } else {
                              // If mobile number is not valid, display error message
                              setState(() {
                                _errorMessage = 'Mobile number is not valid';
                              });
                            }
                          }
                        },
                        child: Text(
                          'GET OTP',
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
                      )

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
