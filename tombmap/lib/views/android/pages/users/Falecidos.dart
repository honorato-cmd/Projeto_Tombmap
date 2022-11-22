// ignore_for_file: prefer_const_constructors

import 'package:tombmap/controllers/admin/admin.controller.dart';
import 'package:tombmap/controllers/admin/falecido.controller.dart';
import 'package:flutter/material.dart';
import 'package:tombmap/models/falecido.model.dart';
import 'package:tombmap/views/android/pages/admin/update.falecido.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:getwidget/getwidget.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tombmap/views/android/pages/admin/Secrets.dart';
import 'dart:math' show cos, sqrt, asin;

import 'package:tombmap/views/android/pages/users/localizarfalecido.dart';

class Falecidos extends StatefulWidget {
  const Falecidos({Key? key}) : super(key: key);

  @override
  State<Falecidos> createState() => _FalecidosState();
}

class _FalecidosState extends State<Falecidos> {
  final falecidoController = FalecidoController();
  //TextEditingController _searchTextController = TextEditingController();

  Future<List<Map>>? falecidos;

  @override
  void initState() {
    falecidos = falecidoController.read();
    super.initState();
    _getCurrentLocation();
  }

  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  late GoogleMapController mapController;
  var falecido = FalecidoController();
  var pesquisa = TextEditingController();
  double lat = -20.80950;
  double long = -49.38328;

  late Position _currentPosition;
  String _currentAddress = '';

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();
  TextEditingController nome = new TextEditingController();
  TextEditingController lapide = new TextEditingController();
  String _startAddress = '';
  String _destinationAddress = '';
  String? _placeDistance;

  Set<Marker> markers = {};

  late PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required double width,
    required Icon prefixIcon,
    Widget? suffixIcon,
    required onChanged,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        controller: controller,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  void Pesquisa(String userSearch) async {
     
    setState(() {
      falecidos =  falecidoController.searchResult(userSearch);
    });
  }

  pesquisarlatlong(String nome1, String lapide1) async {
    _getCurrentLocation();
    var response = await falecido.readSearch(nome1, lapide1);
    var longitude =
        response['longitude'] != null ? response['longitude'].toString() : null;
    var latitude =
        response['latitude'] != null ? response['latitude'].toString() : null;

    if ((response['longitude'] == 0) || (response['latitude'] == 0)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          backgroundColor: Colors.grey,
          title: Text('Consulta Negada'),
          content:
              Text('A Pessoa ou a Lápide não estão cadastradas no sistema!'),
          actions: [
            GFButton(
              shape: GFButtonShape.pills,
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  'OK'.toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    print(double.parse(response['latitude']) +
        double.parse(response['longitude']));
    double startLatitude = _currentPosition.latitude;

    double startLongitude = _currentPosition.longitude;
    double destinationLatitude = double.parse(response['latitude'].toString());
    double destinationLongitude =
        double.parse(response['longitude'].toString());

    String startCoordinatesString = '($startLatitude, $startLongitude)';
    String destinationCoordinatesString =
        '($destinationLatitude, $destinationLongitude)';
    // Start Location Marker

    // Destination Location Marker
    Marker destinationMarker = Marker(
      markerId: MarkerId(destinationCoordinatesString),
      position: LatLng(destinationLatitude, destinationLongitude),
      infoWindow: InfoWindow(
        title: 'Destino $destinationCoordinatesString',
        snippet: _destinationAddress,
      ),
      icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(), 'images/tarasco.png'),
    );

    // Adding the markers to the list
    markers.add(destinationMarker);
    print(markers);
    print(
      'START COORDINATES: ($startLatitude, $startLongitude)',
    );
    print(
      'DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
    );

    // Calculating to check that the position relative
    // to the frame, and pan & zoom the camera accordingly.
    double miny = (startLatitude <= destinationLatitude)
        ? startLatitude
        : destinationLatitude;
    double minx = (startLongitude <= destinationLongitude)
        ? startLongitude
        : destinationLongitude;
    double maxy = (startLatitude <= destinationLatitude)
        ? destinationLatitude
        : startLatitude;
    double maxx = (startLongitude <= destinationLongitude)
        ? destinationLongitude
        : startLongitude;

    double southWestLatitude = miny;
    double southWestLongitude = minx;

    double northEastLatitude = maxy;
    double northEastLongitude = maxx;

    // Accommodate the two locations within the
    // camera view of the map
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(northEastLatitude, northEastLongitude),
          southwest: LatLng(southWestLatitude, southWestLongitude),
        ),
        100.0,
      ),
    );

    await _createPolylines(startLatitude, startLongitude, destinationLatitude,
        destinationLongitude);

    double totalDistance = 0.0;

    // Calculating the total distance by adding the distance
    // between small segments
    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += _coordinateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i + 1].latitude,
        polylineCoordinates[i + 1].longitude,
      );
    }

    setState(() {
      _placeDistance = totalDistance.toStringAsFixed(2);
      print('DISTANCE: $_placeDistance km');
    });
  }

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
      });
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 16.0,
          ),
        ),
      );
      await _getAddress();
    }).catchError((e) {
      print("\nERROR ON FUNCTION : " + " _getCurrentLocation \n");
    });
  }

  // Method for retrieving the address
  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });
    } catch (e) {
      print("\nERROR ON FUNCTION : " + " _getAddress \n");
    }
  }

  // Method for calculating the distance between two places

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // Create the polylines for showing the route between two places
  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.API_KEY, // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
                        cursorColor: Colors.black,
                        onChanged: (value) async {  Pesquisa(value);},
                        controller: pesquisa,
                        decoration: InputDecoration(
                          icon: Icon(Icons.search, color: Colors.black),
                          border: OutlineInputBorder(),
                          hintText: 'Nome',
                          labelStyle: TextStyle(color: Colors.black),
                          
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))
                        ),
                      ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: 
        Column(children: [
          Expanded(
              child: FutureBuilder<List<Map<dynamic, dynamic>>>(
                  future: falecidos,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      // ignore: curly_braces_in_flow_control_structures
                      return Center(
                        child: CircularProgressIndicator(), // mensagem circular
                      );

                    if (snapshot.hasError)
                      return Text(snapshot.error!.toString());

                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index) {
                          var falecidos = snapshot.data!;
                          final falecido = falecidos[index];
                          var nome = falecido['nome'];
                          var lapide = falecido['lapide'];

                          return ListTile(
                              title: Text('Nome: ${falecido['nome']}'),
                              subtitle: Text('Lápide: ${falecido['lapide']}'),
                              trailing: Container(
                                width: 100,
                                child: Row(children: [
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15.0))),
                                            backgroundColor: Colors.grey,
                                            title: Text('${falecido['nome']}' +
                                                ', ' +
                                                '${falecido['lapide']}'),
                                            content: Text(
                                                'Latitude: ${falecido['latitude']}, \n' +
                                                    
                                                    'Longitude: ${falecido['longitude']}. \n\n' +
                                                    
                                                    'Deseja enviar esses dados para o Localizador?'),
                                            actions: [
                                              GFButton(
                shape: GFButtonShape.pills,
                color: Colors.black,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    'Não'.toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ),
                                              GFButton(
                shape: GFButtonShape.pills,
                color: Colors.black,
                onPressed: () {
                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LocalizadorFalecido(
                                                                  nomezinho: nome,
                                                                  lapidinha:
                                                                      lapide)));
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    'Sim'.toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.visibility,
                                        color: Colors.black,
                                      ))
                                ]),
                              ));
                        });
                  }))
        ]),
      );
  }
}
