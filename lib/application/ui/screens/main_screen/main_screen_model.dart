import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:senly/application/domain/entity/app_lat_long.dart';
import 'package:senly/application/domain/services/auth_service.dart';
import 'package:senly/application/domain/services/location_service.dart';
import 'package:senly/application/domain/services/mqtt_service.dart';
import 'package:senly/application/domain/services/user_service.dart';
import 'package:senly/application/ui/themes/app_colors.dart';
import 'package:senly/resourses/images.dart';
import 'package:senly/resourses/svgs.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MainScreenModel extends ChangeNotifier {
  var _currentTabIndex = AppSvg.planet;
  String get currentTabIndex => _currentTabIndex;

  final _mapControllerCompleter = Completer<YandexMapController>();
  Completer<YandexMapController> get mapControllerCompleter =>
      _mapControllerCompleter;

  YandexMapController? _mapController;
  List<MapObject> _mapObjects = [];
  List<MapObject> get mapObjects => _mapObjects;

  Timer? _locationTimer;

  final _locationService = LocationService();

  final List<StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>>
      _subcriptions = [];

  // late final StreamSubscription<List<MqttReceivedMessage<MqttMessage>>> _sub;

  MainScreenModel() {
    _initialize();
  }

  void _initialize() async {
    _initPermission().ignore();
    Future.delayed(const Duration(seconds: 2), () {
      for (final uid in UserService.user!.subscribedUsers) {
        final newSub = MQTTService.instance.subscribe('senly/location/$uid');
        _subcriptions.add(newSub);
        _subcriptions[_subcriptions.indexOf(newSub)].onData((data) {
          final uid = data[0].topic.split('/')[2];
          final recMess = data[0].payload as MqttPublishMessage;
          final locationData =
              MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
          final locationJson = jsonDecode(locationData) as Map<String, dynamic>;

          final newLocation = AppLatLong(
            lat: locationJson['latitude'],
            long: locationJson['longitude'],
          );
          updateMarkerLocation(uid, newLocation);
        });
      }
    });

    if (await _locationService.checkPermission()) {
      _startLocationUpdates(); // Запуск таймера для регулярной отправки данных
    }
  }

  @override
  void dispose() {
    _locationTimer?.cancel(); // Отмена таймера при удалении модели
    super.dispose();
  }

  void _startLocationUpdates() {
    const locationUpdateInterval = Duration(seconds: 10); // Интервал обновления

    _locationTimer = Timer.periodic(locationUpdateInterval, (_) async {
      final location = await _locationService.getCurrentLocation();
      _publishLocation(location);
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
    await _moveToCurrentLocation(location);
    // await _moveToCurrentLocation1(location);
    _publishLocation(location);
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

  Future<void> _moveToCurrentLocation1(
    String uid,
    AppLatLong appLatLong,
  ) async {
    _mapController = await mapControllerCompleter.future;

    final point = Point(latitude: appLatLong.lat, longitude: appLatLong.long);
    Uint8List imageInBytes =
        (await NetworkAssetBundle(Uri.parse(AuthService().user!.photoURL!))
                .load(AuthService().user!.photoURL!))
            .buffer
            .asUint8List();

    final placemark = PlacemarkMapObject(
      mapId: MapObjectId('userId:$uid'),
      point: point,
      text: PlacemarkText(
        text: uid,
        style: const PlacemarkTextStyle(
          color: AppColors.main,
        ),
      ),
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          image: BitmapDescriptor.fromBytes(imageInBytes),
          zIndex: 1,
          // Установите размер и другие стили, если нужно
        ),
      ),
    );

    _mapObjects.clear();
    _mapObjects = [..._mapObjects, placemark];
    notifyListeners();

    // _mapController!.updateMapObjects(_mapObjects);
    _mapController!.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: point, zoom: 12),
      ),
    );
  }

  void updateMarkerLocation(String uid, AppLatLong newLocation) async {
    final newPoint =
        Point(latitude: newLocation.lat, longitude: newLocation.long);

    final user = await UserService.getUserInfoFromFirestore(uid);

    Uint8List? imageInBytes;
    if (user!.imageUrl != null) {
      final bundle = await NetworkAssetBundle(Uri.parse(user.imageUrl!))
          .load(user.imageUrl!);
      imageInBytes = bundle.buffer.asUint8List();
    }

    final PlacemarkMapObject placemark = _mapObjects.firstWhere(
        (element) => element.mapId == MapObjectId('userId:$uid'), orElse: () {
      final placemark = PlacemarkMapObject(
        mapId: MapObjectId('userId:$uid'),
        text: PlacemarkText(
          text: uid,
          style: const PlacemarkTextStyle(
            color: AppColors.main,
          ),
        ),
        point: newPoint,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: imageInBytes != null
                ? BitmapDescriptor.fromBytes(imageInBytes)
                : BitmapDescriptor.fromAssetImage(Images.crown),
            zIndex: 1,
            // Установите размер и другие стили, если нужно
          ),
        ),
      );
      return placemark;
    }) as PlacemarkMapObject;

    final updatedPlacemark = placemark.copyWith(point: newPoint);

    final index = _mapObjects.indexOf(placemark);
    if (index != -1) {
      _mapObjects.removeAt(index);

      // _mapObjects[_mapObjects.indexOf(placemark)] = updatedPlacemark;
    } else {
      // _mapObjects.add(updatedPlacemark);
    }
    // _mapObjects = [..._mapObjects];
    _mapObjects = [..._mapObjects, updatedPlacemark];

    notifyListeners();
  }

  void _publishLocation(AppLatLong appLatLong) {
    final locationData = {
      'latitude': appLatLong.lat,
      'longitude': appLatLong.long
    };

    final locationJson = jsonEncode(locationData); // Преобразование в JSON
    MQTTService.instance.publish(
      'senly/location/${AuthService().user!.uid}',
      locationJson,
    );
  }

  void setCurrentTabIndex(BuildContext context, String iconString) {
    _currentTabIndex = iconString;
    notifyListeners();
  }
}
