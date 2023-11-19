import 'package:firebase_core/firebase_core.dart';
import 'package:senly/application/domain/services/mqtt_service.dart';
import 'package:senly/application/ui/my_app/my_app.dart';
import 'package:flutter/material.dart';
import 'package:senly/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await MQTTService.instance.connect();
  runApp(const MyApp());
}
