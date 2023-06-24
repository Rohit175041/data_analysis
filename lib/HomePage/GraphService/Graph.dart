import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'GraphClass.dart';

class Graphtemp extends StatefulWidget {
  final String date, place, time;
  const Graphtemp(
      {Key? key, required this.date, required this.place, required this.time})
      : super(key: key);
  @override
  State<Graphtemp> createState() => _GraphtempState();
}

class _GraphtempState extends State<Graphtemp> {
  // late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  List<TempData> chartData = [];
  late dynamic run = true;
  String comment = " ";

  @override
  void initState() {
    chartData.clear();
    setState(() {
      // loadSalesData();
      run = true;
      // _tooltipBehavior = TooltipBehavior(enable: true);
    });
    loadSalesData();
    // _tooltipBehavior = TooltipBehavior(enable: true);
    _zoomPanBehavior = ZoomPanBehavior(
        enablePinching: true,
        enableDoubleTapZooming: true,
        enableSelectionZooming: true,
        selectionRectBorderColor: Colors.red,
        selectionRectBorderWidth: 2,
        selectionRectColor: Colors.grey,
        enablePanning: true,
        zoomMode: ZoomMode.x,
        enableMouseWheelZooming: true,
        maximumZoomLevel: 0.01);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        shadowColor: Colors.black,
        backgroundColor: Colors.black,
        centerTitle: true,
        toolbarHeight: 80,
        title: const Text(
          "TempData",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.cached_rounded),
            onPressed: () {
              setState(() {
                if (run != true) {
                  run = true;
                } else {
                  run = false;
                }
                // _tooltipBehavior = TooltipBehavior(enable: run);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                refre();
                net();
              });
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0)),
              gradient: LinearGradient(
                  colors: [Colors.red, Colors.pink],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter)),
        ),
      ),
      // backgroundColor: Colors.black,
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder(
              future: getJsonFromFirebase(),
              builder: (context, snapShot) {
                if (snapShot.hasData) {
                  if (chartData.isNotEmpty) {
                    return graph(chartData);
                  } else {
                    return card1("loading ...");
                  }
                } else if (snapShot.hasError) {
                  return card1("something went wrong");
                } else {
                  return card1("loading ...");
                }
              })),
    );
  }

  Widget graph(chartData) {
    return Expanded(
        child: SfCartesianChart(
      zoomPanBehavior: _zoomPanBehavior,
      // tooltipBehavior: _tooltipBehavior,
      // Chart title
      title: ChartTitle(text: widget.time),
      series: <ChartSeries<TempData, dynamic>>[
        SplineSeries<TempData, dynamic>(
          dataSource: chartData,
          xValueMapper: (TempData depthdata, _) => depthdata.Depth,
          yValueMapper: (TempData tempdata, _) => tempdata.Temp,
          // enableTooltip: true,
          splineType: SplineType.clamped,
          dataLabelSettings: DataLabelSettings(isVisible: run!),
          // color: Colors.black
        ),
      ],
      primaryXAxis: NumericAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        maximum: 90,
        minimum: 0,
        desiredIntervals: 5,
        labelFormat: '{value}m',
        labelStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        numberFormat: NumberFormat.decimalPattern(),
      ),
      primaryYAxis: NumericAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          minimum: 0,
          maximum: 80,
          desiredIntervals: 10,
          labelFormat: '{value}°C',
          labelStyle:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          numberFormat: NumberFormat.decimalPattern()),
    ));
  }

  Widget card1(dynamic comment) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      // height: 100,
      // width: 350,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 150.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 22),
                    width: MediaQuery.of(context).size.width / 1.15,
                    height: MediaQuery.of(context).size.height / 4.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
                    child: Lottie.asset("img/graph.json"),
                  ),
                ],
              ),
              SizedBox(
                child: Center(
                    child: Text(
                  comment!,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }

  void refre() {
    setState(() {
      chartData.clear();
      loadSalesData();
    });
  }

  Future loadSalesData() async {
    final String jsonString = await getJsonFromFirebase();
    final dynamic jsonResponse = json.decode(jsonString);
    jsonResponse.forEach((id, value) {
      value.forEach((element) {
        chartData.add(TempData.fromJson(element));
      });
    });
  }

  Future<String> getJsonFromFirebase() async {
    String url =
        "https://temp-8ec02-default-rtdb.firebaseio.com/TemperatureData/${widget.date}/${widget.time}.json";
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }

  void net() {
    setState(() {
      comment = "Loading ...";
    });

    Future.delayed(const Duration(seconds: 6), () {
      if (comment != "refresh ...") {
        setState(() {
          comment = "refresh ...";
        });
      }
    });
  }
}
