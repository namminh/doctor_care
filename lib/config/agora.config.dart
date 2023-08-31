/// Get your own App ID at https://dashboard.agora.io/
String get appId {
  // Allow pass an `appId` as an environment variable with name `TEST_APP_ID` by using --dart-define
  return const String.fromEnvironment('3e5fa9beb897407fbee021af67a07449',
      defaultValue: '3e5fa9beb897407fbee021af67a07449');
}

/// Please refer to https://docs.agora.io/en/Agora%20Platform/token
String get token {
  // Allow pass a `token` as an environment variable with name `TEST_TOKEN` by using --dart-define
  return const String.fromEnvironment(
      '007eJxTYOhp+vTX/+4P9tOrVnaVi/EyC0f5XL7Cduhy+6zP91utauMVGIxTTdMSLZNSkywszU0MzNOSUlMNjAwT08zMEw3MTUwsbxh8SGkIZGRQ/vKWhZEBAkF8LoaS1OKS+MT0/KJEBgYAyOIkcQ==',
      defaultValue:
          '007eJxTYOhp+vTX/+4P9tOrVnaVi/EyC0f5XL7Cduhy+6zP91utauMVGIxTTdMSLZNSkywszU0MzNOSUlMNjAwT08zMEw3MTUwsbxh8SGkIZGRQ/vKWhZEBAkF8LoaS1OKS+MT0/KJEBgYAyOIkcQ==');
}

/// Your channel ID
String get channelId {
  // Allow pass a `channelId` as an environment variable with name `TEST_CHANNEL_ID` by using --dart-define
  return const String.fromEnvironment(
    'test_agora',
    defaultValue: 'test_agora',
  );
}

/// Your int user ID
const int uid = 0;

/// Your user ID for the screen sharing
const int screenSharingUid = 10;

/// Your string user ID
const String stringUid = '0';

String get musicCenterAppId {
  // Allow pass a `token` as an environment variable with name `TEST_TOKEN` by using --dart-define
  return const String.fromEnvironment('MUSIC_CENTER_APPID',
      defaultValue: '<MUSIC_CENTER_APPID>');
}
