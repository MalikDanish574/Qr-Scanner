import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/colors.dart';

class QrCodeGenerator extends StatefulWidget {
  @override
  State<QrCodeGenerator> createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cyan,
        title: Center(
          child: Text("QR Code Generaator"),
        ),
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: white,
            )),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.h,
              ),
              QrImage(
                data: _controller.text,
                size: min(300.w, 300.h),
                backgroundColor: white,
              ),
              SizedBox(
                height: 40.h,
              ),
              _buildtextfield(context),
              SizedBox(
                height: 40.h,
              ),
              InkWell(
                onTap: () {
                 _share(_controller.text);
                 print("after share");
                },
                child: Container(
                  height: 60.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r), color: cyan),
                  child: Center(
                    child: Text(
                      "Share",
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildtextfield(context) {
    return Container(
      height: 59.h,
      width: 381.w,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: _controller,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide(color: cyan)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide(color: cyan)),
            suffixIcon: IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
              },
              icon: Icon(
                Icons.done,
                size: 30.sp,
              ),
              color: cyan,
            ),
            hintText: "Enter Data",
            hintStyle: TextStyle(
                color: black, fontWeight: FontWeight.w500, fontSize: 20.sp)),
        style: TextStyle(
            color: black, fontWeight: FontWeight.w500, fontSize: 20.sp),
      ),
    );
  }

  _qrCode(String _txt) async {
    final _qrValidatorResult = QrValidator.validate(
        data: _txt,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.L);

    _qrValidatorResult.status = QrValidationStatus.valid;
    final _qrcode = _qrValidatorResult.qrCode;
    final painter = QrPainter.withQr(
        qr: _qrcode!,
        color: white,
        embeddedImage: null,
        emptyColor: black,
        gapless: true);

    Directory _tempDir = await getTemporaryDirectory();

    String _tempPath = _tempDir.path;

    final time = DateTime.now().microsecondsSinceEpoch.toString();

    String _finalPath = "$_tempPath/$time.png";

    final picData =
        await painter.toImageData(2048, format: ImageByteFormat.png);
    await writeTofile(picData!, _finalPath);
    return _finalPath;
  }

  Future<String?> writeTofile(ByteData data, String path) async {
    final buffer = data.buffer;

    await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
  _share (String path)async{
    String _filePath=await _qrCode(path);
    await Share.shareFiles([_filePath],mimeTypes: ["images/png"],subject: "My QR Code",text: "Please Scan Me");
  }
}
