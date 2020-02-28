import 'package:flutter/material.dart';
import 'package:foodfinderzero/services/data.dart';
import 'package:foodfinderzero/utils/custom_button.dart';
import 'package:foodfinderzero/utils/input_field.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';

class MapView extends StatefulWidget {

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  String _darkMapStyle;


  String key = 'w-VxjptGgWFWBzmZbewHR939JctoKl8dcoyJ1TUZx0ua-h3rUNYEsFVtjeFVLEPZVDZmJFpWOrOVDhX8pN88_xIkZO0yzqwdBwjYXk-WHmRgxKWBgurVMxiXYoRmXXYx';
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  
  CameraPosition currentLocation;
  Geolocator geolocator = Geolocator();

  final PermissionHandler _permissionHandler = PermissionHandler();
  Future<bool> _requestPermission(PermissionGroup permission) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Future<Position> _getLocation() async {
    var currentLocal;

    try {
      currentLocal = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best
      );
    } catch (e) {
      currentLocal = null;
    }
  
    return currentLocal;
  }

  var currentLat;
  var currentLng;
  
  int currentPage = 0;
  @override 
  void initState() {
    super.initState();

    ctrl.addListener(() {
      int next = ctrl.page.round();

      if (currentPage != next) {
        setState(() {
         currentPage = next; 
        });
      }
    });


    rootBundle.loadString('assets/map_dark.txt').then(
      (string) {
        setState(() {
          _darkMapStyle = string;
          //print(_darkMapStyle);
        });
      }
    );

    currentLocation = CameraPosition(
      target: LatLng(37.0902, -95.7129),
      zoom: 5
    );
    _getLocation().then((position) {
      currentLat = position.latitude;
      currentLng = position.longitude;
      mapController.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              position.latitude,
              position.longitude
            ),
            zoom: 13.5
          )
        )
      );

      setState(() {
        markers[MarkerId('Current')] = Marker(
          markerId: MarkerId('Current'),
          position: LatLng(
            currentLat,
            currentLng
          ),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: 'Current Location')
        ); 
      });
    });
  }

  String currentUser;
  getUserId() {
    authService.getUserId().then(
      (result) {
        setState(() {
          currentUser = result;
        });
      }
    );
  }

  bool darkTheme;

  final distanceController = new TextEditingController();
  final foodController = new TextEditingController();
  final priceController = new TextEditingController();
  final ratingController = new TextEditingController();


  final PageController ctrl = PageController(viewportFraction: 0.65);
  List resultList;

  double distance = 1.5;
  convertMilesToMeters(value) {
    return value * 1609.34;
  }

  final primaryColor = new Color(0xFF1de9b6);
  final darkColor = new Color(0xFF263238);
  final whiteColor = new Color(0xFFF8F8F9);
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<DataService>(context);
    setState(() {
      darkTheme = appState.darkTheme;
    });
    Color textColorOnPrimary = appState.getTextColorOnPrimaryColor();
    Color textColor = appState.getTextColor();
    Color elevatedBackgroundColor = appState.getElevatedBackgroundColor();
    Color backgroundColor = appState.getBackgroundColor();

    return new Material(
          child: new Container(
        clipBehavior: Clip.antiAlias,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(
              40
            ),
            bottomRight: Radius.circular(
              40
            )
          )
        ),
        constraints: BoxConstraints.expand(),
        child: new Stack(
          children: [
            new Container(
              //clipBehavior: Clip.antiAlias,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40)
                )
              ),
              constraints: BoxConstraints.expand(),
              child: new GoogleMap(
                compassEnabled: false,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                initialCameraPosition: currentLocation,
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                    if (darkTheme) {
                      mapController.setMapStyle(_darkMapStyle);
                    }
                },
                markers: Set<Marker>.of(markers.values),
              ),
            ),
            new Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: new Container(
                height: 225,
                child: resultList != null ? new PageView.builder(
                  itemCount: resultList != null ? resultList.length : 0,
                  controller: ctrl,
                  itemBuilder: (context, int currentIndex) {
                    bool active = currentIndex == currentPage;
                    return _buildResults(resultList[currentIndex], active, backgroundColor, textColor, context);
                  },
                )
                : new SizedBox()
              ),
            ),
            new Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: new Center(
                child: new Container(
                  width: 75,
                  height: 60,
                  decoration: new BoxDecoration(
                    color: primaryColor,
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.black38,
                        blurRadius: 6,
                        offset: Offset.zero
                      )
                    ],
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        25
                      )
                    )
                  ),
                  child: new Material(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        20
                      )
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: new InkWell(
                      child: new Icon(
                        Icons.search,
                        size: 40,
                        color: textColorOnPrimary,
                      ),
                      splashColor: Colors.black38,
                      onTap: () {
                        showModalBottomSheet(
                          elevation: 10,
                          backgroundColor: Colors.transparent,
                          //barrierColor: Colors.black12,
                          context: context,
                          builder: (context) => new Container(
                            margin: EdgeInsets.only(
                              left: 15,
                              right: 15,
                              bottom: MediaQuery.of(context).size.height * .02
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10
                            ),
                            height: MediaQuery.of(context).size.height * .9,
                            decoration: new BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  20
                                )
                              )
                            ),
                            child: new Column(
                              children: <Widget>[
                                new Text(
                                  "Restaurant Search",
                                  style: new TextStyle(
                                    fontSize: 21,
                                    color: textColor
                                  ),
                                ),
                                new SizedBox(
                                  height: 10
                                ),
                                new Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 20
                                  ),
                                  child: new InputField(
                                    height: 40,
                                    backgroundColor: elevatedBackgroundColor,
                                    hint: "Search Distance (Miles)",
                                    focusColor: primaryColor,
                                    textColor: textColor,
                                    obscure: false,
                                    controller: distanceController,
                                    keyboard: TextInputType.numberWithOptions(decimal: true),
                                  ),
                                ),
                                new Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 20
                                  ),
                                  child: new InputField(
                                    height: 40,
                                    backgroundColor: elevatedBackgroundColor,
                                    hint: "Foods (Brunch, Steak, etc.)",
                                    focusColor: primaryColor,
                                    textColor: textColor,
                                    obscure: false,
                                    controller: foodController,
                                    keyboard: TextInputType.text,
                                  )
                                ),
                                new Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 20
                                  ),
                                  child: new InputField(
                                    height: 40,
                                    backgroundColor: elevatedBackgroundColor,
                                    hint: "Price (1 - 5)",
                                    focusColor: primaryColor,
                                    textColor: textColor,
                                    obscure: false,
                                    controller: priceController,
                                    keyboard: TextInputType.number,
                                  ),
                                ),
                                new Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 20
                                  ),
                                  child: new InputField(
                                    height: 40,
                                    backgroundColor: elevatedBackgroundColor,
                                    hint: "Rating (1 - 5)",
                                    focusColor: primaryColor,
                                    textColor: textColor,
                                    obscure: false,
                                    controller: ratingController,
                                    keyboard: TextInputType.number,
                                  ),
                                ),
                                new SizedBox(
                                  height: 20
                                ),
                                new CustomButton(
                                  externalPadding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10
                                  ),
                                  buttonColor: primaryColor,
                                  shadowColor: Colors.black26,
                                  blurRadius: 6,
                                  buttonWidth: 250,
                                  internalPadding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10
                                  ),
                                  label: "Search",
                                  labelColor: textColorOnPrimary,
                                  labelSize: 21,
                                  onTap: () {
                                    
                                    dataService.getNearbyRestaurants(
                                      distanceController.text == null ? 3000 : distanceController.text,
                                      "Coffee",//foodController.text, 
                                      "3",//priceController.text, 
                                      "3",//ratingController.text, 
                                      currentLat, 
                                      currentLng
                                    ).then(
                                      (response) {
                                        
                                        setState(() {
                                          resultList = response;
                                        });
                                      }
                                    );
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ),
                          )
                        );
                      },
                    )
                  ),
                ),
              )
            ) 
          ]
        ),
      ),
    );
  }
}

