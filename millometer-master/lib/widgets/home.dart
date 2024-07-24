import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'ParamContainer.dart';

class HomeWidget extends StatefulWidget {
  final String millID;
  final Map<String, double> initialValues;
  final Map<String, double> thresholdValues;

  const HomeWidget({
    Key? key,
    required this.millID,
    required this.initialValues,
    required this.thresholdValues,
  }) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late double steamPressureValue;
  late double steamFlowValue;
  late double waterLevelValue;
  late double turbineFrequencyValue;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  late String currentTime;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _initializeValues();
    _initializeNotifications();
    _initializeCurrentTime();
    _updateValuesPeriodically(); // Add this line
  }

  void _initializeValues() {
    setState(() {
      steamPressureValue = widget.initialValues['Steam Pressure'] ?? 0.0;
      steamFlowValue = widget.initialValues['Steam Flow'] ?? 0.0;
      waterLevelValue = widget.initialValues['Water Level'] ?? 0.0;
      turbineFrequencyValue = widget.initialValues['Turbine Frequency'] ?? 0.0;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkThresholds();
    });
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _initializeCurrentTime() {
    currentTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        currentTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      });
    });
  }

  void _updateValuesPeriodically() {
    timer = Timer.periodic(Duration(minutes: 10), (Timer t) {
      setState(() {
        steamPressureValue = _getNewValue(); // Replace with actual logic
        steamFlowValue = _getNewValue(); // Replace with actual logic
        waterLevelValue = _getNewValue(); // Replace with actual logic
        turbineFrequencyValue = _getNewValue(); // Replace with actual logic
      });
      _checkThresholds();
    });
  }

  double _getNewValue() {
    // Replace this with actual logic to get a new value
    return (steamPressureValue + 5) % 100; // Example logic
  }

  @override
  void dispose() {
    timer.cancel(); // Ensure to cancel any active timers
    super.dispose();
  }

  @override
  void didUpdateWidget(HomeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.millID != oldWidget.millID || widget.initialValues != oldWidget.initialValues) {
      _initializeValues();
    }
  }

  void _updateValues(Map<String, double> newValues) {
    setState(() {
      steamPressureValue = newValues['Steam Pressure'] ?? steamPressureValue;
      steamFlowValue = newValues['Steam Flow'] ?? steamFlowValue;
      waterLevelValue = newValues['Water Level'] ?? waterLevelValue;
      turbineFrequencyValue = newValues['Turbine Frequency'] ?? turbineFrequencyValue;
    });
    _checkThresholds();
  }

  void _checkThresholds() {
    final thresholdValues = widget.thresholdValues;

    final steamPressureThreshold = thresholdValues['Steam Pressure'];
    final steamFlowThreshold = thresholdValues['Steam Flow'];
    final waterLevelThreshold = thresholdValues['Water Level'];
    final turbineFrequencyThreshold = thresholdValues['Turbine Frequency'];

    if (steamPressureThreshold != null && steamPressureValue < steamPressureThreshold) {
      _showNotification('Steam Pressure', steamPressureValue, steamPressureThreshold);
      _showBottomSheet('Steam Pressure', steamPressureValue, steamPressureThreshold);
    }
    if (steamFlowThreshold != null && steamFlowValue < steamFlowThreshold) {
      _showNotification('Steam Flow', steamFlowValue, steamFlowThreshold);
      _showBottomSheet('Steam Flow', steamFlowValue, steamFlowThreshold);
    }
    if (waterLevelThreshold != null && waterLevelValue < waterLevelThreshold) {
      _showNotification('Water Level', waterLevelValue, waterLevelThreshold);
      _showBottomSheet('Water Level', waterLevelValue, waterLevelThreshold);
    }
    if (turbineFrequencyThreshold != null && turbineFrequencyValue < turbineFrequencyThreshold) {
      _showNotification('Turbine Frequency', turbineFrequencyValue, turbineFrequencyThreshold);
      _showBottomSheet('Turbine Frequency', turbineFrequencyValue, turbineFrequencyThreshold);
    }
  }

  Future<void> _showNotification(String paramType, double value, double threshold) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id', 'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    final int notificationId = DateTime.now().millisecondsSinceEpoch % 10000;

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      'Threshold Alert',
      '$paramType is lower than needed. Current value: $value, Threshold: $threshold',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  void _showBottomSheet(String paramType, double value, double threshold) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Threshold Alert',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                '$paramType is lower than needed. Current value: $value, Threshold: $threshold',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      },
    );
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('302121.1',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5)),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text('Kwh',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ParamContainer(
                  paramtype: 'Steam Pressure',
                  max: 100,
                  threshold: widget.thresholdValues['Steam Pressure'] ?? 0.0,
                  unit: 'bar',
                  value: steamPressureValue,
                  millID: widget.millID,
                ),
                ParamContainer(
                  paramtype: 'Steam Flow',
                  max: 100,
                  threshold: widget.thresholdValues['Steam Flow'] ?? 0.0,
                  unit: 'T/H',
                  value: steamFlowValue,
                  millID: widget.millID,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ParamContainer(
                  paramtype: 'Water Level',
                  max: 100,
                  threshold: widget.thresholdValues['Water Level'] ?? 0.0,
                  unit: '%',
                  value: waterLevelValue,
                  millID: widget.millID,
                ),
                ParamContainer(
                  paramtype: 'Turbine Frequency',
                  max: 100,
                  threshold: widget.thresholdValues['Turbine Frequency'] ?? 0.0,
                  unit: 'Hz',
                  value: turbineFrequencyValue,
                  millID: widget.millID,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                currentTime,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
