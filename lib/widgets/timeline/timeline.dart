import 'dart:developer';

import 'package:canvas_test_project/widgets/scale_rotate/scale.dart';
import 'package:canvas_test_project/widgets/timeline/timeline_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

final hoursProvider = StateProvider<int>((ref) {
  int minutesNow = DateTime.now().minute;
  int hoursNow = DateTime.now().hour;
  if(minutesNow <= 30) {
    minutesNow = 30;
  } else {
    minutesNow = 0;
    hoursNow = hoursNow + 1;
  }
  return hoursNow;
});

final minutesProvider = StateProvider<int>((ref) {
  int minutesNow = DateTime.now().minute;
  int hoursNow = DateTime.now().hour;
  if(minutesNow <= 30) {
    minutesNow = 30;
  } else {
    minutesNow = 0;
    hoursNow = hoursNow + 1;
  }
  return minutesNow;
});

final itemCountProvider = StateProvider<int>((ref) {
  final hoursNow = ref.watch(hoursProvider);
  final minutesNow = ref.watch(minutesProvider);
  int itemCount = hoursNow * 2 + 1;
  if(minutesNow == 30) itemCount + 1;
  return itemCount;
});
final daysProvider = StateProvider<int>((ref) => 0);

final dayTimeNowProvider = StateProvider<DateTime>((ref) => DateTime.now());

final scrollOffsetProvider = StateProvider<double>((ref) {
  return 0.0;
});

final scaleTimelimeProvider = StateProvider<double>((ref) => 1);
final fontScaleProvider = StateProvider<double>((ref) => 12);
final _scaleprovider = StateProvider<double>((ref) => 1);

///Example
final List<DateTime> eventsTimes = <DateTime>[
  DateTime.parse('2023-09-13 21:49:00.0'),
  DateTime.parse('2023-09-14 09:49:00.0'),
  DateTime.parse('2023-09-14 10:39:00.0'),
  DateTime.parse('2023-09-14 11:12:00.0'),
  DateTime.parse('2023-09-14 11:20:00.0'),
  DateTime.parse('2023-09-15 12:46:00.0'),
  DateTime.parse('2023-09-15 15:22:00.0'),
  DateTime.parse('2023-08-15 17:02:00.0'),

  DateTime.parse('2023-09-16 09:02:00.0'),
  DateTime.parse('2023-09-16 10:39:00.0'),
  DateTime.parse('2023-09-16 07:12:00.0'),
  DateTime.parse('2023-09-16 04:20:00.0'),
  DateTime.parse('2023-08-16 17:25:00.0'),

  DateTime.parse('2023-09-17 09:16:00.0'),
  DateTime.parse('2023-09-17 10:39:00.0'),
  DateTime.parse('2023-09-17 07:12:00.0'),
  DateTime.parse('2023-09-17 13:17:00.0'),
  DateTime.parse('2023-09-17 15:25:00.0'),
];

class CustomTimeline extends ConsumerWidget {
  CustomTimeline({
    Key? key,
    this.lineColor = DarkTheme.accent,
    this.shrinkWrap = true,
    this.indicatorColor = Colors.blue,
    this.indicatorStyle = PaintingStyle.fill,
    this.strokeCap = StrokeCap.round,
    this.strokeWidth = 1,
    this.style = PaintingStyle.stroke,
  })  : super(key: key);

  final bool shrinkWrap;
  final controller = ScrollController(initialScrollOffset: 0.0);

  final Color lineColor;
  final Color indicatorColor;
  final PaintingStyle indicatorStyle;
  final StrokeCap strokeCap;
  double strokeWidth;
  final PaintingStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollOffset = ref.watch(scrollOffsetProvider);
    final itemCount = ref.watch(itemCountProvider);
    final nowReal = ref.watch(dayTimeNowProvider);
    final scale = ref.watch(scaleTimelimeProvider);
    final fontScale = ref.watch(fontScaleProvider);

    final _scale = ref.watch(_scaleprovider);
    final _scaleTL = ref.watch(scaleTimelimeProvider);
    final _scaleF = ref.watch(fontScaleProvider);

    strokeWidth = scale.w;
    if(scale > 2) strokeWidth = 2.w;

