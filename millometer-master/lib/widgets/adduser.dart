// detail_screen.dart
import 'dart:ui';

import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  String name = '';
  String phoneNum = '';

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        // Close the floating widget when tapping outside the content area
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
                color: Colors.grey,
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
                          'Invite User',
                          style: TextStyle(fontSize: 14),
                        )),
                    Text(
                      'Owner\'s Name : ',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Type here...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Owner\'s Phone Number : ',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          phoneNum = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Type here...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, {
                            'name': name,
                            'phoneNum': phoneNum,
                            'status':
                                1 // Assuming default status as 1 for new users
                          });
                        },
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
