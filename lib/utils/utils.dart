import 'package:device_info_plus/device_info_plus.dart';


abstract class DeviceInfoWrapper {
  Future<String> getDeviceName();
}


class DeviceInfoWrapperImpl implements DeviceInfoWrapper {
  @override
  Future<String> getDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();
    final info = await deviceInfo.deviceInfo;
    return info.data["name"] ?? "unknown";
  }
}

class DeviceService {
  final DeviceInfoWrapper deviceInfoWrapper;

  DeviceService(this.deviceInfoWrapper);

  Future<String> getDeviceInfo() {
    return deviceInfoWrapper.getDeviceName();
  }
}


String mapHttpErrorToUserMessage(String rawMessage, int statusCode) {
  if (statusCode == 400 && rawMessage.contains("email")) {
    return "メールアドレスの形式が正しくありません。";
  } else if (statusCode == 403 && rawMessage.contains("duplicate")) {
    return "このメールアドレスはすでに登録されています。";
  } else if (statusCode == 401) {
    return "認証に失敗しました。もう一度ログインしてください。";
  } else if (statusCode == 500) {
    return "サーバーでエラーが発生しました。時間を置いて再試行してください。";
  }
  return "エラーが発生しました。もう一度お試しください。";
}
