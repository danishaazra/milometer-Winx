import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool vibrate =
      true; //need to retrieve from saved state from the device settings
  bool notification =
      true; //need to retrieve from saved state from the device settings
  String tone = 'None';
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
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 2, // Spread radius of the shadow
              blurRadius: 4, // Blur radius of the shadow
              offset: Offset(0, 3), // Offset of the shadow
            )
          ],
        ),
        height: 490,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start, //check
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
                              tooltip:
                                  'Values lower than the \nvalues specified here will\ntrigger the alert.',
                            ))
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
                              millID: '',
                              paramtype: 'Steam\nPressure',
                              unit: 'bar',
                              threshold: 30,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ParamSetting(
                                millID: '',
                                paramtype: 'Water\nLevel',
                                threshold: 42,
                                unit: '%')
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ParamSetting(
                                millID: '',
                                paramtype: 'Steam\nFlow',
                                threshold: 29,
                                unit: 'T/H'),
                            SizedBox(
                              height: 10,
                            ),
                            ParamSetting(
                                millID: '',
                                paramtype: 'Turbine\nFrequency',
                                threshold: 50,
                                unit: 'Hz')
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Sound & Vibrations',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
              ),
              Flexible(
                flex: 5,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Vibrate',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 104, 104, 104)),
                        ),
                        Text(
                          'Show notifications',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 104, 104, 104)),
                        ),
                        Text(
                          'Sound',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 104, 104, 104)),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 80,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: Switch(
                            // This bool value toggles the switch.
                            value: vibrate,
                            activeColor: Colors.blue,
                            onChanged: (bool value) {
                              // This is called when the user toggles the switch.
                              setState(() {
                                vibrate = value;
                              });
                            },
                          ),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Switch(
                            // This bool value toggles the switch.
                            value: notification,
                            activeColor: Colors.blue,
                            onChanged: (bool value) {
                              // This is called when the user toggles the switch.
                              setState(() {
                                notification = value;
                              });
                            },
                          ),
                        ),
                        TextButton(onPressed: () {}, child: Text(tone))
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ParamSetting extends StatefulWidget {
  final String millID;
  final String paramtype;
  final int threshold;
  final String unit;
  const ParamSetting({
    super.key,
    required this.millID,
    required this.paramtype,
    required this.threshold,
    required this.unit,
  });

  @override
  State<ParamSetting> createState() => _ParamSettingState();
}

class _ParamSettingState extends State<ParamSetting> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.paramtype,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 104, 104, 104),
              height: 1.2),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 80,
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(
                                10)), // Set the border radius here
                      ),
                      hintText: widget.threshold.toString(),
                      hintStyle: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          height: 1)),
                  textAlign: TextAlign.right,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                )),
            Container(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.unit,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )))
          ],
        ),
      ],
    );
  }
}
