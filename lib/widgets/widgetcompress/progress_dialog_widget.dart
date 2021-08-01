import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';

class ProgressDialogWidet extends StatefulWidget {
  const ProgressDialogWidet({Key key}) : super(key: key);

  @override
  _ProgressDialogWidetState createState() => _ProgressDialogWidetState();
}

class _ProgressDialogWidetState extends State<ProgressDialogWidet> {
  Subscription subscription;
  double progress;

  @override
  void initState() {
    subscription = VideoCompress.compressProgress$
        .subscribe((progress) => setState(() => this.progress = progress));
    super.initState();
  }

  @override
  void dispose() {
    VideoCompress.cancelCompression();
    subscription.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = progress == null ? progress : progress / 100;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Compressing Video ...',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 24,
          ),
          LinearProgressIndicator(
            value: value,
            minHeight: 12,
          ),
          SizedBox(
            height: 16,
          ),
          ElevatedButton(
              onPressed: () => VideoCompress.cancelCompression(),
              child: Text('Cancel'))
        ],
      ),
    );
  }
}
