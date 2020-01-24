import 'dart:async';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


const double CAMERA_ZOOM = 10;
const double CAMERA_TILT = 90;
const double CAMERA_BEARING = 90;
const LatLng SOURCE_LOCATION = LatLng(52.198412, 20.858001);
const LatLng DEST_LOCATION = LatLng(52.194507, 21.013195);


class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers={};
  Set<Polyline> _polylines={};
  List<LatLng> polylineCoordinates =[];
  PolylinePoints polylinePoints = PolylinePoints();

  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  String googleAPIKey = 'AIzaSyDPmUS4c0pzu_o-zFamwJWKViivjVeGqrM';

@override
void initState() { 
  super.initState();
  setSourceAndDestinationIcons();
  
}


  @override
  Widget build(BuildContext context) {
    CameraPosition initialLocaton = CameraPosition(
      zoom: CAMERA_ZOOM,
      bearing: CAMERA_BEARING,
      tilt: CAMERA_TILT,
      target: SOURCE_LOCATION
      );
    return GoogleMap(
      myLocationEnabled: true,
      compassEnabled: true,
      tiltGesturesEnabled: false,
      markers: _markers,
      polylines: _polylines,
      mapType: MapType.normal,
      initialCameraPosition: initialLocaton,
      onMapCreated: onMapCreated,
    );
  }

  void setSourceAndDestinationIcons() async {
   // sourceIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'assets/images/pin.jpg');
   // destinationIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'assets/images/pindest.jpg');
  sourceIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  destinationIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);

  }

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setMapPins();
    setPolylines();
  }

  void setPolylines() async {
    List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
      googleAPIKey, 
      SOURCE_LOCATION.latitude, SOURCE_LOCATION.longitude, 
      DEST_LOCATION.latitude , DEST_LOCATION.longitude);

      if (result.isNotEmpty) {
        result.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }
      setState(() {
        Polyline polyline = Polyline(
          polylineId: PolylineId('poly'),
          color: Colors.blue,
          points: polylineCoordinates
        );
        _polylines.add(polyline);
      });

  }

  void setMapPins() {
    _markers.add(Marker(markerId: MarkerId('sourcePin'), position: SOURCE_LOCATION, icon: sourceIcon));
    _markers.add(Marker(markerId: MarkerId('destPin'), position: DEST_LOCATION, icon: destinationIcon));
  }
}