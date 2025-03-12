import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iov/model/vehicle_detail.dart';
import 'package:iov/utils/marker_license.dart';
import 'package:iov/widget/back_ios.dart';

class HomeDetailCCTVMapsPage extends StatefulWidget {
  const HomeDetailCCTVMapsPage({Key? key, required this.vehicleDetail})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final VehicleDetail vehicleDetail;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<HomeDetailCCTVMapsPage> {
  @override
  void initState() {
    var a = Marker(
      markerId: MarkerId(widget.vehicleDetail.info!.vid!.toString()),
      position: LatLng(
          widget.vehicleDetail.gps!.lat!, widget.vehicleDetail.gps!.lng!),
      onTap: () {},
      anchor: const Offset(0.5, 0.5),
      // infoWindow: InfoWindow(
      //     title: v!.info!.vehicle_name, anchor: Offset(0.5, 0.5)),
      // icon: getMapIcon(v!)!,
      icon: MarkerLicense.iconTest!,
    );
    markers.clear();
    markers.add(a);
    super.initState();
  }

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.white,
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToMe,
      //   label: Text('My location'),
      //   icon: Icon(Icons.near_me),
      // ),

      body: SafeArea(
        child: Column(
          children: [
            const BackIOS(),
            Expanded(
              child: GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                onMapCreated: (gController) {
                  // controller.complete(gController);
                },
                initialCameraPosition: CameraPosition(
                  zoom: 14,
                  target: LatLng(widget.vehicleDetail.gps!.lat!,
                      widget.vehicleDetail.gps!.lng!),
                ),
                markers: markers,
              ),
            )
          ],
        ),
      ),
    );
  }
}
