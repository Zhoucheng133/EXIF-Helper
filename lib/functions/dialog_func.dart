import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

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

void showAbout(BuildContext context, String version){
  showDialog(
    context: context, 
    builder: (context)=>AlertDialog(
      title: Text('关于EXIF Helper', style: GoogleFonts.notoSansSc(),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 100,
              height: 100,
              child: Image.asset('assets/icon.png')
            ),
          ),
          Text(
            'EXIF Helper', 
            style: GoogleFonts.notoSansSc(
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),
          ),
          const SizedBox(height: 10,),
          Text(
            "v$version",
            style: GoogleFonts.notoSansSc(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 15,),
          GestureDetector(
            onTap: () async {
              final Uri url = Uri.parse('https://github.com/Zhoucheng133/EXIF-Helper');
              await launchUrl(url);
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.github,
                    size: 15,
                  ),
                  const SizedBox(width: 5,),
                  Text(
                    '本项目地址',
                    style:  GoogleFonts.notoSansSc(),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10,),
          GestureDetector(
            onTap: () => showLicensePage(
              applicationName: 'EXIF Helper',
              applicationVersion: 'v$version',
              context: context
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.certificate,
                    size: 15,
                  ),
                  const SizedBox(width: 5,),
                  Text(
                    '许可证',
                    style:  GoogleFonts.notoSansSc(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      actions: [
        ElevatedButton(
          child: Text('好的', style: GoogleFonts.notoSansSc(),), 
          onPressed: (){
            Navigator.pop(context);
          }
        )
      ],
    )
  );
}