import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineMaker extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final bool isCompelete;
  final bool isClosed;
  final Widget endChild;
  final double height;
  final double? padding;
  final double? indicatorXY;

  TimelineMaker(
      {Key? key,
      required this.isCompelete,
      required this.isFirst,
      required this.isLast,
      required this.isPast,
      required this.isClosed,
      required this.endChild,
      required this.height,
      required this.indicatorXY,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        afterLineStyle: LineStyle(
          color: Colors.grey[300]!,
        ),
        beforeLineStyle: LineStyle(
          color: Colors.grey[300]!,
        ),
        endChild: Align(
            alignment: Alignment.center,
            child: DefaultTextStyle(
                style: TextStyle(
                  color: isCompelete
                      ? Colors.green
                      : isPast
                          ? Color(int.parse("#FF979797".replaceAll('#', ""),
                              radix: 16))
                          : Theme.of(context).primaryColor,
                ),
                child: endChild)),
        indicatorStyle: IndicatorStyle(
          indicator: !isPast
              ? !isClosed
                  ? CircleAvatar(
                      backgroundColor: isCompelete
                          ? Colors.green
                          : Theme.of(context).primaryColor,
                      radius: 15,
                      child: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).expansionTileTheme.iconColor,
                        radius: 10,
                        child: CircleAvatar(
                          backgroundColor: isCompelete
                              ? Colors.green
                              : Theme.of(context).primaryColor,
                          radius: 8,
                        ),
                      ),
                    )
                  : const CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 20,
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 17,
                      ),
                    )
              : const CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 20,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 17,
                  ),
                ),
          height: 25,
          width: 25,
          indicatorXY: indicatorXY!,
          // iconStyle: isPast
          //     ? IconStyle(iconData: Icons.check, color: Colors.white)
          //     : null,
          // color: isPast
          //     ? Color(int.parse("#FF979797".replaceAll('#', ""), radix: 16))
          //     : Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
