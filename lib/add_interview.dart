import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
// import 'dart:ffi';
import 'event.dart';
import 'package:validators/validators.dart' as validator;



class ParticipantProvider extends ChangeNotifier{
  final List<Event> _events = [];
  List<Event> get events => _events;
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;
  void setDate(DateTime date) => _selectedDate = date;
  List<Event> get eventOfSelectedDate =>_events;

  void NewParticipant(Event event){
    _events.add(event);
    notifyListeners();
  }

  void deleteEvent(Event event){
    _events.remove(event);
    notifyListeners();
  }

  void editEvent(Event newevent,Event oldevent){
    final index = _events.indexOf(oldevent);
    _events[index] = newevent;
    notifyListeners();
  }
}


class AddInterview extends StatefulWidget{
  final Event? event;
  const AddInterview({
    Key? key,
    this.event,
  }) : super(key: key);

  @override
  _EditInterview createState() => _EditInterview();
}

class _EditInterview extends State<AddInterview>{
  final _formKey = GlobalKey<FormState>();
  final participantController = TextEditingController();
  late DateTime start;
  late DateTime end;
  late String email;

  @override
  void initState(){
    super.initState();

    if(widget.event == null){
      start = DateTime.now();
      end = DateTime.now().add(Duration(hours:1));
    }
    else{
      final event = widget.event!;
      participantController.text = event.participant;
      start = event.start;
      end = event.end;
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
        key: _formKey,
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

  List<Widget> EditAction() =>[
    ElevatedButton.icon(
        onPressed: saveForm,
        icon: Icon(Icons.done),
        label: Text('Save'),
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        shadowColor: Colors.transparent,
      ),
    ),
  ];

  Widget AddParticipants() => TextFormField(
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: 'Participant 1',
            ),
            onFieldSubmitted: (_) => saveForm(),
            validator: (value) =>
                value != null && value.isEmpty ? 'Participant name cant be empty':null,
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

  Future fromDateTime({required bool pickDate}) async{
    final date = await pickDateTime(start,pickDate: pickDate);
    if(date == null) return;
    if(date.isAfter(end)){
      end = DateTime(date.year,date.day,date.day,end.hour,end.minute);
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
  required VoidCallback onClicked
  }) =>
      ListTile(
        title: Text(text),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Future saveForm() async{
    final isValid = _formKey.currentState!.validate();
    // print(isValid);
    setState(() {
      if (isValid){
        final event = Event(participant: participantController.text, start: start, end: end);
        // Navigator.of(context).pop();

        final isedit = widget.event != null;
        final provider = Provider.of<ParticipantProvider>(context,listen: false);

        if(isedit){
          provider.editEvent(event,widget.event!);
          Navigator.of(context).pop();
        }
        else {
          provider.NewParticipant(event);
          Navigator.of(context).pop();
        }
      }
    });

  }
}
