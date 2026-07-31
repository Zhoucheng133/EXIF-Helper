import 'package:exif_helper/controllers/image_controller.dart';
import 'package:exif_helper/functions/cals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class FractionTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String value = newValue.text;

    if (value.isEmpty) {
      return newValue;
    }

    // 不允许以 "/" 开头
    if (value == '/') {
      return oldValue;
    }

    // 只允许数字,且最多一个 "/"
    final regex = RegExp(r'^\d*/?\d*$');

    if (!regex.hasMatch(value)) {
      return oldValue;
    }

    return newValue;
  }
}

class EditItem extends StatefulWidget {

  final ValueChanged onChanged;
  final String keyWord;
  final String initValue;
  final String? preLabel;
  final String? endLabel;
  final double? width;
  final bool? numberOnly;
  final bool? exposureTime;

  const EditItem({super.key, required this.onChanged, required this.keyWord, required this.initValue, this.preLabel, this.endLabel, this.width, this.numberOnly, this.exposureTime});

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          Text(
            widget.keyWord,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness==Brightness.dark ? Colors.white : Colors.black
            ),
          ),
          Row(
            spacing: 5,
            children: [
              if(widget.preLabel != null) Text(
                widget.preLabel!,
              ),
              if(widget.width==null) Expanded(
                child: TextField(
                  controller: TextEditingController(text: widget.initValue),
                  onChanged: widget.onChanged,
                  decoration: InputDecoration(
                    hintText: widget.keyWord,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  ),
                  keyboardType: widget.numberOnly==true ? TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
                  inputFormatters: widget.numberOnly==true ? [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                  ] : widget.exposureTime==true ? [
                    FractionTextInputFormatter(),
                  ] : null,
                ),
              ),
              if(widget.width!=null) SizedBox(
                width: widget.width!,
                child: TextField(
                  controller: TextEditingController(text: widget.initValue),
                  onChanged: widget.onChanged,
                  decoration: InputDecoration(
                    hintText: widget.keyWord,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  ),
                  keyboardType: widget.numberOnly==true ? TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
                  inputFormatters: widget.numberOnly==true ? [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                  ] : widget.exposureTime==true ? [
                    FractionTextInputFormatter(),
                  ] : null,
                ),
              ),
              if(widget.endLabel != null) Text(
                widget.endLabel!,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class EditTime extends StatefulWidget {
  const EditTime({super.key});

  @override
  State<EditTime> createState() => _EditTimeState();
}

class _EditTimeState extends State<EditTime> {

  final ImageController imageController = Get.find();

  Future<DateTime?> pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    return picked;
  }

  Future<TimeOfDay?> pickTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return picked;
  }

  String formatDateTime(DateTime dt) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    return '${dt.year}:${twoDigits(dt.month)}:${twoDigits(dt.day)} '
          '${twoDigits(dt.hour)}:${twoDigits(dt.minute)}:${twoDigits(dt.second)}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          Text(
            "captureTime".tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness==Brightness.dark ? Colors.white : Colors.black
            ),
          ),
          TextButton(
            onPressed: () async {
              final date = await pickDate(context);
              if (date == null) return;

              if(context.mounted){
                final time = await pickTime(context);
                if (time == null) return;

                final fullDateTime = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                );

                imageController.exifData.value!.captureTime = formatDateTime(fullDateTime);
                imageController.exifData.refresh();
              }

            }, 
            child: Text(calDatatime(imageController.exifData.value!.captureTime))
          )
        ],
      ),
    );
  }
}