// detail_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddUser extends StatefulWidget {
  final String factoryId;
  AddUser({required this.factoryId});

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  Future<void> _submitEngineer() async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://10.106.18.52:5000/api/factories/${widget.factoryId}/engineers'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': _nameController.text,
          'phoneNum': _phoneController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        print('Failed to add engineer: ${response.body}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Material(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
            ),
            Positioned(
              top: screenHeight * 0.2,
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Invitation',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 25),
                        )),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Invite Engineer',
                          style: TextStyle(fontSize: 14),
                        )),
                    Text(
                      'Engineer\'s Name : ',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Type here...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Engineer\'s Phone Number : ',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        hintText: 'Type here...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: _submitEngineer,
                        child: SizedBox(
                            height: 50,
                            child: Center(
                                child: Text(
                              'Submit',
                              style: TextStyle(fontSize: 18),
                            ))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
