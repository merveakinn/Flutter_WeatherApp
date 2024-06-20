import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
const String apiKey = 'bffb1f8ebce18d3d573b03c4eb9778c0';
const String apiUrl = 'http://api.openweathermap.org/data/2.5/weather';

Future<Map<String, dynamic>> getWeatherData(String cityName) async {
  final response = await http.get(Uri.parse('$apiUrl?q=$cityName&appid=$apiKey'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load weather data');
  }
}
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hava Durumu Uygulaması',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  TextEditingController _controller = TextEditingController();
  Map<String, dynamic> _weatherData = {};

  void _getWeather() async {
    try {
      Map<String, dynamic> data = await getWeatherData(_controller.text);
      setState(() {
        _weatherData = data;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hava Durumu Uygulaması')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Şehir adı girin',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _getWeather,
              child: Text('Hava Durumu Getir'),
            ),
            _weatherData.isNotEmpty
                ? Column(
              children: [
                Text(
                  'Şehir: ${_weatherData['name']}',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Sıcaklık: ${_weatherData['main']['temp']}°C',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Durum: ${_weatherData['weather'][0]['description']}',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

/*

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class Note {
  String title;
  String content;

  Note({
    required this.title,
    required this.content,
  });
}

class NotesController extends GetxController {
  final notes = <Note>[].obs;

  void addNote(String title, String content) {
    notes.add(Note(
      title: title,
      content: content,
    ));
  }

  void deleteNote(int index) {
    notes.removeAt(index);
  }
}

class MyApp extends StatelessWidget {
  final NotesController notesController = Get.put(NotesController());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Notes App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Notes App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Enter Note Title'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: contentController,
                  decoration: InputDecoration(labelText: 'Enter Note Content'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  notesController.addNote(
                    titleController.text,
                    contentController.text,
                  );
                  titleController.clear();
                  contentController.clear();
                },
                child: Text('Add Note'),
              ),
              SizedBox(height: 20),
              Obx(
                    () => Expanded(
                  child: ListView.builder(
                    itemCount: notesController.notes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(notesController.notes[index].title),
                        subtitle: Text(notesController.notes[index].content),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => notesController.deleteNote(index),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
