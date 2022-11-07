import 'package:flutter/material.dart';
import 'calender_widget.dart';
import 'add_interview.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);
  static final String title = 'Interview';

  @override
  Widget build(BuildContext context) =>ChangeNotifierProvider(
    create: (context) =>ParticipantProvider(),
    child: MaterialApp(
      // home: Homepage(),
      themeMode: ThemeMode.dark,
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.lightBlue
      ),
      // routes: {
      //   "/": (context)=>Login(),
      //   "/login": (context)=>Login(),
      //   "/homepage": (context)=>Homepage(),
      // },
      debugShowCheckedModeBanner: false,
      title: title,
      home : MainPage(),
    )
  );
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        title: Text(Myapp.title),
        centerTitle: true,
      ),
      body: CalenderWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.blue,),
        backgroundColor: Colors.black,
        onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddInterview())),
      ),
    );
  }
}





