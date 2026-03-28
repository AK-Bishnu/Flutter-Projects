import 'package:flutter/material.dart';
import 'client_controller.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  late ClientController controller;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    controller = ClientController();
    controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    controller.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Client')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: controller.logs.length,
              itemBuilder: (_, index) => Padding(
                padding: const EdgeInsets.all(4),
                child: Text(controller.logs[index]),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: isConnected
                    ? null
                    : () async {
                  await controller.connect();
                  setState(() => isConnected = true);
                },
                child: const Text('Connect'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: !isConnected
                    ? null
                    : () {
                  controller.disconnect();
                  setState(() => isConnected = false);
                },
                child: const Text('Disconnect'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            isConnected ? 'Status: Connected' : 'Status: Disconnected',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
