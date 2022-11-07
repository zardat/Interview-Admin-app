import 'dart:js';

import 'package:android_proj/add_interview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';

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



// class ViewInterview extends StatelessWidget {
//   final Event event;
//
//   const ViewInterview({
//     Key? key,required this.event
// });
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     appBar: AppBar(
//       leading: CloseButton(),
//       actions: InterviewWidget(context,event),
//     ),
//     body: ListView(
//       padding: EdgeInsets.all(30),
//       children: <Widget>[
//         buildDateTime(event),
//         SizedBox(height: 30),
//         Text(
//           event.participant,
//           style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 30),
//       ],
//     ),
//   );
//
//   Widget buildDateTime(Event event){
//     return Column(
//        children: [
//          buildDate('From',event.start),
//          buildDate('End',event.end)
//        ],
//     );
//   }
//
//
//   Widget DeletingInterview() => IconButton(
//       icon: Icon(Icons.delete),
//       onPressed:() {
//         final provider = Provider.of<ParticipantProvider>(context,listen: true);
//         provider.deleteEvent(event);
//       },
//
//   );

// }


class InterviewWidget extends StatefulWidget {
  @override
  _InterviewState createState() => _InterviewState();
}

class _InterviewState extends State<InterviewWidget>{
  @override
  Widget build(BuildContext context){
    final provider = Provider.of<ParticipantProvider>(context);
    final selectedEvents = provider.eventOfSelectedDate;

    if(selectedEvents.isEmpty){
      return Center(
        child: Text(
          'No Interviews Found!',
          style: TextStyle(color: Colors.black,fontSize: 20),
        ),
      );
    }

    return SfCalendarTheme(
        data: SfCalendarThemeData(
          timeTextStyle: TextStyle(fontSize: 18,color: Colors.black),),
          child: SfCalendar(
            view: CalendarView.timelineDay,
            dataSource: EventDataSource(provider.events),
            initialDisplayDate: provider.selectedDate,
            // appointmentBuilder: appointmentBuilder,
            todayHighlightColor: Colors.black,
            // onTap: (details) {
            //   if (details.appointments == null) return;
            //   final event = details.appointments!.first;
            //
            //   Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => ViewInterview(event: event),));
            // }
         )
    );
  }

  // Widget appointmentBuilder(
  //     BuildContext context,
  //     CalendarAppointmentDetails details){
  //
  //   final event = details.appointments.first;
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: event.backgroundColor.withOpacity(0.4),
  //       borderRadius: BorderRadius.circular(14),
  //     ),
  //     width: details.bounds.width,
  //     height: details.bounds.height,
  //     child: Text(
  //       event.title,
  //       maxLines: 3,
  //       overflow: TextOverflow.ellipsis,
  //       style: TextStyle(
  //         color:Colors.black,
  //         fontSize: 18,
  //       ),
  //     ) ,
  //   );
  //
  // }
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
      onLongPress: (details) {
        final provider = Provider.of<ParticipantProvider>(context,listen: true);
        provider.setDate(details.date!);
        showModalBottomSheet(context: context,
            builder: (context) => InterviewWidget());
      },
    );
  }
}
