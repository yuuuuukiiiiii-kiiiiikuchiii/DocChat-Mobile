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

String mapHttpErrorToUserMessage(
  String rawMessage,
  int statusCode, {
  int? retryAfterSeconds,
}) {
  if (statusCode == 400 && rawMessage.contains("email")) {
    return "メールアドレスの形式が正しくありません。";
  } else if (statusCode == 403 && rawMessage.contains("duplicate")) {
    return "このメールアドレスはすでに登録されています。";
  } else if (statusCode == 403 &&
      rawMessage.contains("email is not verified")) {
    return 'メール認証が完了していません。登録時に送信された確認メールのリンクをクリックして認証を完了してください。';
  } else if (statusCode == 401) {
    return "認証に失敗しました。もう一度ログインしてください。";
  } else if (statusCode == 429) {
    // retryAfterSeconds が渡されていれば秒数を表示
    final wait = retryAfterSeconds ?? 60;
    return "短時間に複数回ログインが試行されたため、一時的にロックされています。\n$wait秒後に再試行してください。";
  } else if (statusCode == 500) {
    return "サーバーでエラーが発生しました。時間を置いて再試行してください。";
  }

  return "エラーが発生しました。もう一度お試しください。";
}
