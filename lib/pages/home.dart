import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:mi_mapa/services/locations_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MapController _mapController = MapController();
  var lat = -16.65288074613133;
  var lon = -68.30169158902014;

  List locations = [];
  //METODO INIT STATE
  @override
  void initState() {
    super.initState();
    permisos();
    //para saber mi ubicacion
    // mi_ubicacion();
    //obtener las localizaciones
    getLocations();
  }

  getLocations() async {
    var locations = await LocationsService().getLocations();
    print(locations);
    setState(() {
      this.locations = locations;
    });
  }

  permisos() async {
    var estado = await Permission.location.status;
    if (!estado.isGranted) {
      await Permission.location.request();
    }
  }

  mi_ubicacion() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = position.latitude;
      lon = position.longitude;
    });
    //centrear
    _mapController.move(LatLng(lat, lon), 17);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("mapas"),
        ),
        body: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: locations.length,
              itemBuilder: (context, index) {
                // return ListTile(
                //   title: Text(locations[index]['name']),
                //   subtitle: Text(locations[index]['city']),
                //   onTap: () {
                //     setState(() {
                //       lat = double.parse(locations[index]['latitude']);
                //       lon = double.parse(locations[index]['longitude']);
                //     });
                //     _mapController.move(LatLng(lat, lon), 6);
                //   },
                // );
                return ElevatedButton(
                  onPressed: () async {
                    // var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                    // // String url = 'https://router.project-osrm.org/route/v1/driving/$lng,$lat;$lngDestino,$latDestino?geometries=geojson';
                    // String url = 'https://router.project-osrm.org/route/v1/driving/${position.longitude},${position.latitude};${locations[index]['longitude']},${locations[index]['latitude']}?geometries=geojson';
                    // final response = await http.get(Uri.parse(url));
                    // // reutrnShowDialog(context, response.body);

                    // final data = json.decode(response.body);
                    // final List<dynamic> coordinates = data['routes'][0]['geometry']['coordinates'];

                    // setState(() {
                    //   polylinePoints = coordinates
                    //       .map((point) => LatLng(point[1], point[0]))
                    //       .toList();
                    // });

                    setState(() {
                      lat = double.parse(locations[index]['latitude']);
                      lon = double.parse(locations[index]['longitude']);
                    });
                    _mapController.move(LatLng(lat, lon), 6);
                  },
                  child: Text(locations[index]['name']),
                );
              },
            ),
            Expanded(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: LatLng(lat, lon), // Center the map over London
                  initialZoom: 5,
                ),
                children: [
                  TileLayer(
                    // Display map tiles from any source
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
                    userAgentPackageName: 'com.example.app',
                    // And many more recommended properties!
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(lat, lon),
                        width: 25,
                        height: 25,
                        child: GestureDetector(
                          child: Icon(Icons.location_on, color: Colors.red),
                          onTap: () {
                            print('Ubicacion actual');
                          },
                        ),
                      ),
                    ],
                  ),
                  RichAttributionWidget(
                    // Include a stylish prebuilt attribution widget that meets all requirments
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () => launchUrl(Uri.parse(
                            'https://openstreetmap.org/copyright')), // (external)
                      ),
                      // Also add images...
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
