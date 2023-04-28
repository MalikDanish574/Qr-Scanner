import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code/screens/qrCodeGenerator.dart';
import 'package:qr_code/screens/qrCodeScanner.dart';

import '../utils/colors.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cyan,
        title: Center(
          child: Text(
            "QR Code Generator Or Scanner"
          ),

        ),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
            SizedBox(
              height: 300.h,
            ),

              InkWell(
                onTap: () {
                  Get.to(()=>QrCodeScanner());
                },
                child: Container(
                  height: 60.h,
                  width: 300.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: cyan
                  ),
                  child: Center(
                    child: Text(
                      "Scan QR Code",style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: white
                      ),
                    ),
                  ),
                ),
              ),
               SizedBox(
              height: 30.h,
            ),
               InkWell(
                onTap: () {
                   Get.to(()=>QrCodeGenerator());
                },
                child: Container(
                  height: 60.h,
                  width: 300.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: cyan
                  ),
                  child: Center(
                    child: Text(
                      "Generate QR Code",style: TextStyle(
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
      ),
    );
  }
}