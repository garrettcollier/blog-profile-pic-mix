import 'package:flutter/material.dart';

class Event {
  const Event(
      {required this.event,
      required this.mark,
      required this.year,
      required this.meet});

  final String event;
  final double mark;
  final String year;
  final String meet;
}

typedef EventEditCallback = Function(Event event);

class EventItem extends StatelessWidget {
  EventItem({required this.event, required this.eventEdit})
      : super(key: ObjectKey(event));

  final Event event;
  final EventEditCallback eventEdit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        eventEdit(event);
      },
      title: Text(event.event),
      subtitle: Text("Mark: ${event.mark}, Where: ${event.meet}${event.year}"),
    );
  }
}
