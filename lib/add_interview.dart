import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class Event{

  final int count;
  final String participant;
  // final String participant2;
  // final List<String> part = [];
  final DateTime start;
  final DateTime end;
  final Color backgroundcolor;

  Event({
    this.count = 0,
    required this.participant,
    // this.participant2 ='' ,
    required this.start,
    required this.end,
    this.backgroundcolor = Colors.green,
  });
}

class ParticipantProvider extends ChangeNotifier{
  final List<Event> _events = [];

  List<Event> get events => _events;
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;
  void setDate(DateTime date) => _selectedDate = date;

  void NewParticipant(Event event){
    _events.add(event);
    notifyListeners();
  }

  void deleteEvent(Event event){
    _events.remove(event);
    notifyListeners();
  }

  List<Event> eventOfSelectedDate(List<Event> event){

  }
}


class AddInterview extends StatefulWidget{
  final Event? event;
  AddInterview({
    Key? key,
    this.event,
  }) : super(key: key);

  @override
  _EditInterview createState() => _EditInterview();
}

class _EditInterview extends State<AddInterview>{
  final _formkey = GlobalKey<FormState>();
  final participantController = TextEditingController();
  late DateTime start;
  late DateTime end;

  @override
  void initState(){
    super.initState();

    if(widget.event == null){
      start = DateTime.now();
      end = DateTime.now().add(Duration(hours:1));
    }
  }
  @override
  void dispose() {
    participantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: CloseButton(),
      actions: EditAction(),
    ),
    body:SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: Form(
        child:Column(
        mainAxisSize:MainAxisSize.min ,
        children: <Widget>[
          AddParticipants(),
          SizedBox(height: 10),
          DateTimePicker(),
        ],
        ),
      ),
    ),
  );

  List<Widget> EditAction() => [
    ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        shadowColor: Colors.transparent,
      ),
      onPressed: saveForm,
      icon: Icon(Icons.done),
      label: Text('Save')
    ),
  ];

  Widget AddParticipants() =>TextFormField(
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: 'Participant 1',
            ),
            onFieldSubmitted: (_) => saveForm(),
            validator: (value){
              if(value != null &&
                  value.isEmpty){
                return 'Enter Participants';
              }
              else{
                return 'Parth';
              }
            },
            controller: participantController,
            // TextFormField(
            //   style: TextStyle(fontSize: 18),
            //   decoration: InputDecoration(
            //     border: UnderlineInputBorder(),
            //     hintText: 'Participant 2',
            //   ),
            //   onFieldSubmitted: (_) {},
            //   validator: (value){
            //     if(value == null || value.isEmpty){
            //       return 'Enter Participants';
            //     }
            //     return null;
            //   },
            //   controller: participantController,
            // ),
        );
    // );

  Future fromDateTime({required bool pickDate}) async{
    final date = await pickDateTime(start,pickDate: pickDate);
    if(date == null) return;
    if(date.isAfter(end)){
      end = DateTime(date.year,date.day,date.day);
    }
    setState(() => start = date);
  }

  Future toDateTime({required bool pickDate}) async{
    final date = await pickDateTime(end,pickDate: pickDate,
      firstDate: pickDate ? start:null,
    );
    if(date == null) return;
    // if(date.isBefore(start)){
    //   start = DateTime(date.year,date.day,date.day);
    // }
    setState(() => end = date);
  }


  Future<DateTime?> pickDateTime(
      DateTime initialDate,
      {required bool pickDate,DateTime? firstDate
      }) async{
    if(pickDate){
      final date = await showDatePicker(context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime(2015,8),
          lastDate: DateTime(2101));
      if (date == null) return null;
      final time = Duration(hours: initialDate.hour,minutes: initialDate.minute);

      return date.add(time);
    }
    else{
      final timeofday = await showTimePicker(context: context,
          initialTime: TimeOfDay.fromDateTime(initialDate));

      if(timeofday == null) return null;

      final date = DateTime(initialDate.year,initialDate.month,initialDate.day);
      final time = Duration(hours: timeofday.hour,minutes: timeofday.minute);
      return date.add(time);
    }

  }



  Widget DateTimePicker() =>Column(
    children: [
      buildFrom(),
      buildto()
    ],
  );

  Widget buildFrom() => Header(header: 'From',
     child:Row(
      children: [
        Expanded(
          child: DropDown(
            text: DateFormat.yMMMEd().format(start),
            onClicked: () => fromDateTime(pickDate:true),
          ),
        ),
        Expanded(
          child: DropDown(
            text: DateFormat.Hm().format(start),
            onClicked: () => fromDateTime(pickDate:false),
          ),
        ),
      ],
    ),
  );




  Widget buildto() => Header(header: 'To',
    child:Row(
      children: [
        Expanded(
          child: DropDown(
            text: DateFormat.yMMMEd().format(end),
            onClicked: () => toDateTime(pickDate:true),
          ),
        ),
        Expanded(
          child: DropDown(
            text: DateFormat.Hm().format(end),
            onClicked: () => toDateTime(pickDate:false),
          ),
        ),
      ],
    ),
  );



  Widget Header({
    required String header,
    required Widget child})=>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(header,
          style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 12)),
          child,
      ],
    );



  Widget DropDown({
  required String text,
  required VoidCallback onClicked}) =>
      ListTile(
        title: Text(text),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Future saveForm() async{
    final isValid = _formkey.currentState!.validate();
    setState(() {
      if (isValid){
        final event = Event(participant: participantController.text, start: start, end: end);

        final provider = Provider.of<ParticipantProvider>(context,listen: true);
        provider.NewParticipant(event);

        Navigator.of(context).pop();
      }
    });



  }
}
