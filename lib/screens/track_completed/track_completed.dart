// import 'package:countup/countup.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:map_my_walk/configs/app_typography_ext.dart';
// import 'package:map_my_walk/screens/track_completed/widgets/stats_card.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../app_routes.dart';
// import '../../configs/app_dimensions.dart';
// import '../../configs/app_theme.dart';
// import '../../configs/app_typography.dart';
// import '../../configs/space.dart';
// import '../../configs/ui_props.dart';
// import '../../providers/app_provider.dart';
// import '../../widgets/primary_button.dart';
//
// class TrackCompletedScreen extends StatelessWidget {
//   final String points;
//   const TrackCompletedScreen({Key? key, required this.points}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(context, designSize: const Size(428, 926));
//     final app = Provider.of<AppProvider>(context);
//     return Scaffold(
//         body: SafeArea(
//       child: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Lottie.asset("assets/animations/completed.json",
//                     height: 120, frameRate: FrameRate(30)),
//                 Text(
//                   "Steps towards a healthier life",
//                   style: AppText.h3b.cl(
//                     AppTheme.c.primaryDark!,
//                   ),
//                 ),
//                 Space.y,
//                 Container(
//                   width: 80,
//                   height: 5,
//                   decoration: BoxDecoration(
//                       borderRadius: UIProps.radiusXL,
//                       color: AppTheme.c.primary),
//                 )
//               ],
//             ),
//           ),
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Container(
//               padding: const EdgeInsets.only(left: 40),
//               margin: Space.all(),
//               height: AppDimensions.size.height * 0.15,
//               width: AppDimensions.size.width - 100,
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                     image: AssetImage(
//                       "assets/rounded_cont.png",
//                     ),
//                     fit: BoxFit.contain),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Space.y,
//                   Countup(
//                       begin: 0,
//                       end: (app.getUserStepCount as int).toDouble(),
//                       duration: const Duration(seconds: 2),
//                       separator: ',',
//                       style: AppText.h1b
//                           .cl(AppTheme.c.primaryDark!)
//                           .copyWith(fontSize: 36)),
//                   Text(
//                     "Steps",
//                     style: AppText.h3b.cl(AppTheme.c.primaryDark!),
//                   ),
//                   Container(
//                     width: 40,
//                     height: 5,
//                     decoration: BoxDecoration(
//                         borderRadius: UIProps.radiusXL,
//                         color: AppTheme.c.accent),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             top: 48,
//             right: -45,
//             child: Image.asset(
//               "assets/walk_comp.png",
//               height: AppDimensions.size.height * 0.5,
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: Space.all(),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const StatsCard(),
//                   Space.yf(50),
//                   PrimaryButton(
//                     onPressed: () async {
//                       await app.resetCredentials(context).then(
//                             (value) => Navigator.pushNamedAndRemoveUntil(
//                                 context, AppRoutes.dashboard, (route) => false),
//                           );
//                     },
//                     child: Text(
//                       "Checkout!",
//                       style: AppText.h3b.cl(Colors.white),
//                     ),
//                   ),
//                   Space.y2,
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     ));
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_my_walk/configs/app_typography_ext.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:countup/countup.dart';
import '../../app_routes.dart';
import '../../configs/app_dimensions.dart';
import '../../configs/app_theme.dart';
import '../../configs/space.dart';
import '../../configs/app_typography.dart';
import '../../configs/ui_props.dart';
import '../../providers/app_provider.dart';
import '../../widgets/primary_button.dart';
import 'widgets/stats_card.dart';

class TrackCompletedScreen extends StatelessWidget {
  final String points;
  const TrackCompletedScreen({Key? key, required this.points}) : super(key: key);

  Future<void> updatePoints(BuildContext context) async {

    try {
      User? user = FirebaseAuth.instance.currentUser;
      var firestore = FirebaseFirestore.instance;
      DocumentReference docRef = firestore.collection('users').doc(user?.uid);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);
        if (!snapshot.exists) {
          throw Exception("User does not exist!");
        }
        int currentPoints = snapshot['points'] ?? 0;
        int newPoints =  currentPoints + int.parse(points);
        transaction.update(docRef, {'points': newPoints});
      }).then((value) {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.dashboard, (route) => false);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update points: ${e.toString()}"))
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    print("object:$points");
    ScreenUtil.init(context, designSize: const Size(428, 926));
    final app = Provider.of<AppProvider>(context);
    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Lottie.asset("assets/animations/completed.json",
                        height: 120, frameRate: FrameRate(30)),
                    Text(
                      "Steps towards a healthier life",
                      style: AppText.h3b.cl(
                        AppTheme.c.primaryDark!,
                      ),
                    ),
                    Space.y,
                    Container(
                      width: 80,
                      height: 5,
                      decoration: BoxDecoration(
                          borderRadius: UIProps.radiusXL,
                          color: AppTheme.c.primary),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 40),
                  margin: Space.all(),
                  height: AppDimensions.size.height * 0.15,
                  width: AppDimensions.size.width - 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          "assets/rounded_cont.png",
                        ),
                        fit: BoxFit.contain),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Space.y,
                      Countup(
                          begin: 0,
                          end: (app.getUserStepCount as int).toDouble(),
                          duration: const Duration(seconds: 2),
                          separator: ',',
                          style: AppText.h1b
                              .cl(AppTheme.c.primaryDark!)
                              .copyWith(fontSize: 36)),
                      Text(
                        "Steps",
                        style: AppText.h3b.cl(AppTheme.c.primaryDark!),
                      ),
                      Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                            borderRadius: UIProps.radiusXL,
                            color: AppTheme.c.accent),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 48,
                right: -45,
                child: Image.asset(
                  "assets/walk_comp.png",
                  height: AppDimensions.size.height * 0.5,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: Space.all(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const StatsCard(),
                      Space.yf(50),
                      PrimaryButton(
                        onPressed: () => updatePoints(context),
                        child: Text(
                          "Checkout!",
                          style: AppText.h3b.cl(Colors.white),
                        ),
                      ),
                      Space.y2,
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

