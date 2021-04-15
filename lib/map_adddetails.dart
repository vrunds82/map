import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map/global.dart';

class MapAddDetails extends StatefulWidget {
  @override
  _MapAddDetailsState createState() => _MapAddDetailsState();
}

class _MapAddDetailsState extends State<MapAddDetails> {
  Completer<GoogleMapController> _controller = Completer();

  static TextEditingController title = TextEditingController();
  static TextEditingController dicription = TextEditingController();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  File file;
  final picker = ImagePicker();

  UploadImage() async {
    final imagePicker = ImagePicker();
    PickedFile image;
    image = await imagePicker.getImage(source: ImageSource.gallery);
    file = File(image.path);
    setState(() {});
  }

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              file == null
                  ? Container(
                      height: 200,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
                  : Container(
                      height: 200,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.file(
                        file,
                      )),
              GestureDetector(
                  onTap: () {
                    UploadImage();
                    setState(() {});
                  },
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.green,
                  )),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: title,
                decoration: InputDecoration(hintText: "Title"),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: dicription,
                maxLines: 6,
                decoration: InputDecoration(hintText: "Discription"),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 500,
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  myLocationEnabled: true,
                  onMapCreated: onMapCreated,
                  markers: _markers,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            Global.title = title.text.toString();
                            Global.disc = dicription.text.toString();
                            Global.uploadedimag = file;
                            Navigator.of(context).pushNamed("GetDetail");
                          },
                          child: Text("Submit"))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GetDetail extends StatefulWidget {
  @override
  _GetDetailState createState() => _GetDetailState();
}

class _GetDetailState extends State<GetDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Global.uploadedimag == null
                ? Container(
                    height: 200,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )
                : Container(
                    height: 200,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.file(
                      Global.uploadedimag,
                    )),
            Text(Global.title),
            Text(Global.disc),
            Text(Global.location.toString())
          ],
        ),
      ),
    );
  }
}
