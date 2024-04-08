import 'package:flutter/material.dart';
import 'package:vlc_msg_app/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),//const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


 
// class BasicWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Basic Widget'),
//       ),
//       body: Center(
//         child: Text(
//           'Hello, World!',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }


// class FirstAppLogin extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           width: 360,
//           height: 800,
//           clipBehavior: Clip.antiAlias,
//           decoration: BoxDecoration(color: Colors.white),
//           child: Stack(
//             children: [
//               Positioned(
//                 left: -8,
//                 top: -538,
//                 child: Container(
//                   width: 368,
//                   height: 1338,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: NetworkImage("https://via.placeholder.com/368x1338"),
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: -5,
//                 top: -151,
//                 child: Container(
//                   width: 370,
//                   height: 642,
//                   decoration: ShapeDecoration(
//                     color: Color(0xFFFBFBFB),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(61),
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: 103,
//                 top: 690,
//                 child: Container(
//                   width: 155,
//                   height: 47,
//                   decoration: ShapeDecoration(
//                     color: Color(0xFFF5F5F5),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: 121,
//                 top: 699,
//                 child: SizedBox(
//                   width: 118,
//                   height: 29,
//                   child: Text(
//                     'Login',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Color(0xFF304B4F),
//                       fontSize: 20,
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w400,
//                       height: 0,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: 82,
//                 top: 541,
//                 child: SizedBox(
//                   width: 239,
//                   height: 27,
//                   child: Text(
//                     'Do you wish to use your mobile credentials as your login details?',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w400,
//                       height: 0,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: 57,
//                 top: 88,
//                 child: Container(
//                   width: 247,
//                   height: 146,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: NetworkImage("https://via.placeholder.com/247x146"),
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: 40,
//                 top: 322,
//                 child: SizedBox(
//                   width: 271,
//                   height: 23,
//                   child: Text.rich(
//                     TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'Welcome to ',
//                           style: TextStyle(
//                             color: Color(0xFF788182),
//                             fontSize: 20,
//                             fontFamily: 'Lao Muang Don',
//                             fontWeight: FontWeight.w400,
//                             height: 0,
//                           ),
//                         ),
//                         TextSpan(
//                           text: 'LuminaLinq',
//                           style: TextStyle(
//                             color: Color(0xFF5699A2),
//                             fontSize: 20,
//                             fontFamily: 'Lao Muang Don',
//                             fontWeight: FontWeight.w400,
//                             height: 0,
//                           ),
//                         ),
//                       ],
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: 16,
//                 top: 376,
//                 child: Container(
//                   width: 328,
//                   height: 60,
//                   decoration: ShapeDecoration(
//                     color: Color(0x38D9D9D9),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: 80,
//                 top: 395,
//                 child: SizedBox(
//                   width: 202,
//                   height: 27,
//                   child: Text(
//                     'Enter your name',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Color(0xFFB9B9B9),
//                       fontSize: 20,
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w400,
//                       height: 0,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: 41,
//                 top: 543,
//                 child: Container(
//                   width: 30,
//                   height: 30,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: NetworkImage("https://via.placeholder.com/30x30"),
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
