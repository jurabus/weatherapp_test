import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _cityController = TextEditingController();
  final String weatherAPIKey = 'afde5c38e631b4f44b39a8579e4aff7f';
  bool isLoading = false;
  bool isError = false;

  Map weatherData = {};
  Future<void> getWeather() async {
    isLoading = true;
    setState(() {});
    try {
      Response response = await Dio().get(
          "https://api.openweathermap.org/data/2.5/weather?q=${_cityController.text}&appid=$weatherAPIKey");

      weatherData = response.data;
      isError = false;
      isLoading = false;
      setState(() {});
    } catch (e) {
      isLoading = false;
      isError = true;
      setState(() {});
      rethrow;
    }
  }

  //error message
  Widget showErrorMessage() {
    return Center(
      child: Column(
        children: [
          Icon(Icons.error),
          Text('Error Fetching Data'),
          ElevatedButton(onPressed: getWeather, child: Text('Retry'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: _cityController,
                decoration: InputDecoration(label: Text('Type city name')),
              ),
              SizedBox(height: 20),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: getWeather, child: Text('Get Weather!')),
              SizedBox(height: 10),
              isError
                  ? showErrorMessage()
                  : isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        )
                      : weatherData.isEmpty
                          ? Text('Look for Weather')
                          : Column(
                              children: [
                                Text('Weather: $weatherData'),
                              ],
                            )
            ],
          ),
        ),
      ),
    );
  }
}
