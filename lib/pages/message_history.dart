import 'package:flutter/material.dart';
import 'package:vlc_msg_app/models/msg.dart';
import 'package:vlc_msg_app/db/db_helper.dart';

class MsgHistory extends StatefulWidget {
  const MsgHistory({super.key});

  @override
  _MsgHistoryState createState() => _MsgHistoryState();
}

class _MsgHistoryState extends State<MsgHistory> {
  final DatabaseHelper _databaseHelper =
      DatabaseHelper(); // Create an instance of DatabaseHelper

  List<Map<String, dynamic>> _foundUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  void _fetchMessages() async {
    try {
      List<Message> messages = await _databaseHelper.getMessages();

      if (messages.isNotEmpty) {
        setState(() {
          _foundUsers = messages
              .map((message) => {
                    "id": message.id,
                    "timestamp": message
                        .timestamp, // Adjust these keys according to your Message model
                    "text": message.text,
                  })
              .toList();
        });
      }
    } catch (e) {
      print('Failed to fetch messages: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBar(context),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                  child: Image.asset('assets/images/BareLogo.png'),
                ),
                Expanded(
                  child: _foundUsers.isNotEmpty
                      ? ListView.builder(
                          itemCount: _foundUsers.length,
                          itemBuilder: (context, index) => Card(
                            key: ValueKey(_foundUsers[index]["id"]),
                            color: Colors.white,
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              leading: Text(
                                _foundUsers[index]["id"].toString(),
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Color.fromRGBO(0, 0, 0, 0.55)),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete), // Change icons based on text
                                color: const Color.fromRGBO(49, 76, 79, 1),
                                onPressed: () {
                                  setState(() {
                                    _databaseHelper.deleteMessageById(
                                        _foundUsers[index]["id"]);
                                    _fetchMessages();
                                  });
                                },
                              ),
                              title: Text(
                                // _foundUsers[index]['timestamp'].toString(),
                                _foundUsers[index]["text"].toString(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              subtitle: Text(
                                // '${_foundUsers[index]["text"].toString()} message',
                                _foundUsers[index]['timestamp'].toString(),
                                style: const TextStyle(
                                    color:
                                        Color.fromRGBO(86, 154, 163, 1),
                                    fontSize: 13),
                              ),
                            ),
                          ),
                        )
                      // ignore: prefer_const_constructors
                      : SizedBox(
                          height: double.infinity,
                          child: const Center(
                            child: Text(
                              'No results found',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

AppBar appBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent, // here too
    elevation: 0, // and here
    title: Text(
      'Message History',
      style: Theme.of(context).textTheme.titleMedium,
    ),
    leading: IconButton(
      icon: const Icon(Icons.keyboard_arrow_left),
      // onPressed: () {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => const HomeScreen()),
      //   );
      // },
      onPressed: () {
        Navigator.pop(context);
      },
      color: Theme.of(context).colorScheme.background,
    ),
  );
}
