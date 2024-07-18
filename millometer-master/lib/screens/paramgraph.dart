import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class ParamGraph extends StatefulWidget {
  final String paramtype;
  final String millID;
  const ParamGraph({super.key, required this.paramtype, required this.millID});

  @override
  State<ParamGraph> createState() => _ParamGraphState();
}

class _ParamGraphState extends State<ParamGraph> {
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData1 = [
      ChartData(DateTime(2010, 1, 1, 9, 0), 35),
      ChartData(DateTime(2010, 1, 1, 9, 1), 28),
      ChartData(DateTime(2010, 1, 1, 9, 2), 34),
      ChartData(DateTime(2010, 1, 1, 9, 3), 32),
      ChartData(DateTime(2010, 1, 1, 9, 4), 40),
    ];
    final List<ChartData> chartData2 = [
      ChartData(DateTime(2010, 1, 1, 9, 0), 40),
      ChartData(DateTime(2010, 1, 1, 9, 1), 30),
      ChartData(DateTime(2010, 1, 1, 9, 2), 38),
      ChartData(DateTime(2010, 1, 1, 9, 3), 35),
      ChartData(DateTime(2010, 1, 1, 9, 4), 50),
    ];
    final List<ChartData> chartData3 = [
      ChartData(DateTime(2010, 1, 1, 9, 0), 30),
      ChartData(DateTime(2010, 1, 1, 9, 1), 20),
      ChartData(DateTime(2010, 1, 1, 9, 2), 30),
      ChartData(DateTime(2010, 1, 1, 9, 3), 22),
      ChartData(DateTime(2010, 1, 1, 9, 4), 35),
    ];
    final List<List<ChartData>> chartdata = [
      chartData1,
      chartData2,
      chartData3
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.millID),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Center(
                  child: Text(
                    widget.paramtype,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        height: 0.6,
                        color: Color.fromARGB(255, 104, 104, 104)),
                  ),
                ),
              ),
              Graph(chartData: chartdata),
              const Calendar()
            ],
          ),
        ));
  }
}

class Calendar extends StatelessWidget {
  const Calendar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0), //minor adjustment padding
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Shadow color
                spreadRadius: 2, // Spread radius of the shadow
                blurRadius: 4, // Blur radius of the shadow
                offset: const Offset(0, 3), // Offset of the shadow
              )
            ]),
        child: SfDateRangePicker(
          view: DateRangePickerView.month,
          selectionMode: DateRangePickerSelectionMode.range,
          showActionButtons: true,
          onSubmit: (p0) {},
        ),
      ),
    );
  }
}

class Graph extends StatefulWidget {
  const Graph({
    Key? key,
    required this.chartData,
  }) : super(key: key);

  final List<List<ChartData>> chartData;

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SfCartesianChart(
          zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true, enableMouseWheelZooming: true),
          primaryXAxis: DateTimeAxis(
            dateFormat: DateFormat(
                'HH:mm'), // Format the x-axis labels as 'hour:minute'
          ),
          series: <ChartSeries>[
            // Renders line chart
            AreaSeries<ChartData, DateTime>(
              dataSource: widget.chartData.elementAt(1),
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              color: Colors.blue,
            ),
            LineSeries<ChartData, DateTime>(
              dataSource: widget.chartData.elementAt(0),
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              color: Colors.amber,
              width: 2.5,
            ),
            AreaSeries<ChartData, DateTime>(
              dataSource: widget.chartData.elementAt(2),
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              color: Colors.blue[200],
            ),
            LineSeries<ChartData, DateTime>(
              dataSource: <ChartData>[
                ChartData(widget.chartData[0][0].x, 25),
                ChartData(
                    widget.chartData[0][widget.chartData[0].length - 1].x, 25),
              ],
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              dashArray: <double>[5, 5], // Sets the dash pattern for the line
              color: Colors.red,
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            height: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3), // Shadow color
                    spreadRadius: 2, // Spread radius of the shadow
                    blurRadius: 4, // Blur radius of the shadow
                    offset: const Offset(0, 1), // Offset of the shadow
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Row(
                
                children: [
                  const Icon(
                    Icons.circle,
                    color: Colors.blue,
                    size: 15,
                  ),
                  const Text('  Max'),
                  const SizedBox(width: 10,),
                  const Icon(
                    Icons.circle,
                    color: Colors.amber,
                    size: 15,
                  ),
                  const Text('  Average'),
                  const SizedBox(width: 10,),
                  Icon(
                    Icons.circle,
                    color: Colors.blue[200],
                    size: 15,
                  ),
                  const Text('  Minimum'),
                  const SizedBox(width: 10,),
                  const Icon(
                    Icons.circle,
                    color: Colors.red,
                    size: 15,
                  ),
                  const Text('  Threshold'),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}
