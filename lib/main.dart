import 'package:canvas_test_project/widgets/scale.dart';
import 'package:canvas_test_project/widgets/timeline/timeline_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl_standalone.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'widgets/timeline/timeline.dart';

final Map<int, Color> blackMap = {
  50  : Color(0x0f242424),
  100 : Color(0x55242424),
  200 : Color(0x5a242424),
  300 : Color(0x5f242424),
  400 : Color(0xa5242424),
  500 : Color(0xaa242424),
  600 : Color(0xaf242424),
  700 : Color(0xf5242424),
  800 : Color(0xfa242424),
  900 : Color(0xff242424),
};

const Color _black = Color(0xff242424);

final MaterialColor materialBlack = MaterialColor(0xff242424, blackMap);

Future<void> main() async {
  await initializeDateFormatting('ru_RU');
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (child, _) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: materialBlack
          ),
          home: const MainPage(),
        );
      },
    );
  }
}

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: DarkTheme.medium,
      appBar: AppBar(
        backgroundColor: DarkTheme.dark,
        title: Text(
          'Canvas Timeline Test',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: DarkTheme.white,
          ),
        ),

      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 24.h,
        ),
        shrinkWrap: true,
        children: [
          MaterialButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScaleTestPage(),
                ),
              );
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minWidth: 1.sw,
            height: 40.h,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            color: DarkTheme.light,
            padding: EdgeInsets.zero,
            child: Text(
              'Scale and Rotate',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: DarkTheme.white,
              ),
            ),
          ),
          12.verticalSpace,
          MaterialButton(
            onPressed: () {
              ref.invalidate(dayTimeNowProvider);
              ref.invalidate(itemCountProvider);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TimelinePage(),
                ),
              );
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minWidth: 1.sw,
            height: 40.h,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            color: DarkTheme.light,
            padding: EdgeInsets.zero,
            child: Text(
              'Timeline via Painter',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: DarkTheme.white,
              ),
            ),
          ),
        ],
      ),
      /*
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 24.h,
        ),
        child: CustomTimeline(
          children: <Widget>[
            _customBox(color: _black),
            _customBox(height: 70, color: _black),
            _customBox(height: 200, color: _black),
            _customBox(height: 100, color: _black),
            _customBox(color: _black),
            _customBox(height: 70, color: _black),
            _customBox(height: 200, color: _black),
            _customBox(height: 100, color: _black),
            _customBox(color: _black),
            _customBox(height: 70, color: _black),
            _customBox(height: 200, color: _black),
            _customBox(height: 100, color: _black),
          ],
          indicators: <Widget>[
            Icon(Icons.access_alarm),
            Icon(Icons.backup),
            Icon(Icons.accessibility_new),
            Icon(Icons.access_alarm),
            Icon(Icons.access_alarm),
            Icon(Icons.backup),
            Icon(Icons.accessibility_new),
            Icon(Icons.access_alarm),
            Icon(Icons.access_alarm),
            Icon(Icons.backup),
            Icon(Icons.accessibility_new),
            Icon(Icons.access_alarm),
          ],
        ),
      ),
      */
    );
  }

  Container _customBox({double? height = 100, Color? color = _black}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }
}
