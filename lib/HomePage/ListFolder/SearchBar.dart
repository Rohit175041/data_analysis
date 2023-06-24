import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../GraphService/Graph.dart';
import 'ListClass.dart';

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate({required this.filteredUsers1});

  List<GeoTempData> users1 = [];
  List<GeoTempData> filteredUsers1 = [];
  String comment = "No results found";
  final myController = TextEditingController();
  String load = "loading ...";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          myController.clear();
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

// second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, users1);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

// third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<GeoTempData> matchQuery2 = [];
    matchQuery2 = filteredUsers1.where((u) {
      return (u.time
              .toString()
              .toLowerCase()
              .contains(query.toString().toLowerCase())
          // || u.place.toString().contains(query.toLowerCase())
          ||
          u.date
              .toString()
              .toLowerCase()
              .contains(query.toString().toLowerCase()));
    }).toList();
    if (matchQuery2.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(5.0),
        itemCount: matchQuery2.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 5.0, bottom: 5, left: 1, right: 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.abc),
                    trailing: Text(
                      matchQuery2[index].time.toString(),
                      style: const TextStyle(color: Colors.green, fontSize: 15),
                    ),
                    title: Text(
                        "PU-${index + 1}\n${matchQuery2[index].date.toString()}"),
                    onTap: () async {
                      // await  Future.delayed(const Duration(milliseconds: 50));
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return Graphtemp(
                            date: matchQuery2[index].date.toString(),
                            place: matchQuery2[index].date.toString(),
                            time: matchQuery2[index].time.toString(),
                          );
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      if (matchQuery2.isEmpty && query.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.only(top: 150.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.15,
                    height: MediaQuery.of(context).size.height / 4.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
                    child: Lottie.asset("img/dataNotFound.json"),
                  ),
                ],
              ),
              SizedBox(
                child: Center(
                    child: Text(
                  comment,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                )),
              )
            ],
          ),
        );
      } else {
        return Container(
          margin: const EdgeInsets.only(top: 170, bottom: 20, left: 25),
          width: MediaQuery.of(context).size.width / 1.15,
          height: MediaQuery.of(context).size.height / 4.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white,
          ),
          child: Center(child: Lottie.asset("img/searchbar.json")),
        );
      }
    }
  }

// last overwrite to show the
// querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<GeoTempData> matchQuery1 = [];
    matchQuery1 = filteredUsers1.where((u) {
      return (u.time
              .toString()
              .toLowerCase()
              .contains(query.toString().toLowerCase())
          // || u.place.toString().contains(query.toLowerCase())
          ||
          u.date
              .toString()
              .toLowerCase()
              .contains(query.toString().toLowerCase()));
    }).toList();
    if (query.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(5.0),
        itemCount: matchQuery1.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 5.0, bottom: 5, left: 1, right: 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.search),
                    trailing: Text(
                      matchQuery1[index].time.toString(),
                      style: const TextStyle(color: Colors.green, fontSize: 15),
                    ),
                    title: Text(
                        "PU-${index + 1}\n${matchQuery1[index].date.toString()}"),
                    onTap: () async {
                      // await  Future.delayed(const Duration(milliseconds: 50));
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return Graphtemp(
                            date: matchQuery1[index].date.toString(),
                            place: matchQuery1[index].date.toString(),
                            time: matchQuery1[index].time.toString(),
                          );
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
      // return ListView.builder(
      //   padding: const EdgeInsets.all(10.0),
      //   itemCount: matchQuery1.length,
      //   itemBuilder: (context, index) {
      //     return Card(
      //       child: Padding(
      //         padding: const EdgeInsets.only(top: 10.0,bottom: 10,left: 10,right:10),
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             ListTile(
      //               leading: const Icon(Icons.search),
      //               trailing:  Text(matchQuery1[index].time.toString(),
      //                 style: const TextStyle(color: Colors.green, fontSize: 15),),
      //               title: Text( "PU-${index+1}\n${matchQuery1[index].date.toString()}"),
      //               onTap:()async{
      //                 // query=matchQuery1.elementAt(index) as String;
      //                 await  Future.delayed(const Duration(milliseconds: 50));
      //                 Navigator.push(
      //                   context,
      //                   MaterialPageRoute(builder: (context){  return Graphtemp(
      //                     date:matchQuery1[index].date.toString(),
      //                     place:matchQuery1[index].date.toString(),
      //                     time:matchQuery1[index].time.toString(),
      //                   );}),
      //                 );
      //                 query=matchQuery1.elementAt(index) as String;
      //               },
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // );
    } else {
      return Padding(
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
                  child: Lottie.asset("img/searchbar.json"),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
