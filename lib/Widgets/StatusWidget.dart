import 'package:flutter/cupertino.dart';

class StatusWidget extends StatelessWidget {
  final String statusName;
  const StatusWidget({super.key, required this.statusName});

  @override
  Widget build(BuildContext context) {
    switch (statusName) {
      case 'NEW':
        return Container(
          decoration: BoxDecoration(
              color: Color(0xFFD4E0FF), borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            'PESANAN DIBUAT',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: Color(0xFF4894FE)),
          ),
        );
      case 'REJECTED':
        return Container(
          decoration: BoxDecoration(
              color: Color(0xFFFFECEC), borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            'REJECTED',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: Color(0xFFF44336)),
          ),
        );
      case 'ONGOING':
        return Container(
          decoration: BoxDecoration(
              color: Color(0xFFFCF8E0), borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            'DIPROSES',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: Color(0xFFFF9800)),
          ),
        );
      case 'READY':
        return Container(
          decoration: BoxDecoration(
              color: Color(0xFFEBFCEB), borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            'READY',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: Color(0xFF4CAF50)),
          ),
        );
      case 'COMPLETED':
        return Container(
          decoration: BoxDecoration(
              color: Color(0xFFF4E9F6), borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            'COMPLETED',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: Color(0xFF9C27B0)),
          ),
        );

      default:
        return Container();
    }
  }
}
