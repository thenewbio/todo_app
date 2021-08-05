import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mytodo/widgets/app_drawer.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class Tables extends StatelessWidget {
  static const routeName = "/tables";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Table"),
      ),
      drawer: AppDrawer(),
      body: Center(
        child:
            ElevatedButton(onPressed: createExcel, child: Text('Create excel')),
      ),
    );
  }

  Future<void> createExcel() async {
    final Workbook workbook = Workbook();
    // final Worksheet sheet = workbook.worksheets[0];
    // sheet.getRangeByName('A1').setText('Hello world');
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/Output.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }
}
