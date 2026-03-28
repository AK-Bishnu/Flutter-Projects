import 'package:flutter/material.dart';
import 'package:sound_bound/host/presentation/host_controller.dart';

class HostScreen extends StatefulWidget {
  const HostScreen({super.key});

  @override
  State<HostScreen> createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  late HostController controller;
  bool isMicStreaming = false;

  @override
  void initState() {
    super.initState();
    controller = HostController();
    controller.addListener(() {
      if (mounted) setState(() {});
    });

    _initHost();
  }

  Future<void> _initHost() async {
    try {
      await controller.requestMicPermission();
      await controller.startServer();
    } catch (e) {
      controller.addLog('Error starting host: $e');
    }
  }

  @override
  void dispose() {
    controller.stopServer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Host')),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  controller.pickAndPrepareAudioFile();
                },
                child: Text('Pick Audio File'),
              ),
              SizedBox(width: 10,),
              ElevatedButton(
                onPressed: () async {
                  controller.sendFileToAll();
                },
                child: Text('Send File Info'),
              )


            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
