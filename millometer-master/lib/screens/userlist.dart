import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mill_project/widgets/adduser.dart' as adduser_widget;
import 'package:mill_project/screens/user.dart' as user_model;

class UserList extends StatefulWidget {
  final String factoryId;
  const UserList({super.key, required this.factoryId});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<user_model.User> engineers = [];

  @override
  void initState() {
    super.initState();
    _fetchEngineers();
  }

  Future<void> _fetchEngineers() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.106.29.92:5000/api/engineers/${widget.factoryId}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> fetchedEngineers = jsonDecode(response.body);
        final List<user_model.User> loadedEngineers = fetchedEngineers
            .map((engineerData) => user_model.User.fromJson(engineerData))
            .toList();

        setState(() {
          engineers = loadedEngineers;
          user_model.factoryContacts[widget.factoryId] = loadedEngineers;
        });
      } else {
        print('Failed to load engineers: ${response.body}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  Future<void> _addEngineer(user_model.User engineer) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://10.106.29.92:5000/api/factories/${widget.factoryId}/engineers'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': engineer.name,
          'phoneNum': engineer.phoneNum,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          // Check for duplicates before adding
          if (!engineers.any((e) =>
              e.name == engineer.name && e.phoneNum == engineer.phoneNum)) {
            engineers.add(engineer);

            if (user_model.factoryContacts.containsKey(widget.factoryId)) {
              user_model.factoryContacts[widget.factoryId]!.add(engineer);
            } else {
              user_model.factoryContacts[widget.factoryId] = [engineer];
            }
          }
        });
      } else {
        print('Failed to add engineer: ${response.body}');
      }
    } catch (e) {
      print('Exception occurred: $e');
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
              child: ListView.builder(
                itemCount: engineers.length,
                itemBuilder: (context, index) {
                  return UserCard(
                    user: engineers[index],
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FloatingActionButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            adduser_widget.AddUser(factoryId: widget.factoryId),
                      ),
                    );

                    if (result != null && result is user_model.User) {
                      _addEngineer(result); // Add engineer directly to state
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
}

class UserCard extends StatelessWidget {
  final user_model.User user;
  const UserCard({
    super.key,
    required this.user,
  });

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
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Icon(
                    Icons.circle,
                    color: Colors.grey,
                    size: 10,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      user.name,
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      user.phoneNum,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
