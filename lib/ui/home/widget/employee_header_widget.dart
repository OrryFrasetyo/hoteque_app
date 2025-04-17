import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/model/employee.dart';

class UserHeaderWidget extends StatelessWidget {
  final Employee employee;

  const UserHeaderWidget({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 1.0],
          colors: [Color(0xFF90612D), Color(0xFF2A1C0D)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, Jepry',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Room Attendant - Hotelqu",
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/icon/logo-hotelqu.png'),
                ),
              ],
            ),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}
