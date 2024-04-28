import 'package:flutter/material.dart';
import 'package:vlc_msg_app/pages/home_screen.dart';

class SendMsgScreen extends StatefulWidget {
  const SendMsgScreen({super.key});

  @override
  State<SendMsgScreen> createState() => _SendMsgScreenState();
}

class _SendMsgScreenState extends State<SendMsgScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The Container with the background image
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/background.jpg'), // replace with your image
              fit: BoxFit.cover,
            ),
          ),
        ),
        // The Scaffold with your widgets
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBar(context),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                addRecipient(),
                Row(
                  children: [
                    InputChip(
                      label: const Text('John Doe'),
                      deleteIcon: const Icon(
                        Icons.close,
                        size: 15,
                        color: Colors.red,
                      ),
                      onDeleted: () {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),
                msgInputField(),
                sendButton(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container sendButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      margin: const EdgeInsets.only(bottom: 20, top: 20),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Colors.white.withOpacity(0.8)),
          foregroundColor:
              MaterialStateProperty.all(Colors.black.withOpacity(0.55)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )),
        ),
        onPressed: () {
          // TODO: send message logic here
        },
        child: Text(
          'Send',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Expanded msgInputField() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.11),
              spreadRadius: 0,
              blurRadius: 40,
            ),
          ],
        ),
        child: TextField(
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(15),
            hintText: 'Type your message here',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          maxLines: 15,
        ),
      ),
    );
  }

  Container addRecipient() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.11),
            spreadRadius: 0,
            blurRadius: 40,
          ),
        ],
      ),
      child: TextField(
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          hintText: 'Add Recipient',
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: 14,
          ),
          prefixIcon: IconButton(
            icon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.4),
            ),
            onPressed: () {
              // TODO: navigate to the select_contacts page
            },
          ),
          suffixIcon: SizedBox(
            width: 70,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  VerticalDivider(
                    color: Theme.of(context).colorScheme.primary,
                    indent: 10,
                    endIndent: 10,
                    thickness: 0.1,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.person_add,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.4),
                    ),
                    onPressed: () {
                      // TODO: navigate to the select_contacts page
                    },
                  ),
                ],
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // here too
      elevation: 0, // and here
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
      // actions: [
      //   IconButton(
      //     icon: const Icon(Icons.settings),
      //     onPressed: () {
      //       // TODO: Navigate to settings screen
      //     },
      //     color: Theme.of(context).colorScheme.background,
      //   ),
      // ],
    );
  }
}
