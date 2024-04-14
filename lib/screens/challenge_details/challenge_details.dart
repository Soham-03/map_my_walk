import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:map_my_walk/app_routes.dart';

import '../tracking/tracking.dart';

class ChallengeDetailsScreen extends StatelessWidget {
  final String challengeId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ChallengeDetailsScreen({required this.challengeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Challenge Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('challenges').doc(challengeId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text('Challenge details not found.'));
          }
          var data = snapshot.data?.data() as Map<String, dynamic>;
          var steps = data['steps'];
          var points = data['points'];
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(data['title'], style: Theme.of(context).textTheme.headline5),
                  SizedBox(height: 10),
                  Text(data['description'], style: Theme.of(context).textTheme.subtitle1),
                  SizedBox(height: 10),
                  Text('Points: ${data['points']}'),
                  SizedBox(height: 10),
                  Text('Steps: ${data['steps']}'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrackingScreen(steps: steps.toString(), points: points.toString(),),
                        ),
                      );
                    },
                    child: Text('Start Tracking'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
