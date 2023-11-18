import 'package:senly/application/domain/services/mqtt_service.dart';
import 'package:senly/application/ui/my_app/my_app.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  await MQTTService.instance.connect();
}
