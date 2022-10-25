// Started with https://docs.flutter.dev/development/ui/widgets-intro
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:to_dont_list/event_items.dart';

// unneeded import
// import 'package:to_dont_list/to_do_items.dart';

List<Event> sprints = [
  Event(event: "400M", mark: "49.03", year: "2022", meet: "UCA")
];
List<Event> distances = [
  Event(event: "1600M", mark: "5:00", year: "2019", meet: "Arkansas State")
];

class TrackList extends StatefulWidget {
  const TrackList({key, required this.title}) : super(key: key);

  @override
  State createState() => _TrackListState();
  final String title;
}

class _TrackListState extends State<TrackList> {
  var eventController = TextEditingController();
  var markController = TextEditingController();
  var yearController = TextEditingController();
  var meetController = TextEditingController();
  //Form code comes from https://stackoverflow.com/questions/54480641/flutter-how-to-create-forms-in-popup
  // ignore: non_constant_identifier_names
  Future<void> _EventInfoPopupForm(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Event'),
          content: SingleChildScrollView(
            child: SizedBox(
              height: 200,
              width: 200,
              child: Column(
                children: [
                  FormFieldTemplate(
                      controller: eventController,
                      decoration: 'Event',
                      formkey: "EventField"),
                  FormFieldTemplate(
                      controller: markController,
                      decoration: 'Mark',
                      formkey: "MarkField"),
                  FormFieldTemplate(
                      controller: yearController,
                      decoration: 'Year',
                      formkey: "YearField"),
                  FormFieldTemplate(
                      controller: meetController,
                      decoration: 'Meet',
                      formkey: "MeetField"),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              key: const Key("OKButton"),
              onPressed: () {
                setState(() {
                  _handleTrackItem(eventController.text, markController.text,
                      yearController.text, meetController.text);
                  Navigator.pop(context);
                });
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }

  // get the current title of the widget
  String getTitle() {
    return widget.title;
  }

  void _handleTrackItem(event, mark, year, meet) {
    setState(
      () {
        // renamed to newEvent to make clearer
        Event newEvent =
            Event(event: event, mark: mark, year: year, meet: meet);
        // if widget title is sprints then insert event in sprints
        if (getTitle() == 'Sprints') {
          sprints.insert(0, newEvent);
        }
        // otherwise insert into distances
        else {
          distances.insert(0, newEvent);
        }
        // clear all controllers
        eventController.clear();
        markController.clear();
        yearController.clear();
        meetController.clear();
      },
    );
  }

  // tap on event to delete
  void _handleEventEdit(Event event) {
    setState(
      () {
        // if sprints then remove sprint event
        if (getTitle() == 'Sprints') {
          sprints.remove(event);
        }
        // else remove distance
        else {
          distances.remove(event);
        }
        // commented out given it shows a deleted event's information
        // _EventInfoPopupForm(context);
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // determine title based on widget title parameter
        title: Text(getTitle() == 'Sprints'
            ? "Sprint Personal Records"
            : "Distance Personal Records"),
      ),
      // drawer code from https://rushabhshah065.medium.com/flutter-navigation-drawer-tab-layout-e74074c249ce
      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                "Type of Event",
                textAlign: TextAlign.justify,
                textScaleFactor: 2.0,
              ),
            ),
            // call ListEvents Stateless widget to give list tile for navigation
            ListEvents(title: 'Sprints'),
            ListEvents(title: 'Distance'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        // set children as either sprints or distances depending on title
        children: getTitle() == 'Sprints'
            ? sprints.map(
                (item) {
                  return EventItem(
                    event: item,
                    eventEdit: _handleEventEdit,
                  );
                },
              ).toList()
            : distances.map(
                (item) {
                  return EventItem(
                    event: item,
                    eventEdit: _handleEventEdit,
                  );
                },
              ).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _EventInfoPopupForm(context);
        },
      ),
    );
  }
}

// UNNEEDED SECOND PAGE CODE (APP ONLY USES TRACKLIST STATEFUL WIDGET NOW)

// class SecondPage extends StatefulWidget {
//   const SecondPage({key, required this.title}) : super(key: key);
//   @override
//   State createState() => _SecondPageState();
//   final String title;
// }

// class _SecondPageState extends State<SecondPage> {
//   var eventController = TextEditingController();
//   var markController = TextEditingController();
//   var yearController = TextEditingController();
//   var meetController = TextEditingController();
//   //Form code comes from https://stackoverflow.com/questions/54480641/flutter-how-to-create-forms-in-popup
//   // ignore: non_constant_identifier_names
//   Future<void> _EventInfoPopupForm(BuildContext context) async {
//     return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Add Event'),
//           content: SingleChildScrollView(
//             child: Container(
//               height: 200,
//               width: 200,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: eventController,
//                     decoration: InputDecoration(hintText: 'Event'),
//                   ),
//                   TextFormField(
//                     controller: markController,
//                     decoration: InputDecoration(hintText: 'Mark'),
//                   ),
//                   TextFormField(
//                     controller: yearController,
//                     decoration: InputDecoration(hintText: 'Year'),
//                   ),
//                   TextFormField(
//                     controller: meetController,
//                     decoration: InputDecoration(hintText: 'Meet'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   _handleTrackItem(eventController.text, markController.text,
//                       yearController.text, meetController.text);
//                   Navigator.pop(context);
//                 });
//               },
//               child: Text('Send'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   String valueText = "";

//   //final List<Item> items = [const Item(name: "Add homework")];

//   final _itemSet = <Item>{};

//   void _handleTrackItem(event, mark, year, meet) {
//     setState(() {
//       Event _event = Event(event: event, mark: mark, year: year, meet: meet);
//       sprints.insert(0, _event);
//       eventController.clear();
//       markController.clear();
//       yearController.clear();
//       meetController.clear();
//     });
//   }

//   void _handleEventEdit(Event event) {
//     setState(() {
//       sprints.remove(event);
//       _EventInfoPopupForm(context);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Distance Personal Records'),
//         ),
//         // drawer code from https://rushabhshah065.medium.com/flutter-navigation-drawer-tab-layout-e74074c249ce
//         drawer: Drawer(
//           child: ListView(
//             children: [
//               DrawerHeader(
//                 decoration: BoxDecoration(color: Colors.green),
//                 child: Text(
//                   "Type of Event",
//                   textAlign: TextAlign.justify,
//                   textScaleFactor: 2.0,
//                 ),
//               ),
//               ListTile(
//                   title: Text("Sprints"),
//                   onTap: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) {
//                       return const TrackList(title: 'Sprints');
//                     }));
//                   }),
//               ListTile(
//                 title: Text("Distance"),
//                 onTap: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) {
//                     return const SecondPage(title: 'Distance');
//                   }));
//                 },
//               ),
//             ],
//           ),
//         ),
//         body: ListView(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           children: distance.map((item) {
//             return EventItem(
//               event: item,
//               eventEdit: _handleEventEdit,
//             );
//           }).toList(),
//         ),
//         floatingActionButton: FloatingActionButton(
//             child: const Icon(Icons.add),
//             onPressed: () {
//               _EventInfoPopupForm(context);
//             }));
//   }
// }

class FormFieldTemplate extends StatelessWidget {
  const FormFieldTemplate(
      {super.key,
      required this.controller,
      required this.decoration,
      required this.formkey});

  final String formkey;
  final TextEditingController controller;
  final String decoration;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: Key(formkey),
      controller: controller,
      decoration: InputDecoration(hintText: decoration),
    );
  }
}

// widget for listing the events as a List Tile within navigator
class ListEvents extends StatelessWidget {
  const ListEvents({Key? key, required this.title}) : super(key: key);

  // passes title to determine type of list to display
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return TrackList(title: title);
            },
          ),
        );
      },
    );
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Sprint PRs',
    home: TrackList(
      title: 'Sprint PR',
    ),
  ));
}
