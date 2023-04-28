import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code/utils/colors.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QrCodeScanner extends StatefulWidget{
  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  final GlobalKey _qrkey=GlobalKey(debugLabel: "QR");
  QRViewController? _controller;
  Barcode? result;
  @override
  Widget build(BuildContext context) {
    _controller?.pauseCamera();
    _controller?.resumeCamera();
   return Scaffold(
    appBar: AppBar(
      backgroundColor: cyan,
      title: Center(
        child: Text("QR Code Scanner"),

      ),
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(Icons.arrow_back_ios_new,color: white,)),
    ),
    body: Container(
      height: 926.h,
      width: 428.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
            Expanded(flex: 9, child: _buildQrView(context)),
            Expanded(flex: 1, child: Container(
              color: cyan,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: ()async {
                      await _controller?.toggleFlash();
                    },
                    child: Icon(Icons.flash_on,color: white,)),

                     InkWell(
                      onTap: ()async {
                      await _controller?.flipCamera();
                    },
                    child: Icon(Icons.flip_camera_ios,color: white,)),
                ],
              ),
            ))
        ],
      ),
    ),
   );
  }
// Creating a QR View
Widget _buildQrView(BuildContext context){
 
  var scanArea=300.w;

  return QRView(
    key: _qrkey,
     onQRViewCreated: onQRViewCreated,
     onPermissionSet: (ctrl,p)=>onPermission(context, ctrl, p),
     overlay: QrScannerOverlayShape(
      cutOutSize: scanArea,
      borderLength: 40.h,
      borderWidth:  10.w,
      borderRadius: 10.r,
      borderColor: cyan
     ),
     );
}

void onQRViewCreated(  QRViewController _qrController){
  try{
    setState(() {
      this._controller=_qrController;
    });

    _controller?.scannedDataStream.listen((event) {
      
      setState(() {
        result=event;
        _controller?.pauseCamera();
      });
      if(result!.code!=null){
        print("scanned and shoew result");
        _displayResult();
      }
    });
  }catch(error){
    throw(error);
  }

}
// Creating permission method
void onPermission(BuildContext context,QRViewController _ctrl,bool _permission){
  if(!_permission){
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No Permission"))
    );
  }
}

// Creating Result view

Widget _displayResult(){
   
   bool _validurl=Uri.parse(result!.code.toString()).isAbsolute;
  return Center(
    child: FutureBuilder<dynamic>(
      future: showDialog(context: context, builder: (context) {
        return WillPopScope(child: AlertDialog(
          title: Text("Scan Result",style: TextStyle(fontSize: 25.sp,fontWeight: FontWeight.bold),),
          content: SizedBox(
            height: 140.h,
            child: Column(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _validurl?SelectableText.rich(

                  TextSpan(
                    text: result!.code.toString(),
                    style: TextStyle(fontSize: 25.sp,fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()..onTap=() {
                      launchUrl(Uri.parse(result!.code.toString()));
                    }
                  ),
                ): Text(result!.code.toString(),style: TextStyle(fontSize: 25.sp,fontWeight: FontWeight.bold)),
                 SizedBox(
                  height: 25.h,
                 ),
                 InkWell(
                onTap: () {
                   Get.back();
                },
                child: Container(
                  height: 60.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: cyan
                  ),
                  child: Center(
                    child: Text(
                      "close",style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: white
                      ),
                    ),
                  ),
                ),
              ),
              ],
            ),

          ),
        ), onWillPop: ()async=>false);

      },),
      builder: (context,AsyncSnapshot<dynamic> snapshot) {
        throw UnimplementedError();
      },
      ),
  );
}


}