const String ferryHost = 'http://132.232.22.168:8080';
const String mqttServer = 'test.mosquitto.org';
const String mqttTopic = 'test/lol';

const Map<String, String> apis = {
  'latest_topics': '$ferryHost/topics/latest.json',
  'hot_topics': '$ferryHost/topics/hot.json',
  'topic': '$ferryHost/topics/show.json'
};
