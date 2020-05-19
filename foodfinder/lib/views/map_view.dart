import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

import 'package:foodfinder/services/data_service.dart';

class MapView extends StatefulWidget {

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  MapboxMapController mapController;
  CameraPosition currentLocation;
  double lat = 0.0;
  double lng = 0.0;
  Geolocator geolocator = Geolocator();

  final Permission _permission = Permission.location;
  

  @override
  void initState() {
    super.initState();
    _permission.request();


    _getLocation().then(
      (location) {
        setState(() {
          lat = location.latitude;
          lng = location.longitude;
          currentLocation = CameraPosition(
            target: LatLng(
              location.latitude,
              location.longitude
            ),
            zoom: 13.5
          );
        });

        mapController.moveCamera(
          CameraUpdate.newCameraPosition(
            currentLocation
          )
        );
        
      }
    );
  }

  Future<Position> _getLocation() async {
    var currentLocale;

    try {
      currentLocale = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best
      );
    } catch (e) {
      currentLocale = null;
    }

    return currentLocale;
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<DataService>(context);
    appState.setCurrentLocation(lat, lng);
    bool isDarkTheme = appState.darkTheme;

    return new Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: new MapboxMap(
        styleString: isDarkTheme ? MapboxStyles.TRAFFIC_NIGHT : MapboxStyles.TRAFFIC_DAY,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.0902, -100.7129),
          zoom: 3
        ),
      ),
    );
  }
}