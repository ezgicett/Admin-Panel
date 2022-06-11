import 'package:bitirme_admin_panel/widgets/customized_widgets/pick_image.dart';
import 'package:flutter/material.dart';

Future<T?> showTextDialog<T>(
  BuildContext context, {
  required String slogan,
  required String slogan_value,
}) =>
    showDialog<T>(
      context: context,
      builder: (context) => TextDialogWidget(
        slogan: slogan,
        slogan_value: slogan_value,
      ),
    );

class TextDialogWidget extends StatefulWidget {
  final String slogan;
  final String slogan_value;

  const TextDialogWidget({
    Key? key,
    required this.slogan,
    required this.slogan_value,
  }) : super(key: key);

  @override
  _TextDialogWidgetState createState() => _TextDialogWidgetState();
}

class _TextDialogWidgetState extends State<TextDialogWidget> {
  late TextEditingController sloganController; //ikinci kontrol ekle.
  late TextEditingController imageController =
      TextEditingController(); //ikinci kontrol ekle.

  @override
  void initState() {
    super.initState();

    sloganController = TextEditingController(text: widget.slogan_value);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.slogan),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: sloganController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Image"),
            TextField(
              controller: imageController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            Expanded(child: PickImage(flag: false))
          ],
        ),
        actions: [
          ElevatedButton(
              child: Text('Done'),
              onPressed: () {
                sloganController.text;
                Navigator.of(context).pop(sloganController.text);
              })
        ],
      );
}
