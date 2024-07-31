import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  final WebSocketChannel channel =
      IOWebSocketChannel.connect('wss://echo.websocket.org');

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController editingController = TextEditingController();
  final List<String> messageList = [];
  final StreamController<String> _messageStreamController =
      StreamController<String>();

  @override
  void initState() {
    super.initState();
    // _messageStreamController = StreamController<String>();

    // Listening to WebSocket stream and adding messages to the StreamController
    widget.channel.stream.listen((message) {
      _messageStreamController.add(message.toString());
    });
  }

  void _sendMessage() {
    if (editingController.text.isEmpty) return;
    widget.channel.sink.add(editingController.text);
    editingController.clear();
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    editingController.dispose();
    _messageStreamController.close();
    super.dispose();
  }

  ListView getMessageList() {
    return ListView(
      children: messageList
          .map((message) => ListTile(
                title: Container(
                  color: Colors.tealAccent,
                  padding: const EdgeInsets.all(8.0),
                  height: 50.0,
                  child: Text(message),
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('WebSocket Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: editingController,
              decoration: const InputDecoration(labelText: 'Send message'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: StreamBuilder<String>(
                stream: _messageStreamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    messageList.add(snapshot.data.toString());
                  } else {
                    messageList.clear();
                  }
                  return getMessageList();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        child: const Icon(Icons.send),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'dart:async';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({super.key});

//   final WebSocketChannel channel =
//       IOWebSocketChannel.connect('wss://echo.websocket.org');

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final TextEditingController editingController = TextEditingController();
//   final List<String> messageList = [];
//   late final StreamController<String> _messageStreamController;

//   @override
//   void initState() {
//     super.initState();
//     _messageStreamController = StreamController<String>.broadcast();

//     widget.channel.stream.listen((message) {
//       _messageStreamController.add(message.toString());
//     });
//   }

//   void _sendMessage() {
//     if (editingController.text.isEmpty) return;
//     widget.channel.sink.add(editingController.text);
//     editingController.clear();
//   }

//   @override
//   void dispose() {
//     widget.channel.sink.close();
//     editingController.dispose();
//     _messageStreamController.close();
//     super.dispose();
//   }

//   ListView getMessageList() {
//     return ListView(
//       children: messageList
//           .map((message) => ListTile(
//                 title: Container(
//                   color: Colors.tealAccent,
//                   padding: const EdgeInsets.all(8.0),
//                   height: 50.0,
//                   child: Text(message),
//                 ),
//               ))
//           .toList(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text('WebSocket Example'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: editingController,
//               decoration: const InputDecoration(labelText: 'Send message'),
//             ),
//             const SizedBox(height: 24),
//             Expanded(
//               child: StreamBuilder<String>(
//                 stream: _messageStreamController.stream,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     messageList.add(snapshot.data!);
//                   }
//                   return getMessageList();
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _sendMessage,
//         child: const Icon(Icons.send),
//       ),
//     );
//   }
// }
