import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mill_project/widgets/adduser.dart';

class UserList extends StatefulWidget {
  final String millID;
  const UserList({super.key, required this.millID});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final response = await http
        .get(Uri.parse('http://localhost:3000/users/${widget.millID}'));
    if (response.statusCode == 200) {
      setState(() {
        users = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

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
                children: users
                    .map((user) => User(
                          name: user['name'],
                          phoneNum: user['phoneNum'],
                          status: user['status'],
                        ))
                    .toList(),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FloatingActionButton(
                  onPressed: () async {
                    final result = await _showAddUserScreen(context);
                    if (result != null) {
                      await _addUser(result);
                      _fetchUsers(); // Refresh the list after adding a user
                    }
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

  Future<void> _addUser(Map<String, dynamic> user) async {
    user['millID'] = widget.millID;
    final response = await http.post(
      Uri.parse('http://localhost:3000/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add user');
    }
  }

  Future<Map<String, dynamic>?> _showAddUserScreen(BuildContext context) async {
    return await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AddUser();
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
      return Icon(
        Icons.circle,
        color: Color.fromARGB(255, 169, 169, 169),
        size: 10,
      );
    } else if (value == 1) {
      return Icon(
        Icons.circle,
        color: const Color.fromARGB(255, 101, 224, 105),
        size: 10,
      );
    } else {
      return Icon(
        Icons.circle,
        color: Colors.amber,
        size: 10,
      );
    }
  }
}
// lego