import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytodo/api/video_compress_api.dart';
import 'package:mytodo/widgets/app_drawer.dart';
import 'package:video_compress/video_compress.dart';
import 'button_widget.dart';
import 'progress_dialog_widget.dart';

class VideoCompres extends StatefulWidget {
  static const routeName = "/VideoCompression";
  const VideoCompres({Key key}) : super(key: key);

  @override
  _VideoCompresState createState() => _VideoCompresState();
}

class _VideoCompresState extends State<VideoCompres> {
  File fileVideo;
  Uint8List thumbnailBytes;
  int videoSize;
  MediaInfo compressedVideoInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Compress'),
        centerTitle: true,
        actions: [
          TextButton(
              style: TextButton.styleFrom(primary: Colors.white),
              onPressed: clearSelection,
              child: Text('Clear'))
        ],
      ),
      drawer: AppDrawer(),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(40),
        child: buildContent(),
      ),
    );
  }

  Widget buildContent() {
    if (fileVideo == null) {
      return ButtonWidget(
        text: 'Pick Video',
        onClicked: pickVideo,
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildThumbnail(),
          SizedBox(
            height: 24,
          ),
          buildVideoInfo(),
          SizedBox(
            height: 24,
          ),
          buildVideoCompressedInfo(),
          SizedBox(
            height: 24,
          ),
          ButtonWidget(
            text: 'Compress Video',
            onClicked: compressVideo,
          )
        ],
      );
    }
  }

  Widget buildVideoCompressedInfo() {
    if (compressedVideoInfo == null) return Container();
    final size = compressedVideoInfo.filesize / 10000;
    return Column(
      children: [
        Text(
          'Compressed Video Info',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Size; $size KB',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          '${compressedVideoInfo.path}',
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Widget buildThumbnail() => thumbnailBytes == null
      ? CircularProgressIndicator()
      : Image.memory(
          thumbnailBytes,
          height: 100,
        );

  Widget buildVideoInfo() {
    if (videoSize == null) return Container();
    final size = videoSize / 1000;
    return Column(
      children: [
        Text(
          "Original Video Info",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Size: $size KB',
          style: TextStyle(fontSize: 20),
        )
      ],
    );
  }

  Future pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);
    if (pickedFile == null) return;
    final file = File(pickedFile.path);

    setState(() => fileVideo = file);

    generateThumb(fileVideo);
    getVideoSize(fileVideo);
  }

  Future generateThumb(File file) async {
    final thumbnailBytes = await VideoCompress.getByteThumbnail(file.path);
    setState(() => this.thumbnailBytes = thumbnailBytes);
  }

  Future getVideoSize(File file) async {
    final size = await file.length();

    setState(() => videoSize = size);
  }

  Future compressVideo() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(child: ProgressDialogWidet()));

    final info = await VideoCompressApi.compressVideo(fileVideo);

    setState(() => compressedVideoInfo = info);
    Navigator.of(context).pop();
  }

  void clearSelection() {
    setState(() {
      compressedVideoInfo = null;
      fileVideo = null;
    });
  }
}
