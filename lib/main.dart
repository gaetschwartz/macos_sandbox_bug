import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Calendar> _calendars = [];
  final List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final cal = DeviceCalendarPlugin();
    final res = await cal.requestPermissions();
    print(res);
    final value = await cal.retrieveCalendars();

    _calendars = value.data!.toList();
    for (var calendar in _calendars) {
      final events = await cal.retrieveEvents(
          calendar.id!,
          RetrieveEventsParams(
              startDate: DateTime.now(),
              endDate: DateTime.now().add(const Duration(days: 365))));
      setState(() {
        _events.addAll(events.data!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return ListTile(
            title: Text(event.title ?? '???'),
            subtitle: Text(event.description ?? '???'),
          );
        },
      ),
    );
  }
}
