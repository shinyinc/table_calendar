// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils.dart';
import 'event_list.dart';

class RockCalendarExample extends StatelessWidget {
  late final ValueNotifier<DateTime> _selectedDate =
      ValueNotifier(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks View'),
      ),
      body: Column(
        children: [
          CalendarWidget(
            onDateSelected: (selectedDate) {
              _selectedDate.value = selectedDate;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<DateTime>(
              valueListenable: _selectedDate,
              builder: (context, value, _) {
                return EventList(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  final ValueNotifier<CalendarProperties> _valueNotifier =
      ValueNotifier(CalendarProperties());
  final Function(DateTime)? onDateSelected;

  CalendarWidget({Key? key, this.onDateSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CalendarProperties>(
      valueListenable: _valueNotifier,
      builder: (BuildContext context, properties, Widget? child) {
        return TableCalendar<Event>(
          firstDay: kFirstDay,
          lastDay: kLastDay,
          focusedDay: properties.focusedDay,
          selectedDayPredicate: (day) => isSameDay(properties.selectedDay, day),
          calendarFormat: properties.calendarFormat,
          rangeSelectionMode: RangeSelectionMode.toggledOff,
          eventLoader: _getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
          ),
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            rowDecoration: BoxDecoration(
              border: Border(bottom: BorderSide()), // customize
            ),
          ),
          onDaySelected: _onDaySelected,
          onFormatChanged: (format) {
            if (properties.calendarFormat != format) {
              _valueNotifier.value =
                  properties.copyWith(calendarFormat: format);
            }
          },
          onPageChanged: (focusedDay) {
            _valueNotifier.value = properties.copyWith(focusedDay: focusedDay);
          },
          calendarBuilders: CalendarBuilders(
            headerBuilder: (context, day, onPrevious, onNext, calendarFormat) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Today"),
                  IconButton(
                    onPressed: onPrevious,
                    icon: Icon(Icons.arrow_back),
                  ),
                  Text(day.month.toString()),
                  IconButton(
                    onPressed: onNext,
                    icon: Icon(Icons.arrow_forward_ios),
                  ),
                  Text("My Tasks"),
                ],
              );
            },
            markerBuilder: (context, day, events) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 4.0,
                  child: Text(
                    events.length.toString(),
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_valueNotifier.value.selectedDay, selectedDay)) {
      _valueNotifier.value = _valueNotifier.value.copyWith(
        focusedDay: focusedDay,
        selectedDay: selectedDay,
      );
      onDateSelected!(selectedDay);
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }
}

class CalendarProperties {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final CalendarFormat calendarFormat;

  CalendarProperties({
    DateTime? focusedDay,
    DateTime? selectedDay,
    CalendarFormat? calendarFormat,
  })  : this.focusedDay = focusedDay ?? DateTime.now(),
        this.selectedDay = selectedDay ?? DateTime.now(),
        this.calendarFormat = calendarFormat ?? CalendarFormat.month;

  CalendarProperties copyWith({
    DateTime? focusedDay,
    DateTime? selectedDay,
    CalendarFormat? calendarFormat,
  }) {
    return CalendarProperties(
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      calendarFormat: calendarFormat ?? this.calendarFormat,
    );
  }
}
