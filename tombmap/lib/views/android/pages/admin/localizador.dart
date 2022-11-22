// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tombmap/controllers/admin/falecido.controller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tombmap/views/android/pages/admin/Secrets.dart';
import 'dart:math' show cos, sqrt, asin;

class Localizador extends StatefulWidget {
  const Localizador({Key? key}) : super(key: key);

  @override
  State<Localizador> createState() => _LocalizadorState();
}

class _LocalizadorState extends State<Localizador> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  late GoogleMapController mapController;
  var falecido = FalecidoController();
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

  pesquisarlatlong() async {
    var response = await falecido.readSearch(nome.text, lapide.text);
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
          content: Text('A Pessoa ou a Lápide não estão cadastradas no sistema!'),
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

    double startLatitude = _currentPosition.latitude;

    double startLongitude = _currentPosition.longitude;
    double destinationLatitude = double.parse(response['latitude'].toString());
    double destinationLongitude =
        double.parse(response['longitude'].toString());

    String startCoordinatesString = '($startLatitude, $startLongitude)';
    String destinationCoordinatesString =
        '($destinationLatitude, $destinationLongitude)';
    // Start Location Marker
    Marker startMarker = Marker(
      markerId: MarkerId(startCoordinatesString),
      position: LatLng(startLatitude, startLongitude),
      infoWindow: InfoWindow(
        title: 'Começo $startCoordinatesString',
        snippet: _startAddress,
      ),
      icon: BitmapDescriptor.defaultMarker,
    );

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
    markers.add(startMarker);
    markers.add(destinationMarker);

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
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
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
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.grey),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: (IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/inicial');
            },
            icon: Icon(Icons.arrow_back_outlined),
          )),
          title: Text('Administrador'),
          centerTitle: true,
          actions: [TextButton(
            child: Text(
              "LogOut",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/inicial');
            },
          ),
        ],
        ),
        body: Stack(
          children: [
            GoogleMap(
              markers: Set<Marker>.from(markers),
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Testes ADMIN',
                            style:
                                TextStyle(color: Colors.black, fontSize: 18.0),
                          ),
                          SizedBox(height: 10),
                          _textField(
                            label: 'Nome',
                            hint: 'Digite o nome completo',
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            controller: nome,
                            width: MediaQuery.of(context).size.width * 0.9,
                          ),
                          SizedBox(height: 10),
                          _textField(
                            label: 'Lápide',
                            hint: 'Digite o nº da lápide',
                            prefixIcon: Icon(
                              Icons.church,
                              color: Colors.black,
                            ),
                            controller: lapide,
                            width: MediaQuery.of(context).size.width * 0.9,
                          ),
                          SizedBox(height: 10),
                          GFButton(
                            shape: GFButtonShape.pills,
                            color: Colors.black,
                            onPressed: () => pesquisarlatlong(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Pesquisar".toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 75.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.black,
                      child: InkWell(
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(
                            Icons.my_location,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  _currentPosition.latitude,
                                  _currentPosition.longitude,
                                ),
                                zoom: 18.0,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.black,
                      child: InkWell(
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed('/cadastro');
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
