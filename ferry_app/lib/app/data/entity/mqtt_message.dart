import 'package:mqtt_client/mqtt_client.dart' as mqtt;

class FerryMqttMessage {
  final String topic;
  final String message;
  final mqtt.MqttQos qos;

  FerryMqttMessage({this.topic, this.message, this.qos});
}
