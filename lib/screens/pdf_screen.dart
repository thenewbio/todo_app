import 'dart:io';

// import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:mytodo/widgets/app_drawer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pd;

class PDFScreen extends StatefulWidget {
  static const routeName = "/PDF";
  const PDFScreen({Key key}) : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  final picker = ImagePicker();
  final pdf = pd.Document();
  List<File> _image = [];
   List<Asset> _images = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Image to pdf'),
          actions: [
            IconButton(
                onPressed: () {
                  createPDF();
                  savePDF();
                },
                icon: Icon(Icons.folder_open)),
            IconButton(
                onPressed: getImageFromGallery,
                icon: Icon(Icons.image)),
            IconButton(
                onPressed: () {
                  createPDF();
                  savePDF();
                },
                icon: Icon(Icons.picture_as_pdf))
          ],
        ),
        drawer: AppDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: pickImages,
          child: Text(""),
        
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: _images != null
            ?  Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
            RaisedButton(
              child: Text("Pick images"),
              onPressed: pickImages,
            ),
            RaisedButton(
              child: Text("Pick images"),
              onPressed: pickImages,
            ),
            ],),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(_images.length, (index) {
                  Asset asset = _images[index];
                  return AssetThumb(
                    asset: asset,
                    width: 300,
                    height: 300,
                  );
                }),
              ),
            )
          ],
        )
            : Container());
  }

  void getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image.add(File(pickedFile.path));
      } else {
        print('No image selected');
      }
    });
  }

  createPDF() async {
    for (var img in _image) {
      final image = pd.MemoryImage(img.readAsBytesSync());
      

      pdf.addPage(pd.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pd.Context context) {
            return pd.Center(child: pd.Image(image));
          }));
    }
  }

  savePDF() async {
    try {
      final dir = await getExternalStorageDirectory();
      final file = File('${dir.path}/filaname.pdf');
      await file.writeAsBytes(await pdf.save());
      showPrintedMessage('success', 'saved to documents');
    } catch (e) {
      showPrintedMessage('error', e.toString());
    }
  }

  showPrintedMessage(String title, String msg) {
  //   Flushbar(
  //     title: title,
  //     message: msg,
  //     duration: Duration(seconds: 3),
  //     icon: Icon(
  //       Icons.info,
  //       color: Colors.purple,
  //     ),
  //   )..show(context);
  }

   @override
  void initState() {
    super.initState();
  }
 
  Future<void> pickImages() async {
    List<Asset> resultList = [];
 
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: _images,
        materialOptions: MaterialOptions(
          actionBarTitle: "FlutterCorner.com",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }
 
    setState(() {
      
      _images = resultList;
    });
  }
}
