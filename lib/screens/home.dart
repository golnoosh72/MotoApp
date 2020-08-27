import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:MotoApp/widgets/app_drawer.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoder/geocoder.dart';

//AIzaSyBGMB0DpjqiefAJZX19XXD5rbfK51oSrDY
const kGoogleApiKey = "AIzaSyAE18a_cInt71TXUYq2YgXR0SvAyvBSOcI";

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  LatLng myLocation;
  List<Marker> _markers = [
    Marker(
      width: 60.0,
      height: 60.0,
      point: LatLng(51.32, -0.083),
      builder: (ctx) => Container(
        child: Image.asset(
          "assets/images/bike.png",
          width: 60.0,
          height: 60.0,
        ),
      ),
    )
  ];
  @override
  void initState() {
    super.initState();
    getMyLocation();
  }

  Future<void> getMyLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    myLocation = LatLng(position.latitude, position.longitude);
    this.setState(() {
      _markers.add(
        Marker(
          width: 60.0,
          height: 60.0,
          point: myLocation,
          builder: (ctx) => Container(
            child: Row(
              children: <Widget>[
                Container(
                  width: 30.0,
                  child: Icon(Icons.person_pin_circle),
                ),
                Container(
                  child: Text("Pick Up Here"),
                )
              ],
            ),
          ),
        ),
      );
    });
    print(position);
  }

  @override
  Widget build(BuildContext context) {
    Future<Null> displayPrediction(Prediction p) async {
      if (p != null) {
        PlacesDetailsResponse detail =
            await _places.getDetailsByPlaceId(p.placeId);

        var placeId = p.placeId;
        double lat = detail.result.geometry.location.lat;
        double lng = detail.result.geometry.location.lng;

        var address =
            await Geocoder.local.findAddressesFromQuery(p.description);

        print(lat);
        print(lng);
      }
    }

    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      drawer: AppDrawer(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height - 230.0,
                  // child: GoogleMap(
                  //   myLocationButtonEnabled: true,
                  //   myLocationEnabled: true,
                  //   markers: _markers,
                  //   onMapCreated: _onMapCreated,
                  //   initialCameraPosition: CameraPosition(
                  //     target: _center,
                  //     zoom: 11.0,
                  //   ),
                  // ),
                  child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(51.3, -0.08),
                      zoom: 13.0,
                    ),
                    layers: [
                      TileLayerOptions(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                            "https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayerOptions(markers: _markers)
                    ],
                  ),
                ),
                Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: Icon(
                        Icons.menu,
                        size: 35.0,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(),
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(
                        0,
                        0,
                        0,
                        0.15,
                      ),
                      blurRadius: 25.0,
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "Where are you going to ?",
                      style: _theme.textTheme.title,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        Prediction p = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: kGoogleApiKey,
                            mode: Mode.overlay, // Mode.fullscreen overlay
                            language: "en",
                            components: [
                              new Component(Component.country, "ca")
                            ]);
                        displayPrediction(p);
                      },
                      child: Text('Enter Destination'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
