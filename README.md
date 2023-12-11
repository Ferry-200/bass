# BassPlayer
对 Bass 音频库的简单包装，方便在Dart & Flutter (Windows) 上使用基本的Bass Lib API。

#### 项目结构
- lib
  - bass_player.dart (以 Bass Lib 为基础的简单的Player实现)
  - bass.dart ( `ffigen` 生成的文件)
  - main.dart (测试应用)

#### Bass Lib Vertion: 2.4

#### 快速上手

要使用播放器，先创建 `BassPlayer` 实例。
``` Dart
var bassPlayer = BassPlayer();
```
`BassPlayer()` 会从.exe目录寻找 `bass.dll` 文件并初始化 `first real output device` 。

之后，设定要播放的文件。
``` Dart
bassPlayer.setSource(filePath);
```
`filePath` 是要播放的音乐文件的路径，包括后缀。测试过.flac, .mp3，其它的没测试过。

播放、暂停音乐，跳转到音乐的第几秒。
``` Dart
bassPlayer.start();
// or pause it.
// bassPlayer.pause();

// or seek to position in seconds.
// bassPlayer.seek(position);
```

获取音乐时长（秒）。
``` Dart
print(bassPlayer.length);
```

监听当前进度（秒）。
``` Dart
bassPlayer.positionStream.listen((event) {
    print(event!);
});
```

监听播放器状态。
``` Dart
bassPlayer.playerStateStream.listen((event) {
    print(event!);
});
```

释放音乐文件。
``` Dart
bassPlayer.freeFStream();
```

释放播放器和动态库资源。
``` Dart
bassPlayer.free();
```