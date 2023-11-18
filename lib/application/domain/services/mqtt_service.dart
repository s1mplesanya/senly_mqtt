import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  final mqtt.MqttServerClient _client =
      MqttServerClient('broker-cn.emqx.io', '1883');

  static final MQTTService instance = MQTTService._();

  MQTTService._();

  Future<bool> connect() async {
    _client.logging(on: false);
    _client.keepAlivePeriod = 60;
    _client.onDisconnected = onDisconnected;
    _client.onConnected = onConnected;
    _client.onSubscribed = onSubscribed;
    _client.pongCallback = pong;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('dart_client')
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    print('Client connecting....');
    _client.connectionMessage = connMess;

    try {
      await _client.connect();
    } on NoConnectionException catch (e) {
      print('Client exception: $e');
      _client.disconnect();
    } on SocketException catch (e) {
      print('Socket exception: $e');
      _client.disconnect();
    }

    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      print('Client connected');
    } else {
      print(
          'Client connection failed - disconnecting, status is ${_client.connectionStatus}');
      _client.disconnect();
    }
    return true;
  }

  void onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
  }

  void onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
    if (_client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('OnDisconnected callback is solicited, this is correct');
    }
    exit(-1);
  }

  void onConnected() {
    print('OnConnected client callback - Client connection was sucessful');
  }

  void pong() {
    print('Ping response client callback invoked');
  }

  void unsubscribe(String topic) {
    print('Unsubscribing');
    _client.unsubscribe(topic);
  }

  void subscribe(String topic) {
    _client.subscribe(topic, MqttQos.atMostOnce);
    _client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('Received message: topic is ${c[0].topic}, payload is $pt');
    });
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    print('Сообщение "$message" отправлено в топик "$topic"');
  }
}
