import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_updation_plugin/in_app_updation_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'In-App Updation Plugin Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  String _platformVersion = 'Unknown';
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _loadPlatformVersion();
  }

  Future<void> _loadPlatformVersion() async {
    try {
      final version = await AutoUpdater.getPlatformVersion();
      if (mounted) {
        setState(() => _platformVersion = version ?? 'Unknown');
      }
    } on PlatformException {
      if (mounted) {
        setState(() => _platformVersion = 'Failed to get platform version');
      }
    }
  }

  Future<void> _checkForUpdate() async {
    if (_isChecking) return;
    setState(() => _isChecking = true);

    await AutoUpdater.checkForUpdate(
      context: context,
      config: const UpdateConfig(
        // Local test API: run "cd test_api && npm install && npm start"
        // Emulator: 10.0.2.2. Physical device: use your machine IP
        apiUrl: 'http://10.0.2.2:3000/app/update',
      ),
    );

    if (mounted) {
      setState(() => _isChecking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('In-App Updation Example'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Platform: $_platformVersion',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _isChecking ? null : _checkForUpdate,
                icon: _isChecking
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.system_update),
                label: Text(_isChecking ? 'Checking...' : 'Check for Update'),
              ),
              const SizedBox(height: 16),
              Text(
                'Replace the apiUrl in the code with your update API endpoint.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
