import 'package:canvas_test_project/widgets/timeline/timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../scale.dart';

final scaleTimelimeProvider = StateProvider<double>((ref) => 1);
final fontScaleProvider = StateProvider<double>((ref) => 12);
final _scaleprovider = StateProvider<double>((ref) => 1);

class TimelinePage extends ConsumerWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _scale = ref.watch(_scaleprovider);
    final _scaleTL = ref.watch(scaleTimelimeProvider);
    final _scaleF = ref.watch(fontScaleProvider);
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
        body: GestureDetector(
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
            if(_scaleTL > 1) {
              ref.read(scaleTimelimeProvider.notifier).state = 1;
              ref.read(_scaleprovider.notifier).state = 1;
              ref.read(fontScaleProvider.notifier).state = 12;
            } else {
              ref.read(scaleTimelimeProvider.notifier).state = 3;
              ref.read(_scaleprovider.notifier).state = 3;
              ref.read(fontScaleProvider.notifier).state = 18;
            }
          },
          child: const CustomTimeline(),
        )
    );
  }

}