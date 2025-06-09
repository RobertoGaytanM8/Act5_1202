import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Note extends StatefulWidget {
  const Note({super.key});

  @override
  State<Note> createState() => _perrostate();
}

class _perrostate extends State<Note> {
  final titlecontroller = TextEditingController();
  final contentcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 255, 98),
        title: Text("Act 5 Roberto Gaytan 6J"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Tabla Perros",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 7, 255, 172),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: titlecontroller,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Enter title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: contentcontroller,
              decoration: InputDecoration(
                labelText: 'Content',
                hintText: 'Enter content',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final title = titlecontroller.text.trim();
                final content = contentcontroller.text.trim();

                if (title.isNotEmpty && content.isNotEmpty) {
                  FirebaseFirestore.instance.collection('perros').add({
                    'title': title,
                    'content': content,
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  titlecontroller.clear();
                  contentcontroller.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor ingresa título y contenido')),
                  );
                }
              },
              child: Text('Guardar'),
            ),
            SizedBox(height: 20),

            // Aquí el truco: Expanded para que ListView tenga espacio limitado
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('perros')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return Center(child: Text('No hay notas'));
                  }
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final title = doc['title'] ?? '';
                      final content = doc['content'] ?? '';

                      return ListTile(
                        title: Text(title),
                        subtitle: Text(content),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_forever, color: Colors.red),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('perros')
                                .doc(doc.id)
                                .delete();
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
