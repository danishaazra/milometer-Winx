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
  String appBarTitle = "Banting M-1";

  final Map<String, Map<String, double>> thresholds = {
    'Banting-M1': {
      'Steam Pressure': 30.0,
      'Steam Flow': 29.0,
      'Water Level': 42.0,
      'Turbine Frequency': 50.0,
    },
    'Klang-M1': {
      'Steam Pressure': 30.0,
      'Steam Flow': 29.0,
      'Water Level': 42.0,
      'Turbine Frequency': 50.0,
    },
    'Klang-M2': {
      'Steam Pressure': 30.0,
      'Steam Flow': 29.0,
      'Water Level': 42.0,
      'Turbine Frequency': 50.0,
    },
  };

  final Map<String, String> factoryNames = {
    'Banting-M1': 'Banting Factory',
    'Klang-M1': 'Klang Factory',
    'Klang-M2': 'Klang Factory 2',
  };

  void _onMillSelected(int index) {
    setState(() {
      selectedMillIndex = index;
    });

    String selectedLabel = millList()[index].label;
    String selectedMillID = millList()[index].raspberrypi_id;

    Map<String, double> selectedInitialValues = initialValues[selectedMillID]!;
    Map<String, double> selectedThresholdValues = thresholds[selectedLabel]!;

    _setAppBarTitle(selectedLabel, selectedMillID);

    _widgetOptions[0] = UserList(factoryId: selectedMillID);

    _widgetOptions[1] = HomeWidget(
      millID: selectedMillID,
      initialValues: selectedInitialValues,
      thresholdValues: selectedThresholdValues,
    );

    _widgetOptions[2] = Settings(
      thresholds: thresholds,
      selectedMillID: selectedMillID,
      onThresholdUpdated: (newThresholds) =>
          _updateThresholds(newThresholds, selectedLabel),
      factoryNames: factoryNames, // Ensure this is passed correctly
    );
  }

  void _setAppBarTitle(String title, String millID) {
    setState(() {
      appBarTitle = title.isEmpty ? millID : title;
    });
  }

  void _updateThresholds(Map<String, double> newThresholds, String millLabel) {
    setState(() {
      thresholds[millLabel] = newThresholds;
    });

    String selectedMillID = millList()[selectedMillIndex].raspberrypi_id;
    Map<String, double> selectedInitialValues = initialValues[selectedMillID]!;

    _widgetOptions[1] = HomeWidget(
      millID: selectedMillID,
      initialValues: selectedInitialValues,
      thresholdValues: newThresholds,
    );
  }

  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _widgetOptions = <Widget>[
    UserList(factoryId: 'ABC12345'),
    HomeWidget(
      millID: '',
      initialValues: {},
      thresholdValues: {},
    ),
    Settings(
      thresholds: {},
      selectedMillID: '',
      onThresholdUpdated: (Map<String, double> newThresholds) {},
      factoryNames: {},
    ),
  ];

  @override
  void initState() {
    super.initState();
    _onMillSelected(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                    const SizedBox(
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
    return [
      Mills(
        raspberrypi_id: 'ABC12345',
        label: 'Banting-M1',
        isSelected: selectedMillIndex == 0,
      ),
      Mills(
        raspberrypi_id: 'DEF12345',
        label: 'Klang-M1',
        isSelected: selectedMillIndex == 1,
      ),
      Mills(
        raspberrypi_id: 'XYZ98765',
        label: 'Klang-M2',
        isSelected: selectedMillIndex == 2,
      ),
    ];
  }

  final Map<String, Map<String, double>> initialValues = {
    'ABC12345': {
      'Steam Pressure': 15.0,
      'Steam Flow': 25.0,
      'Water Level': 35.0,
      'Turbine Frequency': 45.0,
    },
    'DEF12345': {
      'Steam Pressure': 20.0,
      'Steam Flow': 30.0,
      'Water Level': 40.0,
      'Turbine Frequency': 50.0,
    },
    'XYZ98765': {
      'Steam Pressure': 25.0,
      'Steam Flow': 35.0,
      'Water Level': 45.0,
      'Turbine Frequency': 55.0,
    },
  };
}
