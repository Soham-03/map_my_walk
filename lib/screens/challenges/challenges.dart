import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../create_challenge/create_challenge.dart';

class ChallengesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Challenges'),
        backgroundColor: Colors.deepPurpleAccent,
          foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepPurpleAccent,
        onPressed: () {
          // Navigate to CreateChallengePage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateChallengeScreen()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Create Challenge',
      ),
      backgroundColor: Colors.deepPurpleAccent,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('challenges').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching challenges: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No challenges found', style: TextStyle(color: Colors.white)));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot challenge = snapshot.data!.docs[index];
              return ChallengeCard(data: challenge.data() as Map<String, dynamic>);
            },
          );
        },
      ),
    );
  }
}

class ChallengeCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const ChallengeCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['title'] ?? 'No Title',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent,
              ),
            ),
            SizedBox(height: 6),
            Text(
              data['description'] ?? 'No Description',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${data['points'] ?? 0} pts',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
