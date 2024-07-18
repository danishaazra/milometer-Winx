import 'package:flutter/material.dart';
import 'package:mill_project/widgets/mills.dart';
import 'package:mill_project/widgets/home.dart';
import 'package:mill_project/widgets/settings.dart';
import 'userlist.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedMillIndex = 0;
  String selectedMillID = 'ABC12345';

  void _onMillSelected(int index) {
    setState(() {
      selectedMillIndex = index;
      selectedMillID = millList()[index].raspberrypi_id;
    });

    // Get the selected mill's label from the millList
    String selectedLabel = millList()[index].label;
    // Set the AppBar title to the selected label
    _setAppBarTitle(selectedLabel, selectedMillID);
    _widgetOptions[0] = UserList(millID: selectedMillID);
    _widgetOptions[1] = HomeWidget(millID: selectedMillID);
  }

  void _setAppBarTitle(String title, String millID) {
    // Update the AppBar title using setState to trigger a UI refresh
    setState(() {
      appBarTitle = title;

      if (title == '') {
        appBarTitle = millID;
      }
    });
  }

  String appBarTitle = "Banting M-1";

  //routing for bottomNav
  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _widgetOptions = <Widget>[
    UserList(millID: 'ABC12345'), // Initial millID
    HomeWidget(
      millID: 'ABC12345',
    ),
    Settings(),
  ];

  @override
  void initState() {
    _onMillSelected(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    _widgetOptions.elementAt(_selectedIndex),
                    SizedBox(
                      height: 20,
                    ),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.loose,
                      child: SizedBox(
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: millList().length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                _onMillSelected(index);
                              },
                              child: millList()[index],
                            );
                          },
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Userlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  List<Mills> millList({Color selectedshadow = Colors.black}) {
    List<Mills> mills = [
      Mills(
        raspberrypi_id: 'ABC12345',
        label: 'Banting-M1',
        isSelected: selectedMillIndex ==
            0, // Set isSelected based on the selectedMillIndex
      ),
      Mills(
        raspberrypi_id: 'DEF12345',
        label: 'Klang-M1',
        isSelected: selectedMillIndex ==
            1, // Set isSelected based on the selectedMillIndex
      ),
      Mills(
        raspberrypi_id: 'XYZ98765',
        label: 'Klang-M2',
        isSelected: selectedMillIndex ==
            2, // Set isSelected based on the selectedMillIndex
      ),
    ];
    return mills;
  }
}
// test