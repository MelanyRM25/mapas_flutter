import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
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
  //METODO INIT STATE
  @override
  void initState() {
    super.initState();
    permisos();
    //para saber mi ubicacion
    mi_ubicacion();
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
        body: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: LatLng(lat, lon), // Center the map over London
            initialZoom: 9.2,
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
        ));
  }
}
