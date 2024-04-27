import 'contacts_info.dart';
import 'package:faker/faker.dart';

class Contacts {
  final Faker faker = Faker();

  List<ContactsInfo> getContacts() {
    List<ContactsInfo> contacts = [];

    for (int i = 0; i < 20; i++) {
      contacts.add(ContactsInfo(
        name: faker.person.name(),
        publicKey: faker.guid.guid(),
      ));
    }

    return contacts;
  }
}
