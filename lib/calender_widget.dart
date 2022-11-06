import 'package:android_proj/add_interview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:provider/provider.dart';

class EventDataSource extends CalendarDataSource{
  EventDataSource(List<Event> interviews){
    this.appointments = interviews;

  }

  Event getEvent(int index) => appointments![index] as Event;

  @override
  DateTime getStartTime(int index) => getEvent(index).start;

  @override
  DateTime getEndTime(int index) => getEvent(index).end;

  @override
  String getSubject(int index) => getEvent(index).participant;
}





class CalenderWidget extends StatelessWidget {
  const CalenderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<ParticipantProvider>(context).events;

    return SfCalendar(
      view: CalendarView.month,
      initialSelectedDate:DateTime.now() ,
      dataSource: EventDataSource(events),
      cellBorderColor: Colors.white,
    );
  }
}
