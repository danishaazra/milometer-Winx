import 'package:flutter/material.dart';
import 'package:mill_project/screens/MainPage.dart';
import 'package:mill_project/widgets/home.dart';
import 'background.dart';
import 'package:mill_project/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int currentState = 1;

  void changeState() {
    setState(() {
      currentState = currentState == 1 ? 2 : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/upmlogo.png",
                  width: 170,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const Text(
                  'Welcome!',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                currentState == 1
                    ? PhoneLogin(changeState: changeState)
                    : const OTPPage(
                  phoneNumber: '',
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Disclaimer | Privacy Statement',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Copyright UPM & Kejuruteraan Mingtak Sawit CSS Sdn.Bhd.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )),
    );
  }
}

class PhoneLogin extends StatefulWidget {
  final Function changeState;

  PhoneLogin({required this.changeState});

  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  bool isChecked = false;
  TextEditingController phoneController = TextEditingController();
  String phoneNumber = ''; // Add phone number variable

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: SizedBox(
                  child: Text(
                    'Enter your mobile number to activate your account.',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.info_outline_rounded,
                size: 30,
                color: Colors.black.withOpacity(0.6),
              )
            ],
          ),
          const SizedBox(height: 60),
          Row(
            children: [
              Image.asset(
                "assets/malaysia.png",
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              const Text("+60", style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: phoneController,
                  key: Key("phone1"),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone Number',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                checkColor: Colors.white,
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
              const Text('I agree to the terms and conditions',
                  style: TextStyle(fontSize: 15))
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: isChecked
                  ? () async {
                phoneNumber = phoneController.text.trim();
                bool otpRequested = await requestOTP(phoneNumber);
                if (otpRequested) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OTPPage(phoneNumber: phoneNumber)),
                  );
                }
              }
                  : null,
              child: const Text(
                'Get Activation Code',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to request OTP from backend
  Future<bool> requestOTP(String phoneNumber) async {
    final url = Uri.parse('http://10.106.4.65:5000/api/otp');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'phone': phoneNumber});

    print('Requesting OTP from $url with body: $body');

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('OTP request successful: ${response.body}');
        return true;
      } else if (response.statusCode == 404) {
        _showErrorDialog('Phone number not registered.');
        return false;
      } else {
        print('OTP request failed: ${response.statusCode}');
        _showErrorDialog('Failed to send OTP. Please try again.');
        return false;
      }
    } catch (e) {
      print('Error requesting OTP: $e');
      _showErrorDialog('Error requesting OTP. Please try again.');
      return false;
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

}
class OTPPage extends StatefulWidget {
  final String phoneNumber;

  const OTPPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  TextEditingController otpController = TextEditingController();
  bool isFilled = false;

  @override
  void initState() {
    super.initState();
    otpController.addListener(() {
      _changeIsFilled();
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void _changeIsFilled() {
    setState(() {
      isFilled = otpController.text.length == 6;
    });
  }

  void activateUser(String otp) async {
    final url = Uri.parse('http://10.106.4.65:5000/api/activate');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'phone': widget.phoneNumber,
      'otp': otp,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainPage(),
            ));
      } else {
        _showErrorDialog('Failed to activate user. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('Error activating user: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add your logo here
              Image.asset(
                "assets/upmlogo.png", // Replace with your image asset
                height: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Enter the activation code you received via SMS.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      key: const Key("otp"),
                      maxLength: 6,
                      controller: otpController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black.withOpacity(0.6)),
                        ),
                        hintText: 'OTP',
                        hintStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Didn\'t receive?', style: TextStyle(fontSize: 16)),
                        TextButton(
                          onPressed: () {
                            // Handle resend OTP
                          },
                          child: const Text(
                            'Tap here',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isFilled
                            ? () {
                          if (otpController.text.trim().length == 6) {
                            activateUser(otpController.text.trim());
                          } else {
                            _showErrorDialog('Please enter a valid OTP.');
                          }
                        }
                            : null,
                        child: const Text(
                          'Activate',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Handle disclaimer action
                },
                child: const Text(
                  'Disclaimer | Privacy Statement',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Copyright UPM & Kejuruteraan Mingtak Sawit CSS Sdn.Bhd.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}