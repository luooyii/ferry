import 'dart:math';
import 'dart:async';
import 'package:ferry_app/app/data/entity/mqtt_message.dart';
import 'package:flutter/rendering.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import '../../../../common/uri.dart';

class FerryMqttClient {
  FerryMqttClient._();
  static final FerryMqttClient _instance = FerryMqttClient._();
  static FerryMqttClient getInstance() {
    return _instance;
  }

  mqtt.MqttClient client;
  mqtt.MqttConnectionState connectionState;
  StreamSubscription subscription;
  List<FerryMqttMessage> messages = <FerryMqttMessage>[];
  Set<String> topics = Set<String>();
  FerryMqttClient(this.client);

  void connect() async {
    /// First create a client, the client is constructed with a broker name, client identifier
    /// and port if needed. The client identifier (short ClientId) is an identifier of each MQTT
    /// client connecting to a MQTT broker. As the word identifier already suggests, it should be unique per broker.
    /// The broker uses it for identifying the client and the current state of the client. If you don’t need a state
    /// to be hold by the broker, in MQTT 3.1.1 you can set an empty ClientId, which results in a connection without any state.
    /// A condition is that clean session connect flag is true, otherwise the connection will be rejected.
    /// The client identifier can be a maximum length of 23 characters. If a port is not specified the standard port
    /// of 1883 is used.
    /// If you want to use websockets rather than TCP see below.
    client = mqtt.MqttClient(mqttBroker, '');

    /// A websocket URL must start with ws:// or wss:// or Dart will throw an exception, consult your websocket MQTT broker
    /// for details.
    /// To use websockets add the following lines -:
    // client.useWebSocket = true;

    /// This flag causes the mqtt client to use an alternate method to perform the WebSocket handshake. This is needed for certain
    /// matt clients (Particularly Amazon Web Services IOT) that will not tolerate additional message headers in their get request
    // client.useAlternateWebSocketImplementation = true;
    // client.port = 443; // ( or whatever your WS port is)
    /// Note do not set the secure flag if you are using wss, the secure flags is for TCP sockets only.

    /// Set logging on if needed, defaults to off
    client.logging(on: true);

    /// If you intend to use a keep alive value in your connect message that is not the default(60s)
    /// you must set it here
    client.keepAlivePeriod = 30;

    /// Add the unsolicited disconnection callback
    client.onDisconnected = _onDisconnected;

    /// Create a connection message to use or use the default one. The default one sets the
    /// client identifier, any supplied username/password, the default keepalive interval(60s)
    /// and clean session, an example of a specific one below.
    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId2')
        // Must agree with the keep alive set above or not set
        .startClean() // Non persistent session for testing
        .keepAliveFor(30)
        // If you set this you must set a will message
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .withWillQos(mqtt.MqttQos.atLeastOnce);
    print('MQTT client connecting....');
    client.connectionMessage = connMess;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
    /// never send malformed messages.
    try {
      await client.connect();
    } catch (e) {
      print(e);
      _disconnect();
    }

    /// Check if we are connected
    if (client.connectionState == mqtt.MqttConnectionState.connected) {
      connectionState = client.connectionState;
      debugPrint('MQTT已连接');
    } else {
      print('MQTT连接失败，状态为${client.connectionState}');
      _disconnect();
    }
  }

  void addSubscribeLisener(Function onMessage) {
    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.
    subscription = client.updates.listen(onMessage);
  }

  void _disconnect() {
    client.disconnect();
    _onDisconnected();
  }

  void _onConnected() {
    subscribeToTopic('edu/just/machinelearning/test/ship');
    subscribeToTopic('cn/luooyii/ferry/ship/position');
    subscribeToTopic('/adxl345');
  }

  void _onDisconnected() {
    subscription.cancel();
    subscription = null;
    print('MQTT断开连接');
  }

  void subscribeToTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      if (topics.add(topic.trim())) {
        print('订阅到 ${topic.trim()}');
        client.subscribe(topic, mqtt.MqttQos.exactlyOnce);
      }
    }
  }

  void unsubscribeFromTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      if (topics.remove(topic.trim())) {
        print('取消订阅${topic.trim()}');
        client.unsubscribe(topic);
      }
    }
  }
}
