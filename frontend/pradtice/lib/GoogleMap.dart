import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pradtice/location_permission.dart';

class MyGoogleMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _MapSample();
  }
}

class _MapSample extends StatefulWidget {
  @override
  State<_MapSample> createState() => _MapSampleState();
}

class _MapSampleState extends State<_MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Position? _currentPosition;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.5271883, 126.9659283),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() {
    Geolocator.getPositionStream(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high)).listen((Position position) {
      setState(() {
        _currentPosition = position;
        _updateMarker(position);
      });
    });
  }

  void _updateMarker(Position position) {
    _markers.clear(); // 기존 마커를 제거하고 새 위치에 마커를 추가합니다.
    _markers.add(
      Marker(
        markerId: MarkerId('currentPosition'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(
          title: '내 위치',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    _moveCameraToCurrentPosition();
  }

  Future<void> _moveCameraToCurrentPosition() async {
    if (_currentPosition != null) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 14.4746,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _getCurrentLocation,
        label: Text('내 위치 찾기'),
        icon: Icon(Icons.location_searching),
      ),
    );
  }
}
