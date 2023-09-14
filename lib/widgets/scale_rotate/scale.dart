import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DarkTheme {
  static const Color dark = Color(0xff2C3333);
  static const Color medium = Color(0xff2E4242);
  static const Color light = Color(0xff0E8388);
  static const Color accent = Color(0xffABC4BE);
  static const Color white = Color(0xffE0E0E0);
}

final sizeProvider = StateProvider<double>((ref) => 160);

final rotateProvider = StateProvider<double>((ref) => 0);

final colorProvider = StateProvider<Color>((ref) {
  final size = ref.watch(sizeProvider);
  final ratio = size / 320;

  return Color.lerp(
    DarkTheme.accent,
    DarkTheme.light,
    ratio,
  ) ?? Colors.purple;
});

class ScaleTestPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = ref.watch(sizeProvider);
    final angle = ref.watch(rotateProvider);
    final color = ref.watch(colorProvider);
    return Scaffold(
      backgroundColor: DarkTheme.medium,
      appBar: AppBar(
        backgroundColor: DarkTheme.dark,
        title: Text(
          'Scale & rotate test',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: DarkTheme.white,
          ),
        ),
      ),
      body: Center(
        child: GestureDetector(
          onScaleUpdate: (details) {
            double newSize = size * details.scale;
            if(newSize < 40) newSize = 40;
            if(newSize > 320) newSize = 320;
            ref.read(sizeProvider.notifier).state = newSize;
            ref.read(rotateProvider.notifier).state = details.rotation;
          },
          onDoubleTap: () {
            ref.read(sizeProvider.notifier).state = 160;
            ref.read(rotateProvider.notifier).state = 0;
          },
          child: Transform.rotate(
            angle: angle,
            child: Container(
              width: size.w,
              height: size.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular((size / 12).r),
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }

}