_buildResults(Map item, bool active, Color backgroundColor, Color textColor, BuildContext context) {
  
  final double blur = active ? 15 : 0;
  final double opacity = active ? 1 : 0;
  final double top = active ? 10 : 40;
  final double bottom = active ? 10 :40;
  final double left = active ? 20 : 15;
  final double right = active ? 20 : 15;


  return new AnimatedContainer(
    duration: new Duration(milliseconds: 600),
    decoration: new BoxDecoration(
      color: backgroundColor,
      boxShadow: [
        new BoxShadow(
          color: Colors.black26,
          blurRadius: blur,
        )
      ],
      borderRadius: BorderRadius.all(
        Radius.circular(
          20
        )
      )
    ),
    margin: EdgeInsets.only(
      top: top,
      bottom: bottom,
      left: left,
      right: right
    ),
    child: new Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.all(
        Radius.circular(
          20
        )
      ),
      child: new InkWell(
        child: new AnimatedContainer(
          padding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 0
          ),
          duration: new Duration(milliseconds: 600),
          child: new AnimatedOpacity(
            opacity: opacity,
            duration: new Duration(milliseconds: 500),
            child: new ListView(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10
              ),
              shrinkWrap: true,
              physics: active ? NeverScrollableScrollPhysics() : null,
              children: [
                new AspectRatio(
                  aspectRatio: 2.0/0.8,
                  child: new Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          100
                        ),
                      ),
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10
                        )
                      ]
                    ),
                    child: new Image(
                      fit: BoxFit.fitWidth,
                      image: new NetworkImage(
                        item['image_url']
                      ),
                    ),
                  ),
                ),
                new SizedBox(
                  height: 10,
                ),
                new Text(
                  item['name'].length > 18 ? item['name'].substring(0, 18) + "..." : item['name'],
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    color: textColor,
                    fontSize: 17
                  )
                ),
                new Text(
                  item['location']['address1'],
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    color: textColor,
                    fontSize: 15
                  )
                ),
                new Text(
                  item['categories'][0]['title'],
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 14,
                    color: textColor
                  )
                ),
                new Text(
                  item['is_closed'] ? 'Currently Closed' : 'Currently Open',
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 14,
                    color: textColor
                  )
                )
              ],
            ),
          ),
        ),
        onTap: active ? () {
          List details;

          dataService.getRestaurantDetails(item['id']).then(
            (response) {
              details = response;


              showModalBottomSheet(
                elevation: 10,
                backgroundColor: Colors.transparent,
                //barrierColor: Colors.black12,
                context: context,
                builder: (context) => new Container(
                  margin: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: MediaQuery.of(context).size.height * .02
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10
                  ),
                  height: MediaQuery.of(context).size.height * .9,
                  decoration: new BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        20
                      )
                    )
                  ),
                )
              );
            }
          );
        } : null,
      ),
    ),
  );
}