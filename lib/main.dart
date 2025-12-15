import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ClipboardPage(),
    );
  }
}

class ClipboardPage extends StatefulWidget {
  @override
  State<ClipboardPage> createState() => _ClipboardPageState();
}

class _ClipboardPageState extends State<ClipboardPage> {
  String clipboardText = "";
  String status = "";

  Future<void> readClipboard() async {
    final data = await Clipboard.getData('text/plain');
    setState(() {
      clipboardText = data?.text ?? "";
      status = clipboardText.isEmpty
          ? "Clipboard empty"
          : "Clipboard loaded";
    });
  }

  Future<void> sendToServer() async {
    if (clipboardText.isEmpty) {
      setState(() {
        status = "Nothing to send";
      });
      return;
    }

    try {
      await http.post(
        Uri.parse("https://example.com/api"), // CHANGE THIS
        headers: {"Content-Type": "application/json"},
        body: '{"text": "$clipboardText"}',
      );
      setState(() {
        status = "Sent successfully";
      });
    } catch (e) {
      setState(() {
        status = "Send failed";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clipboard Sender")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: readClipboard,
              child: const Text("Read Clipboard"),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  clipboardText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: sendToServer,
              child: const Text("Send to Server"),
            ),
            const SizedBox(height: 10),
            Text(status),
          ],
        ),
      ),
    );
  }
}
