import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:map_my_walk/configs/app_typography_ext.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../../../configs/app_theme.dart';
import '../../../configs/app_typography.dart';
import '../../../configs/space.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashGauge extends StatefulWidget {
  final int? maxSteps;

  const DashGauge({Key? key, this.maxSteps}) : super(key: key);

  @override
  State<DashGauge> createState() => _DashGaugeState();
}

class _DashGaugeState extends State<DashGauge> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Future<int> _targetSteps;

  @override
  void initState() {
    super.initState();
    _targetSteps = _fetchRecentChallengeSteps();
  }
  Future<int> _fetchRecentChallengeSteps() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return 0; // Return zero if not logged in

    DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
    List<dynamic> participatedChallenges = userDoc['participatedChallenges'];
    if (participatedChallenges.isEmpty) return 0; // Return zero if no challenges

    // Fetch the most recent challenge details using the last element of participatedChallenges array
    String recentChallengeId = participatedChallenges.last as String;  // Explicitly cast as String
    DocumentSnapshot challengeDoc = await _firestore.collection('challenges').doc(recentChallengeId).get();
    ()challengeDoc{
    if (challengeDoc.exists) {
      int steps = challengeDoc['steps'];
      return steps;
    }

    return 0; // Return zero if challenge details not found or no 'steps' field
  }


  final CircularSliderAppearance gaugeAppearance = CircularSliderAppearance(
    customWidths: CustomSliderWidths(
      progressBarWidth: 8,
      handlerSize: 10,
    ),
    size: 200,
    customColors: CustomSliderColors(
      progressBarColors: [
        AppTheme.c.primaryDark!,
        AppTheme.c.primary,
        AppTheme.c.accent,
        AppTheme.c.accent,
      ],
      dotColor: AppTheme.c.primary,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _targetSteps,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data == 0) {
          return Center(child: Text("No active challenges"));
        }

        int maxSteps = snapshot.data!;
        return IgnorePointer(
          child: SleekCircularSlider(
            innerWidget: (double percentage) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/footsteps.png",
                      height: 30,
                    ),
                    Countup(
                        begin: 0,
                        end: maxSteps.toDouble(),
                        duration: const Duration(seconds: 1),
                        separator: ',',
                        style: AppText.h1b.cl(AppTheme.c.primary).copyWith(fontSize: 24)),
                    Space.y,
                    Image.asset(
                      "assets/trophy.png",
                      color: AppTheme.c.primaryDark!,
                      height: 20,
                    ),
                    Text(
                      maxSteps.toString(),
                      style: AppText.b2bm.cl(AppTheme.c.primaryDark!),
                    )
                  ],
                )),
            appearance: gaugeAppearance,
            min: 0,
            max: maxSteps.toDouble(),
            initialValue: maxSteps.toDouble(),
          ),
        );
      },
    );
  }
}
