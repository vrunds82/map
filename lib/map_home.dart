import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/global.dart';

class MapHome extends StatefulWidget {
  @override
  State<MapHome> createState() => MapHomeState();
}

class MapHomeState extends State<MapHome> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(23.033863, 72.585022),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Set<Marker> _markers = {};

  void onMapCreated(GoogleMapController controller) {
    _markers.add(
      Marker(
          markerId: MarkerId('id - 1'),
          position: LatLng(23.033863, 72.585022),
          icon: mapMarker),
    );
  }

  BitmapDescriptor mapMarker;

  setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/pin.png');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCustomMarker();
    GetCurentLoc();
  }

  GetCurentLoc() async {
 Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    Global.location = LatLng(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            onMapCreated: onMapCreated,
            markers: _markers,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('AddDetail');
                },
                child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.green),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }

/* Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }*/
}
