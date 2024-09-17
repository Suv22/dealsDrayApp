import 'package:dealsdrayapp/api_repos/deviceinfo_repo.dart';
import 'package:dealsdrayapp/blocs/device_info_bloc/deviceinfo_event.dart';
import 'package:dealsdrayapp/blocs/device_info_bloc/deviceinfo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeviceInfoBloc extends Bloc<DeviceInfoEvent,DeviceInfoState>{
  final PostDeviceInfoRepo postDeviceInfoRepo;

  DeviceInfoBloc({required this.postDeviceInfoRepo}) : super(IntiateDeviceInfoState()) {
    on<PostDeviceInfoEvent>(postDeviceInfoEvent);
  }

  void postDeviceInfoEvent(PostDeviceInfoEvent event , Emitter<DeviceInfoState> emit)async{
    try {
      String message = await postDeviceInfoRepo.postData(event.deviceData);
      if (message == "Successfully Added") {
        print("Data Posted: $message");
      } else {
        emit(FetchedDeviceInfoErrorState(message));
      }
    } catch (e) {
      emit(FetchedDeviceInfoErrorState(e.toString()));
      print("Error while posting Device Data: $e");
    }
  }

}