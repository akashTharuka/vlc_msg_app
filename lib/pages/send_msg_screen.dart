import 'package:flutter/material.dart';
import 'package:vlc_msg_app/db/db_helper.dart';
import 'package:vlc_msg_app/models/contact.dart';
import 'package:vlc_msg_app/models/user.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:vlc_msg_app/utils/encoder.dart';
import 'package:vlc_msg_app/utils/rsa.dart';
import 'package:vlc_msg_app/utils/transmitter.dart';

class SendMsgScreen extends StatefulWidget {
  const SendMsgScreen({super.key});

  @override
  State<SendMsgScreen> createState() => _SendMsgScreenState();
}

class _SendMsgScreenState extends State<SendMsgScreen> {
  List<Contact> _contacts = [];
  String error = "";
  String? _selectedContactPublicKey;
  String? _message;
  bool _isValid = false;


  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  Future<void> _getContacts() async {
    final DatabaseHelper dbHelper = DatabaseHelper();
    try {
      _contacts = await dbHelper.getContacts();
      setState(() {
        _contacts = _contacts;
      });
    } on Exception catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  void _updateIsValid() {
    setState(() {
      _isValid = _selectedContactPublicKey != null && (_message?.isNotEmpty ?? false);
    });
  }

  void _sendMessage() async {
    final String encryptedMsg = await RSAUtils.encryptRSA('msg', _selectedContactPublicKey);
    final String encodedMsg = Encoder.encodeToBinary(encryptedMsg);

    final DatabaseHelper dbHelper = DatabaseHelper();
    User user = await dbHelper.getUser();

    print("encryptedMsg: $encryptedMsg");
    print("encodedMsg: $encodedMsg");

    final String decodedMsg = Encoder.decodeFromBinary(encodedMsg);
    final String decryptedMsg = await RSAUtils.decryptRSA(decodedMsg, user.privateKey);

    print(decryptedMsg);
    // Transmitter.transmit(encodedMsg);
    // Transmitter.transmit('011111101100011101100000');
  }

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
                DropdownSearch<String>(
                  popupProps: const PopupProps.menu(
                    showSelectedItems: true,
                    showSearchBox: true,
                  ),
                  items: _contacts.map((contact) => contact.name).toList(),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(15),
                      hintText: 'Add Recipient',
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.4),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  onChanged: (String? value) {
                    if (value != null) {
                      final selectedContact = _contacts.firstWhere((contact) => contact.name == value);
                      _selectedContactPublicKey = selectedContact.publicKey;
                    } else {
                      _selectedContactPublicKey = null;
                    }
                    _updateIsValid();
                  },
                  validator: (String? item) {
                    if (item == null) {
                      return "Required field";
                    } else {
                      return null;
                    }
                  },
                  selectedItem: null,
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
        onPressed: !_isValid ? _sendMessage : null,
        child: Text(
          'Send',
          style: _isValid 
            ? Theme.of(context).textTheme.labelSmall!.copyWith(
              fontWeight: FontWeight.w700
            ) 
            : Theme.of(context).textTheme.labelSmall!.copyWith(
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSecondary
            ),
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
          maxLines: 25,
          onChanged: (String value) {
            _message = value;
            _updateIsValid();
          }
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
