import 'package:flutter/material.dart';

void warnDialog(BuildContext context, String title, String content){
  showDialog(
    context: context, 
    builder: (context)=>AlertDialog(
      title: const Text("导入图片错误"),
      content: const Text("不支持的格式"),
      actions: [
        ElevatedButton(
          onPressed: ()=>Navigator.pop(context), 
          child: const Text("好的")
        )
      ],
    )
  );
}