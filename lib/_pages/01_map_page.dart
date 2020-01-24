import 'dart:async';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 90;
const double CAMERA_BEARING = 90;
const LatLng SOURCE_LOCATION = LatLng(52.198412, 20.858001);
const LatLng DEST_LOCATION = LatLng(52.194507, 21.013195);

Completer<GoogleMapController> _controller = Completer();

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  String googleAPIKey = 'AIzaSyDPmUS4c0pzu_o-zFamwJWKViivjVeGqrM';

  LocationData currentLocation;
  Location location;

  @override
  void initState() {
    super.initState();
    setSourceAndDestinationIcons();

    location = Location();
    location.onLocationChanged().listen((LocationData cLoc) {
      currentLocation = cLoc;
      updatePinOnMap();
    });
    seteInitialLocation();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialLocaton = CameraPosition(
        zoom: CAMERA_ZOOM,
        bearing: CAMERA_BEARING,
        tilt: CAMERA_TILT,
        target: SOURCE_LOCATION);

    if (currentLocation != null) {
      initialLocaton = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING
      );
    }

    return Scaffold(
        appBar: AppBar(title: Text('Myroute'),),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              myLocationEnabled: true,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              markers: _markers,
              polylines: _polylines,
              mapType: MapType.normal,
              initialCameraPosition: initialLocaton,
              onMapCreated: (GoogleMapController controller) {
                onMapCreated(controller);
                showPinsOnMap();
              }
            ),
            
          ],
        ),
    );
  }

  void setSourceAndDestinationIcons() async {
    // sourceIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'assets/images/pin.jpg');
    // destinationIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'assets/images/pindest.jpg');
    sourceIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    destinationIcon =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
  }

  void onMapCreated(GoogleMapController controller) {
    try {
      _controller.complete(controller);
    } catch (e) {
    }
    
   // setMapPins();
    //  setPolylines();


  }

  void setPolylines() async {
    List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
        googleAPIKey,
        SOURCE_LOCATION.latitude,
        SOURCE_LOCATION.longitude,
        DEST_LOCATION.latitude,
        DEST_LOCATION.longitude);

    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      Polyline polyline = Polyline(
          polylineId: PolylineId('poly'),
          color: Colors.blue,
          points: polylineCoordinates);
      _polylines.add(polyline);
    });
  }

  void setMapPins() {
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: SOURCE_LOCATION,
        icon: sourceIcon));
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: DEST_LOCATION,
        icon: destinationIcon));
  }

  void updatePinOnMap() async {
    // CameraPosition cPosition = CameraPosition(
    //   target: LatLng(currentLocation.latitude, currentLocation.longitude),
    //   zoom: CAMERA_ZOOM,
    //   bearing: CAMERA_BEARING,
    //   tilt: CAMERA_TILT
    // );

    // final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // // setState(() {
    // //   var pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
    //   // _markers.removeWhere((m)=> m.markerId=='sourcePin');
    //   // _markers.add(Marker(markerId: MarkerId('sourcePin'), position: pinPosition, icon: sourceIcon));
    // });
  }

  void seteInitialLocation() async {
    currentLocation = await location.getLocation();
  }

  void showPinsOnMap() {
    if (currentLocation != null) {
      var pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
      _markers.add(Marker(markerId: MarkerId('sourcePin'), position: pinPosition, icon: sourceIcon));
    }
    
    // var destLocation = LatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude);
    // _markers.add(Marker(markerId: MarkerId('destPin'), position: destLocation, icon: destinationIcon));

    // setPolylines();

  }
}
