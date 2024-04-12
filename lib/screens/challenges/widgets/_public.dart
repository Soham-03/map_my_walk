part of '../challenges.dart';

class _Public extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('challenges').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return Text('No challenges found.');
        }

        List<DocumentSnapshot> documents = snapshot.data!.docs;
        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;
            return ListTile(
              // If you have an image URL, you can display the image using a NetworkImage.
              // Since imageUrl is nullable, ensure you handle the case when it is null.
              leading: data['imageUrl'] != null
                  ? Image.network(data['imageUrl'])
                  : Placeholder(fallbackWidth: 100, fallbackHeight: 100),
              title: Text(data['title'] ?? 'No Title'),
              subtitle: Text(data['description'] ?? 'No Description'),
              trailing: Text('${data['points'] ?? 0} Points'),
              onTap: () {
                // Handle the tap event
              },
            );
          },
        );
      },
    );
  }
}
