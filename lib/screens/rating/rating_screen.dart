import 'package:flutter/material.dart';
import 'package:tasks/constants/constant.dart';
import 'package:tasks/screens/rating/complex_goal_rating.dart';
import 'package:tasks/screens/rating/fixed_goal_rating.dart';
import 'package:tasks/screens/rating/single_goal_rating.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التقييمات'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const SingleGOalRatingScreen();
                }));
              },
              color: KPrimaryColor,
              child: const Text('الأهداف الفردية',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ComplexGoalRatingScreen();
                }));
              },
              color: KPrimaryColor,
              child: const Text('الأهداف المجمعة',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const FixedGoalRatingScreen();
                }));
              },
              color: KPrimaryColor,
              child: const Text('الأهداف الثابتة',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
