import 'dart:io';

import 'package:video_compress/video_compress.dart';

class VideoCompressApi {
  // ignore: missing_return
  static Future<MediaInfo> compressVideo(File file) async {
    try {
      await VideoCompress.setLogLevel(0);

      return VideoCompress.compressVideo(file.path,
          quality: VideoQuality.LowQuality,
          includeAudio: true,
          deleteOrigin: false);
    } catch (e) {
      VideoCompress.cancelCompression();
    }
  }
}
