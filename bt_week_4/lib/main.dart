import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ContactListScreen(),
    );
  }
}

// ---- Dữ liệu mẫu ----
class Contact {
  final String name;
  final String phone;
  final String email;

  const Contact({required this.name, required this.phone, required this.email});
}

const List<Contact> contacts = [
  Contact(name: 'Nguyen Van An', phone: '0901 234 567', email: 'an@email.com'),
  Contact(name: 'Tran Thi Bich', phone: '0912 345 678', email: 'bich@email.com'),
  Contact(name: 'Le Van Cuong', phone: '0923 456 789', email: 'cuong@email.com'),
  Contact(name: 'Pham Thi Dung', phone: '0934 567 890', email: 'dung@email.com'),
  Contact(name: 'Hoang Van Em', phone: '0945 678 901', email: 'em@email.com'),
  Contact(name: 'Vu Thi Phuong', phone: '0956 789 012', email: 'phuong@email.com'),
  Contact(name: 'Do Van Giang', phone: '0967 890 123', email: 'giang@email.com'),
  Contact(name: 'Bui Thi Hoa', phone: '0978 901 234', email: 'hoa@email.com'),
  Contact(name: 'Dang Van Hung', phone: '0989 012 345', email: 'hung@email.com'),
  Contact(name: 'Nguyen Thi Kim', phone: '0990 123 456', email: 'kim@email.com'),
  Contact(name: 'Vu Phuong', phone: '0956 789 012', email: 'phuong@email.com'),
  Contact(name: 'Do Giang', phone: '0967 890 123', email: 'giang@email.com'),
];

// ---- Màn hình chính ----
class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        itemCount: contacts.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            leading: CircleAvatar(
              // Placeholder avatar: hiển thị chữ cái đầu của tên
              backgroundColor: Colors.primaries[index % Colors.primaries.length],
              child: Text(
                contact.name[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              contact.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(contact.phone),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              // Hiện thông tin chi tiết khi nhấn vào
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(contact.name),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('📞 ${contact.phone}'),
                      const SizedBox(height: 8),
                      Text('✉️ ${contact.email}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Đóng'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}