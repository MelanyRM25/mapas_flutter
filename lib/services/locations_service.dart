import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationsService {
  //vamos al endpoint del backend
  static const url = 'https://aed8-181-115-172-13.ngrok-free.app/api/';
  Future getLocations() async {
    var response =
        await http.get(Uri.parse(url + 'locations')); //va a la ruta 'locatrion'
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body); //trae datos
      return jsonResponse; //retorna un json
    } else {
      return 'Error'; //si no hay datos "error"
    }
  }
}
