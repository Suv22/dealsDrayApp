abstract class DeviceInfoEvent {

}

class PostDeviceInfoEvent extends DeviceInfoEvent{
  final Map<String, dynamic> deviceData;

  PostDeviceInfoEvent(this.deviceData);
}