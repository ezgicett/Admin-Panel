import 'dart:convert';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

String ba64 = "";

class PickImage extends StatefulWidget {
  bool flag;
  //String? ba64;

  PickImage({Key? key, required this.flag}) : super(key: key);
  @override
  State<PickImage> createState() => _PickImageState();

  String get getBase64 {
    return ba64;
  }
}

class _PickImageState extends State<PickImage> {
  String? imageUrl;
  XFile? image;

  @override
  void initState() {
    //widget.ba64 ="";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget.flag == true
            ? Image(image: XFileImage(image!))
            : Image.asset(
                "assets/images/no_image_available.png",
                width: 200,
                height: 200,
              ),
        Expanded(
          flex: 0,
          child: IconButton(
            icon: Icon(
              Icons.edit,
            ),
            iconSize: 25,
            color: Colors.green,
            splashColor: Colors.purple,
            onPressed: () {
              _getImagesPicker();
              widget.flag = true;
            },
          ),
        ),
      ],
    );
  }

  Future<void> _getImagesPicker() async {
    try {
      final _imagePath = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 100,
          maxHeight: 150,
          maxWidth: 150);

      final bytes = await _imagePath!.readAsBytes();
      String b64 = base64Encode(bytes);
      //print(b64);

      setState(() {
        image = _imagePath;
        ba64 = b64;
        //debugPrint(b64);
        //widget.ba64 = b64;
        //debugPrint(_imagePath.name.toString()); çıktısı: scaled_51099182445491.png
      });
    } catch (err) {
      print(err);
    }
  }
}
