import 'package:flutter/material.dart';
import 'package:vlc_msg_app/pages/home_screen.dart';

class MsgHistory extends StatefulWidget {
  const MsgHistory({Key? key}) : super(key: key);

  @override
  _MsgHistoryState createState() => _MsgHistoryState();
}

class _MsgHistoryState extends State<MsgHistory> {
  final List<Map<String, dynamic>> _allUsers = [
    {"id": 1, "name": "Andy", "msg_type": "Sent"},
    {"id": 2, "name": "Aragon", "msg_type": "Received"},
    {"id": 3, "name": "Bob", "msg_type": "Sent"},
    {"id": 4, "name": "Barbara", "msg_type": "Received"},
    {"id": 5, "name": "Candy", "msg_type": "Sent"},
    {"id": 6, "name": "Colin", "msg_type": "Sent"},
    {"id": 7, "name": "Audra", "msg_type": "Received"},
    {"id": 8, "name": "Banana", "msg_type": "Received"},
    {"id": 9, "name": "Caversky", "msg_type": "Received"},
    {"id": 10, "name": "Becky", "msg_type": "Sent"},
  ];

  // This list holds the data for the list view
  List<Map<String, dynamic>> _foundUsers = [];
  @override
  initState() {
    _foundUsers = _allUsers;
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allUsers;
    } else {
      results = _allUsers
          .where((user) =>
              user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
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
          body: Container(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                    child: Image.asset('assets/images/BareLogo.png'),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(top: 10.0), // specify the top margin
                    child: Text(
                      'Message History',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ),
                  // TextField(
                  //   onChanged: (value) => _runFilter(value),
                  //   decoration: const InputDecoration(
                  //     labelText: 'Search',
                  //     suffixIcon: Icon(Icons.search),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
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
                                  icon: _foundUsers[index]["msg_type"] == "Sent"
                                      ? Icon(Icons.delete)
                                      : Icon(Icons
                                          .delete), // Change icons based on msg_type
                                  color: const Color.fromRGBO(49, 76, 79, 1),
                                  onPressed: () {
                                    setState(() {
                                      _foundUsers.removeAt(index);
                                    });
                                  },
                                ),
                                title: Text(
                                  _foundUsers[index]['name'],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                subtitle: Text(
                                  '${_foundUsers[index]["msg_type"].toString()} message',
                                  style: TextStyle(
                                      color:
                                          const Color.fromRGBO(86, 154, 163, 1),
                                      fontSize: 13),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: double.infinity,
                            child: Center(
                              child: const Text(
                                'No results found',
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
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
    leading: IconButton(
      icon: const Icon(Icons.keyboard_arrow_left),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      },
      color: Theme.of(context).colorScheme.background,
    ),
  );
}
