import 'package:canvas_test_project/widgets/timeline/timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../scale_rotate/scale.dart';

class TimelinePage extends ConsumerWidget {
  const TimelinePage({super.key});

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
        body: GestureDetector(

          child: CustomTimeline(),
        )
    );
  }

}