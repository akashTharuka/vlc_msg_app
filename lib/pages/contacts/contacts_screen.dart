import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vlc_msg_app/pages/contacts/contacts.dart';
import 'package:vlc_msg_app/pages/contacts/contacts_info.dart';
import 'package:vlc_msg_app/pages/home_screen.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _contacts = Contacts().getContacts();
  List<ContactsInfo> _filteredContacts = [];

  String _qrResult = "Not Yet Scanned";

  Future<void> _scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (!mounted) return;
      setState(() {
        _qrResult = qrCode.toString();
      });
    } on PlatformException {
      _qrResult = 'Failed to read QR code.';
    }
  }

  void _searchContacts(String query) {
    List<ContactsInfo> searchedContacts = [];
    if (query.isEmpty) {
      searchedContacts = _contacts;
    } else {
      searchedContacts = _contacts
          .where((contact) =>
              contact.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredContacts = searchedContacts;
    });
  }

  @override
  void initState() {
    _filteredContacts = _contacts;
    super.initState();
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
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    searchContact(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: ListView.separated(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  shrinkWrap: true,
                  itemCount: _filteredContacts.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      key: ValueKey(_filteredContacts[index].publicKey),
                      height: 100,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          // color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.11),
                                offset: const Offset(0, 10),
                                blurRadius: 40,
                                spreadRadius: 0),
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSecondary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                _filteredContacts[index].name[0],
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _filteredContacts[index].name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                        ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    _filteredContacts[index].publicKey,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _scanQRCode,
            backgroundColor: Theme.of(context).colorScheme.background,
            child: const Icon(Icons.add),
          ),
        ),
      ],
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
        color: Theme.of(context).colorScheme.onSecondary,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // TODO: Navigate to settings screen
          },
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ],
    );
  }

  Container searchContact() {
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
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))
        ],
        keyboardType: TextInputType.text,
        onChanged: (value) {
          _searchContacts(value);
        },
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          hintText: 'Search Contacts',
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.background,
            fontSize: 14,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              'assets/icons/Search.svg',
              height: 20,
              width: 20,
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
}
