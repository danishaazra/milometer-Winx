import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final Map<String, Map<String, double>> thresholds;
  final String selectedMillID;
  final ValueChanged<Map<String, double>> onThresholdUpdated;
  final Map<String, String> factoryNames;

  const Settings({
    super.key,
    required this.thresholds,
    required this.selectedMillID,
    required this.onThresholdUpdated,
    required this.factoryNames,
  });

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late Map<String, double> currentThresholds;
  late Map<String, TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    // Initialize currentThresholds and controllers
    currentThresholds = Map.from(widget.thresholds[widget.selectedMillID] ?? {});
    controllers = {
      'Steam Pressure': TextEditingController(text: currentThresholds['Steam Pressure']?.toString() ?? '0.0'),
      'Steam Flow': TextEditingController(text: currentThresholds['Steam Flow']?.toString() ?? '0.0'),
      'Water Level': TextEditingController(text: currentThresholds['Water Level']?.toString() ?? '0.0'),
      'Turbine Frequency': TextEditingController(text: currentThresholds['Turbine Frequency']?.toString() ?? '0.0'),
    };
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void _updateThreshold(String paramtype, double value) {
    setState(() {
      currentThresholds[paramtype] = value;
      controllers[paramtype]?.text = value.toString();
      
      // Fetch the factory name from the mapping
      String factoryName = widget.factoryNames[widget.selectedMillID] ?? 'Factory';
      
      // Debugging: Print factoryName to console
      print('Selected Mill ID: ${widget.selectedMillID}');
      print('Factory Name: $factoryName');
      
      // Show a SnackBar with the update notification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$paramtype updated to $value to the $factoryName'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 5,
      fit: FlexFit.loose,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(220, 248, 248, 248),
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 3),
            )
          ],
        ),
        height: 490,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Text(
                          'Minimum Threshold',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.info_outline),
                            tooltip: 'Values lower than the \nvalues specified here will\ntrigger the alert.',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Flexible(
                flex: 7,
                child: SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ParamSetting(
                              paramtype: 'Steam\nPressure',
                              unit: 'bar',
                              threshold: currentThresholds['Steam Pressure'] ?? 0.0,
                              controller: controllers['Steam Pressure']!,
                              onThresholdChanged: (value) {
                                _updateThreshold('Steam Pressure', value);
                              },
                            ),
                            SizedBox(height: 10),
                            ParamSetting(
                              paramtype: 'Water\nLevel',
                              threshold: currentThresholds['Water Level'] ?? 0.0,
                              unit: '%',
                              controller: controllers['Water Level']!,
                              onThresholdChanged: (value) {
                                _updateThreshold('Water Level', value);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ParamSetting(
                              paramtype: 'Steam\nFlow',
                              threshold: currentThresholds['Steam Flow'] ?? 0.0,
                              unit: 'T/H',
                              controller: controllers['Steam Flow']!,
                              onThresholdChanged: (value) {
                                _updateThreshold('Steam Flow', value);
                              },
                            ),
                            SizedBox(height: 10),
                            ParamSetting(
                              paramtype: 'Turbine\nFrequency',
                              threshold: currentThresholds['Turbine Frequency'] ?? 0.0,
                              unit: 'Hz',
                              controller: controllers['Turbine Frequency']!,
                              onThresholdChanged: (value) {
                                _updateThreshold('Turbine Frequency', value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onThresholdUpdated(currentThresholds);
                  print('Threshold values saved: ${currentThresholds}');
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ParamSetting extends StatelessWidget {
  final String paramtype;
  final String unit;
  final double threshold;
  final TextEditingController controller;
  final ValueChanged<double> onThresholdChanged;

  const ParamSetting({
    super.key,
    required this.paramtype,
    required this.threshold,
    required this.unit,
    required this.controller,
    required this.onThresholdChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              paramtype,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Threshold ($unit)',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                double? newValue = double.tryParse(value);
                if (newValue != null) {
                  onThresholdChanged(newValue);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}