    DateTime now = nowReal;
    if(now.minute > 30) {
      now = now.subtract(Duration(minutes: (now.minute - 30)));
    } else {
      now = now.subtract(Duration(minutes: (now.minute)));
    }


    return  NotificationListener<ScrollNotification>(
      onNotification: (scroll) {
        final offset = scroll.metrics.pixels;
        ref.read(scrollOffsetProvider.notifier).state = offset;

        print('OFFSET: $offset');
        return true;
      },
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (scrollEnd) {
          final metrics = scrollEnd.metrics;
          // Future.delayed(const Duration(microseconds: 100), () {
          //   ref.read(scrollOffsetProvider.notifier).state = false;
          // });
          if (metrics.atEdge &&
              metrics.pixels != 0 &&
              metrics.axisDirection == AxisDirection.down) {
            ref.read(itemCountProvider.notifier).state += 48;
          }
          return true;
        },
        child: SizedBox(
          width: 1.sw,
          child: Stack(
            children: [
              GestureDetector(
                onScaleEnd: (details) {
                  print(details.pointerCount);
                },
                onScaleUpdate: (details) {
                  double diff = 0;
                  if(details.scale > _scale) {
                    if(_scaleTL < 3) diff = 0.02;
                  } else {
                    if(_scaleTL > 1) diff = -0.02;
                  }

                  ref.read(scaleTimelimeProvider.notifier).state += diff;
                  ref.read(fontScaleProvider.notifier).state += (diff * 4);

                  if((_scaleTL) > 3) ref.read(scaleTimelimeProvider.notifier).state = 3.0;
                  if((_scaleTL) < 1) ref.read(scaleTimelimeProvider.notifier).state = 1.0;

                  if(_scaleF < 12) ref.read(fontScaleProvider.notifier).state = 12;
                  if(_scaleF > 18) ref.read(fontScaleProvider.notifier).state = 18;
                  ref.read(_scaleprovider.notifier).state = details.scale;
                },
                onDoubleTap: () {
                  print('OFFSET_PROVIDER_BEFORE: ${ref.read(scrollOffsetProvider)}');
                  if(_scaleTL > 1) {
                    ref.read(scaleTimelimeProvider.notifier).state = 1;
                    ref.read(_scaleprovider.notifier).state = 1;
                    ref.read(fontScaleProvider.notifier).state = 12;
                    ref.read(scrollOffsetProvider.notifier).state = ref.read(scrollOffsetProvider) / _scaleTL;
                  } else {
                    ref.read(scaleTimelimeProvider.notifier).state = 3;
                    ref.read(_scaleprovider.notifier).state = 3;
                    ref.read(fontScaleProvider.notifier).state = 18;
                    ref.read(scrollOffsetProvider.notifier).state = ref.read(scrollOffsetProvider) * 3.0;
                  }
                  final k = (ref.read(scrollOffsetProvider) - ((nowReal.minute - now.minute) / 3 * 8).h) / (80.h);
                  const Duration mins30 = Duration(minutes: 30);
                  final trackTime = now.subtract(mins30 * k);
                  final trackTimeString = intl.DateFormat('HH:mm:ss', 'ru_RU').format(trackTime);
                  print(trackTimeString);
                  print('OFFSET_PROVIDER_AFTER: ${ref.read(scrollOffsetProvider)}');
                  controller.animateTo(
                    ref.read(scrollOffsetProvider),
                    duration: const Duration(milliseconds: 10),
                    curve: Curves.linearToEaseOut,
                  );
                },
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: itemCount,
                  controller: controller,
                  padding: EdgeInsets.only(
                    top: 24.h,
                    right: 8.w,
                    left: 28.w,
                    bottom: 24.h,
                  ),
                  itemBuilder: (context, index) {
                    final isFirst = index == 0;
                    final isLast = index == itemCount - 1;

                    late DateTime time;
                    //final DateTime time2 = now.subtract(Duration(minutes: 30 * index));

                    if(isFirst) {
                      time = nowReal.subtract(Duration(minutes: 30 * index));
                    } else {
                      time = now.subtract(Duration(minutes: 30 * (index - 1)));
                    }
                    DateTime timeLast = time.subtract(const Duration(minutes: 30));

                    // print('time: $time');
                    // print('height: $height');
                    // print('time2: $time2');
                    // print('==================================');

                    List<int> arr = [];
                    String strDates = '';
                    for(var date in eventsTimes) {
                      if(isFirst) timeLast = now;
                      if(date.compareTo(time) == -1 && date.compareTo(timeLast) == 1) {
                        arr.add(10 - (date.minute % 30 / 3).floor());
                        strDates += '${date.toString().split(' ').last.substring(0, 5)};\n';
                      }
                    }
                    final timeText = intl.DateFormat('HH:mm', 'ru_RU').format(time);
                    final timeTextLast = intl.DateFormat('HH:mm', 'ru_RU').format(timeLast);
                    final heightFirst = ((nowReal.minute - now.minute) / 3 * 8).h;
                    final heightFinal = isFirst
                        ? heightFirst * scale
                        : 80.h * scale;

                    final timelineTile = <Widget>[
                      Container(
                        //width: 24.w * scale,
                        margin: EdgeInsets.only(left: (14.w * scale + 14.w) + 42.w),
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(top: index == 0 ? 8.h : 0),
                          child: CustomPaint(
                            foregroundPainter: _TimelinePainter(
                              scale: scale,
                              fontScale: fontScale,
                              time: timeText,
                              timeLast: timeTextLast,
                              height: heightFinal,
                              lineColor: lineColor,
                              indicatorColor: indicatorColor,
                              indicatorStyle: indicatorStyle,
                              isFirst: isFirst,
                              isLast: isLast,
                              strokeCap: strokeCap,
                              strokeWidth: strokeWidth.w,
                              style: style,
                              eventsStrokes: arr,
                            ),
                          ),
                        ),
                      ),
                      14.horizontalSpace,
                      Expanded(
                        child: Container(
                          height: isFirst
                              ? heightFirst * scale
                              : 80.h * scale,
                          //width: 1.sw,
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          margin: EdgeInsets.only(top: index == 0 ? 8.h : 0),
                          decoration: BoxDecoration(
                            color: index % 2 == 0
                                ? DarkTheme.light
                                : DarkTheme.accent,
                          ),
                          child: arr.isNotEmpty
                              ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('№$index\n$strDates'),
                              8.horizontalSpace,
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: Colors.indigo,
                                  ),
                                  child: Text('тут типо события за 30мин период'),
                                ),
                              ),
                            ],
                          )
                              : Text('№$index'),
                        ),
                      ),
                    ];

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: timelineTile,
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 4.w,
                      height: 24.h,
                      //duration: const Duration(milliseconds: 325),
                      //curve: Curves.linear,
                      //width: isScrolling ? 0.w : 20.w,
                      // clipBehavior: Clip.hardEdge,
                      // margin: EdgeInsets.only(left: 4.w),
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(22.r),
                      //   color: Colors.transparent,
                      // ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 750),
                      curve: Curves.easeOutExpo,
                      width: 82.w,// isScrolling ? 80.w : 0.w,
                      height: scrollOffset != 0 ? 24.h : 0.h,
                      clipBehavior: Clip.hardEdge,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22.r),
                        color: Colors.blue,
                      ),
                      child: Builder(
                        builder: (context) {
                          final k = (scrollOffset / scale - ((nowReal.minute - now.minute) / 3 * 8).h) / (80.h);
                          const Duration mins30 = Duration(minutes: 30);
                          final trackTime = now.subtract(mins30 * k);
                          final trackTimeString = intl.DateFormat('HH:mm:ss', 'ru_RU').format(trackTime);
                          return Text(
                            trackTimeString,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: DarkTheme.white,
                            ),
                          );
                        }
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 2.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    8.horizontalSpace,
                  ],
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  _TimelinePainter({
    required this.scale,
    required this.fontScale,
    required this.time,
    required this.height,
    required this.timeLast,
    required this.eventsStrokes,
    required this.indicatorColor,
    required this.indicatorStyle,
    required this.strokeCap,
    required this.strokeWidth,
    required this.style,
    required this.lineColor,
    required this.isFirst,
    required this.isLast,
  })  : linePaint = Paint()
    ..color = lineColor
    ..strokeCap = strokeCap
    ..strokeWidth = strokeWidth
    ..style = style,
        circlePaint = Paint()
          ..color = indicatorColor
          ..style = indicatorStyle;

  final String time;
  final String timeLast;
  final List<int> eventsStrokes;
  final Color indicatorColor;
  final PaintingStyle indicatorStyle;
  final StrokeCap strokeCap;
  final double strokeWidth;
  final PaintingStyle style;
  final Color lineColor;
  final Paint linePaint;
  final Paint circlePaint;
  final bool isFirst;
  final bool isLast;
  final double height;
  final double scale;
  final double fontScale;

  @override
  void paint(Canvas canvas, Size size) {

    //print(height);
    //print(scale);

    final double gap = 8.h * scale;
    final horizontal = 5.w * scale + 4.w;
    ///Draw horizontal border strokes
    canvas.drawLine(
      Offset(10.w, 0),
      Offset(-horizontal, 0),
      linePaint,
    );
    canvas.drawLine(
      Offset(-10.w, height),
      Offset(-horizontal, height),
      linePaint,
    );

    ///Draw all horizontal strokes
    final _hr1 = time.split(':').first;
    final _mn1 = time.split(':').last;
    final _hr2 = timeLast.split(':').first;
    final _mn2 = timeLast.split(':').last;
    final _dtDate1 = DateTime.parse('1700-01-01 $_hr1:$_mn1:00.0');
    final _dtDate2 = DateTime.parse('1700-01-01 $_hr2:$_mn2:00.0');
    final _diff = _dtDate1.difference(_dtDate2).inMinutes;

    ///Костыль для случая сравнения 00:00 и 23:30 предыдущего дня
    late int iMax;
    if(_diff > 0) {
      iMax = _diff ~/ 3;
    } else {
      iMax = 10;
    }
    if(_diff % 3 != 0) iMax++;

    // print('time: $time');
    // print('timeLast: $timeLast');
    // print('height: $height');
    // print('iMax: $iMax');
    // print('==================================');

    for(int i = 1; i < iMax; i++) {
      //final gap = 8.h;
      double gap1 = (isFirst)
      ? height % gap
      : gap;

      if(gap1 == 0 ) gap1 = gap;

      final padding = (gap * (i - 1) + gap1);
      late double horizontalPadding;

      if(isFirst) {
        horizontalPadding = i == iMax - 5
            ? -horizontal
            :  -4 * scale.w + 6.w;
        if(eventsStrokes.contains(i)) {
          linePaint.color = Colors.red;
          linePaint.strokeWidth = 1.8.w;
        }
      } else {
        horizontalPadding = i == 5
            ? -horizontal
            :  -4 * scale.w + 6.w;
        if(eventsStrokes.contains(i)) {
          linePaint.color = Colors.red;
          linePaint.strokeWidth = 1.8.w;
        }
      }

      canvas.drawLine(
        Offset(10.w, (padding)),
        Offset(horizontalPadding, (padding)),
        linePaint,
      );
      linePaint.color = lineColor;
      linePaint.strokeWidth = strokeWidth;
    }

    final timeText = TextSpan(
      text: time,
      style: TextStyle(
        fontSize: fontScale.sp,
        fontWeight: FontWeight.w300,
        color: DarkTheme.accent,
      ),
    );

    final timeTextLast = TextSpan(
      text: timeLast,
      style: TextStyle(
        fontSize: fontScale.sp,
        fontWeight: FontWeight.w300,
        color: DarkTheme.accent,
      ),
    );

    final textPainter = TextPainter(
      text: timeText,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: 60.w,
    );
    textPainter.paint(canvas, Offset(-48.w * (fontScale / 12) + (16 - fontScale).w, -7.h * (fontScale / 12)));

    if(isLast) {
      textPainter.text = timeTextLast;
      textPainter.layout(
        minWidth: 0,
        maxWidth: 60.w,
      );
      textPainter.paint(canvas, Offset(-42.w * (fontScale / 12) - 4.w, (height -14).h * (fontScale / 12)));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}