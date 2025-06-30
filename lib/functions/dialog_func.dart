import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
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

Future<void> showAbout(BuildContext context) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final version=packageInfo.version;
  if(context.mounted){
    showDialog(
      context: context, 
      builder: (context)=>AlertDialog(
        title: Text('关于EXIF Helper'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 10,),
            Text(
              'netPlayer',
              style: GoogleFonts.notoSansSc(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 3,),
            Text(
              "v$version",
              style: GoogleFonts.notoSansSc(
                fontSize: 13,
                color: Colors.grey[400]
              ),
            ),
            const SizedBox(height: 20,),
            GestureDetector(
              onTap: () async {
                final Uri url = Uri.parse('https://github.com/Zhoucheng133/EXIF-Helper');
                await launchUrl(url);
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.github,
                      size: 15,
                    ),
                    const SizedBox(width: 5,),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        '本地项目地址',
                        style: GoogleFonts.notoSansSc(
                          fontSize: 13,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () => showLicensePage(
                applicationName: 'EXIF Helper',
                applicationVersion: 'v$version',
                context: context
              ),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.certificate,
                      size: 15,
                    ),
                    const SizedBox(width: 5,),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        '许可证',
                        style: GoogleFonts.notoSansSc(
                          fontSize: 13,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text('好的')
          )
        ],
      ),
    );
  }
}