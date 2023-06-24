import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_analysis/HomePage/DeviceConnection/DeviceConnection.dart';
import 'package:data_analysis/phoneauth/login.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../GraphService/Graph.dart';
import 'SearchBar.dart';
import 'ListClass.dart';
import 'ListServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DataList extends StatefulWidget {
  const DataList({super.key});
  @override
  DataListState createState() => DataListState();
}

class DataListState extends State<DataList> {
  List<GeoTempData> filteredUsers = [];
  String comment = "Loading ...";
  bool isConnected = true;
  late StreamSubscription sub;
  dynamic wifiColor = Colors.red;

  @override
  void initState() {
    net();
    Services.getUsers().then((usersFromServer) {
      setState(() {
        filteredUsers = usersFromServer;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 70,
        title: const Text("GeoTemp"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate:
                        CustomSearchDelegate(filteredUsers1: filteredUsers));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.wifi,
                          color: Colors.black54,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Device"),
                        )
                      ],
                    )),
                PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.logout_outlined,
                          color: Colors.black54,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Logout"),
                        )
                      ],
                    ))
              ],
              child: const Icon(
                Icons.more_vert,
                size: 28,
              ),
            ),
          )
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
      body: isConnected
          ? RefreshIndicator(
              edgeOffset: 100,
              displacement: 20,
              color: Colors.black,
              onRefresh: refresh,
              child: filteredUsers.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.all(5.0),
                      itemCount: filteredUsers.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < filteredUsers.length) {
                          return card4(filteredUsers, index);
                        } else {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: Text("No more data available",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                          );
                        }
                      })
                  : screen("Loading.json"),
            )
          : screen("NoInternet.json"),
    );
  }

  Widget card4(List<GeoTempData> filteredUsers, int index) {
    return Slidable(
      startActionPane: ActionPane(motion: const BehindMotion(), children: [
        SlidableAction(
          icon: Icons.delete,
          label: 'Delete',
          // child: Lottie.asset("img/confuse.json"),
          onPressed: (context) => {},
          backgroundColor: Colors.red,
        ),
        SlidableAction(
          icon: Icons.update,
          label: 'update',
          onPressed: (context) => {},
          backgroundColor: Colors.blue,
        )
      ]),
      child: Card(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 5.0, bottom: 5, left: 1, right: 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.grading),
                  onPressed: () {
                    print("update");
                  },
                ),
                trailing: Text(
                  filteredUsers[index].time.toString(),
                  style: const TextStyle(color: Colors.green, fontSize: 15),
                ),
                title: Text("PU-${index + 1}"
                    // "\n${filteredUsers[index].date.toString()}"
                    ),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return Graphtemp(
                        date: filteredUsers[index].date.toString(),
                        place: filteredUsers[index].date.toString(),
                        time: filteredUsers[index].time.toString(),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget screen(dynamic image1) {
    return Padding(
      padding: const EdgeInsets.only(top: 150),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 22, bottom: 0),
                width: MediaQuery.of(context).size.width / 1.15,
                height: MediaQuery.of(context).size.height / 4.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                ),
                child: Lottie.asset("img/$image1"),
              ),
            ],
          ),
          SizedBox(
            child: Center(
                child: Text(
              comment,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),
          )
        ],
      ),
    );
  }

  void showSnackBar(dynamic color, String text) {
    setState(() {
      wifiColor = color;
    });
    var snackBar = SnackBar(
        backgroundColor: color,
        duration: const Duration(seconds: 1),
        content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void net() {
    sub = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        isConnected = (result != ConnectivityResult.none);
        if (isConnected != false) {
          comment = "loading ...";
          showSnackBar(Colors.green, "Connected");
        } else {
          comment = "No Internet";
          showSnackBar(Colors.red, "No Internet");
        }
      });
    });
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      comment = "loading ...";
    });
    // filteredUsers.clear();
    Services.getUsers().then((usersFromServer) {
      setState(() {
        filteredUsers = usersFromServer;
      });
    });
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DeviceConnection()),
        );
        break;
      case 1:
        FirebaseAuth.instance.signOut();
        const FlutterSecureStorage().deleteAll();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MyPhone(),
            ),
            (route) => false);
        break;
    }
  }
}
