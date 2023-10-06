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
      '007eJxTYJg83ezMt6i9bDp7qr+anw75oiP8WMdHfeZkR9uLcTYTuk4qMBinmqYlWialJllYmpsYmKclpaYaGBkmppmZJxqYm5hYumznSm0IZGTYtFCBmZEBAkF8boaSosS8kozMjMS8dAYGAEAxIgE=',
      defaultValue:
          '007eJxTYJg83ezMt6i9bDp7qr+anw75oiP8WMdHfeZkR9uLcTYTuk4qMBinmqYlWialJllYmpsYmKclpaYaGBkmppmZJxqYm5hYumznSm0IZGTYtFCBmZEBAkF8boaSosS8kozMjMS8dAYGAEAxIgE=');
}

/// Your channel ID
String get channelId {
  // Allow pass a `channelId` as an environment variable with name `TEST_CHANNEL_ID` by using --dart-define
  return const String.fromEnvironment(
    'tranthihang',
    defaultValue: 'tranthihang',
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
