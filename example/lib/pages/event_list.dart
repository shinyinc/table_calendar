import 'package:flutter/material.dart';

import '../utils.dart';

class EventList extends StatelessWidget {
  final DateTime selectedDay;

  EventList(
    this.selectedDay, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final events = _getEventsForDay(selectedDay);
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 4.0,
          ),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            onTap: () => print('${events[index]}'),
            title: Text('${events[index]}'),
          ),
        );
      },
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }
}
