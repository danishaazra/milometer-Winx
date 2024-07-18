import 'package:flutter/material.dart';
import 'package:mill_project/widgets/adduser.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 5,
      fit: FlexFit.loose,
      child: SizedBox(
        height: 490,
        child: Stack(
          children: [
            Positioned.fill(
              child: ListView(
                children: [
                  User(
                    name: 'User 1',
                    phoneNum: '+60123456789',
                    status: 1,
                  ),
                  User(
                    name: 'User 2',
                    phoneNum: '+60123456781',
                    status: 0,
                  ),
                  User(
                    name: 'Engineer 1',
                    phoneNum: '+60123456782',
                    status: 1,
                  ),
                  User(
                    name: 'Engineer 2',
                    phoneNum: '+60123456783',
                  ),
                  User(
                    name: 'User 3',
                    phoneNum: '+60123456784',
                  ),
                  User(
                    name: 'User 4',
                    phoneNum: '+60123456785',
                    status: 1,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    _showAddUserScreen(context);
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddUserScreen(BuildContext context) {
    // Use Navigator to push a new widget onto the screen when long-pressed
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AddUser(); // Replace 'DetailScreen' with the widget you want to show
        },
      ),
    );
  }
}

class User extends StatefulWidget {
  final String name;
  final String phoneNum;
  final int status;
  const User(
      {super.key,
      required this.name,
      required this.phoneNum,
      this.status = -1});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: 400,
        height: 90,
        child: Card(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.3), // Shadow color
                      spreadRadius: 1, // Spread radius of the shadow
                      blurRadius: 5, // Blur radius of the shadow
                      offset: Offset(0, 1))
                ]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                  child: _statusIcon(widget.status),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.name,
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      widget.phoneNum,
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Icon _statusIcon(int value) {
    if (value == 0) {
      return Icon(Icons.circle, color: Color.fromARGB(255, 169, 169, 169),size: 10,);
    } else if (value == 1) {
      return Icon(
        Icons.circle,
        color: const Color.fromARGB(255, 101, 224, 105),
        size: 10,
      );
    } else {
      return Icon(Icons.circle, color: Colors.amber,size: 10,);
    }
  }
}
