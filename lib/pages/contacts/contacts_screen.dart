import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vlc_msg_app/db/db_helper.dart';
import 'package:vlc_msg_app/models/contact.dart';
import 'package:vlc_msg_app/pages/home_screen.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<Contact> _filteredContacts = [];
  List<Contact> _contacts = [];
  String error = "";

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
        _filteredContacts = _contacts;
      });
    } on Exception catch (e) {
      error = e.toString();
    }
  }

  Future<void> _scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
      
      if (!mounted) return;

      Map<String, dynamic> contact = jsonDecode(qrCode);
      Contact newContact = Contact(
        name: contact['name'], 
        publicKey: contact['publicKey']
      );
      final DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.saveContact(newContact);
      await _getContacts();
    } on Exception catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  void _searchContacts(String query) {
    List<Contact> searchedContacts = [];
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
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: searchContact(),
              ),
              const SizedBox(height: 15),
              Flexible(
                child: ListView.separated(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  shrinkWrap: true,
                  itemCount: _filteredContacts.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 5);
                  },
                  itemBuilder: (context, index) {
                    return contactCard(index, context);
                  },
                ),
              )
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

  Card contactCard(int index, BuildContext context) {
    return Card(
      key: ValueKey(_filteredContacts[index].id),
      color: Theme.of(context).colorScheme.background.withOpacity(0.8),
      elevation: 4,
      child: ListTile(
        leading: Container(
          height: 50,
          width: 50,
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
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
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
            ),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {},
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          _filteredContacts[index].name,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.surface,
              ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // here too
      elevation: 0, // and here
      title: Text(
        'Contacts',
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
        color: Theme.of(context).colorScheme.onSecondary,
      ),
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
