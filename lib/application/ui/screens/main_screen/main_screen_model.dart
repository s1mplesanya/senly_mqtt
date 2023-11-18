import 'dart:async';
import 'package:flutter/material.dart';
import 'package:senly/application/domain/entity/app_lat_long.dart';
import 'package:senly/application/domain/services/location_service.dart';
import 'package:senly/application/domain/services/mqtt_service.dart';
import 'package:senly/resourses/svgs.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MainScreenModel extends ChangeNotifier {
  var _currentTabIndex = AppSvg.planet;
  String get currentTabIndex => _currentTabIndex;

  final _mapControllerCompleter = Completer<YandexMapController>();
  Completer<YandexMapController> get mapControllerCompleter =>
      _mapControllerCompleter;

  final _locationService = LocationService();

  MainScreenModel() {
    _initialize();
  }

  void _initialize() async {
    _initPermission().ignore();
    Future.delayed(const Duration(seconds: 10), () {
      MQTTService.instance.subscribe('test/mqtt');
      MQTTService.instance.publish('test/mqtt', 'HELLOO YES WORK WORK!');
    });
  }

  Future<void> _initPermission() async {
    if (!await _locationService.checkPermission()) {
      await _locationService.requestPermission();
    }
    await _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    const defLocation = NovopolotskLocation();
    try {
      location = await _locationService.getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }
    _moveToCurrentLocation(location);
  }

  Future<void> _moveToCurrentLocation(
    AppLatLong appLatLong,
  ) async {
    (await mapControllerCompleter.future).moveCamera(
      animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: appLatLong.lat,
            longitude: appLatLong.long,
          ),
          zoom: 12,
        ),
      ),
    );
  }

  void setCurrentTabIndex(String iconString) {
    _currentTabIndex = iconString;
    notifyListeners();
  }
}
