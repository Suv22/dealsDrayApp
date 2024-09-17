abstract class DeviceInfoState{

}

class IntiateDeviceInfoState extends DeviceInfoState{}

class FetchedDeviceInfoState extends DeviceInfoState{
   final Map<String, dynamic> deviceData;

  FetchedDeviceInfoState(this.deviceData);
}

class FetchedDeviceInfoErrorState extends DeviceInfoState {
  final String message;

  FetchedDeviceInfoErrorState(this.message);
}