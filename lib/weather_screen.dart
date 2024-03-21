import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './weather_forecast_items.dart';
import 'package:http/http.dart' as http;
import './env_secret_file.dart';

class WeatherApp extends StatefulWidget {

  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
 double temp = 0;
 bool isLoading = true;
  @override
  void initState() {
    super.initState();
    try{
      getCurrentWeather();
    }
    catch(e){
      throw 'Exception';
    }
  }

  final String cityName = "London";

  Future<Map<String,dynamic>> getCurrentWeather() async{
    try{
      final result = await http.get(
          Uri.parse("https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openWeatherAPIKey")
      );
      final data = jsonDecode(result.body);
      if(data['cod']!="200"){
        throw 'An unexpected error occurred!';
      }
      return data;
    }catch(e){
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text ("Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              setState(() {});
            },
              icon: const Icon(Icons.refresh)
          )],
      ),
      body:FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child : CircularProgressIndicator.adaptive()
            );
          }
          if(snapshot.hasError){
            return Text(snapshot.error.toString());
          }
          final data = snapshot.data!;
          final currentTemp = data["list"][0]['main']["temp"];
          final currentSky = data["list"][0]["weather"][0]["main"];
          final currentPressure = data["list"][0]["main"]["pressure"];
          final currentWindSpeed = data["list"][0]["wind"]["speed"];
          final currentHumidity = data["list"][0]["main"]["humidity"];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                //main card:
                 SizedBox(
                     width : double.infinity,
                     child: Card(
                       elevation: 20,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(16),
                       ),
                       child: ClipRRect(
                         borderRadius: BorderRadius.circular(16),
                         child: BackdropFilter(
                           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                           child: Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Column(
                               children: [
                                 const SizedBox(height: 10,),
                                 Text("$currentTemp Kelvin (K)", style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 28)),
                                 const SizedBox(height: 10,),
                                 Icon(currentSky == 'Clouds' || currentSky == 'Rain' ? Icons.cloud : Icons.sunny, size: 64,),
                                 const SizedBox(height: 10,),
                                 Text(currentSky, style: const TextStyle(fontSize: 18),),
                                 const SizedBox(height: 10,)
                               ],
                             ),
                           ),
                         ),
                       ),
                     ),
                   ),

                const SizedBox(height: 20,),

                //Weather forecast cards :
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Weather Forecast",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),),
                ),
                const SizedBox(height: 12,),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for(int i=0; i<5; i++) // don't use {} for this in flutter, you may use ...[] -> deconstructor
                //         HourlyForecastCard(
                //           icon: data["list"][i+1]["weather"][0]["main"] == 'Clouds' || data["list"][i+1]["weather"][0]["main"] == 'Rain' ? Icons.cloud : Icons.sunny, temp: data["list"][i+1]["main"]["temp"].toString(), time: data["list"][i+1]["dt"].toString(),),
                //     ]
                //   )
                // ),

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){
                      final time = DateTime.parse(data["list"][index+1]["dt_txt"]);
                      return HourlyForecastCard(
                        icon: data["list"][index+1]["weather"][0]["main"] == 'Clouds' || data["list"][index+1]["weather"][0]["main"] == 'Rain' ?
                        Icons.cloud : Icons.sunny,
                        temp: data["list"][index+1]["main"]["temp"].toString(),
                        time: DateFormat.Hm().format(time),);
                    },
                  ),
                ),

                const SizedBox(height: 20,),

                //Additional Information :
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Additional Information",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),),
                ),

                const SizedBox(height: 12,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AdditionalInfoCardWidget(icon: Icons.water_drop,label: "Humidity",value: currentHumidity.toString()),
                    AdditionalInfoCardWidget(icon: Icons.wind_power_outlined,label: "Wind Speed",value: currentWindSpeed.toString()),
                    AdditionalInfoCardWidget(icon: Icons. beach_access,label: "Pressure",value: currentPressure.toString()),
                  ],
                )
              ],
            ),
          );
        }
      ),
    );
  }
}
