import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Note extends StatefulWidget {
  const Note({super.key});

  @override
  State<Note> createState() => _PerroState();
}

class _PerroState extends State<Note> {
  final codigoController = TextEditingController();
  final razaController = TextEditingController();
  final edadController = TextEditingController();
  final comportamientoController = TextEditingController();
  final vacunasController = TextEditingController();
  final sexoController = TextEditingController();

  void _guardarPerro() async {
    final codigo = codigoController.text.trim();
    final raza = razaController.text.trim();
    final edad = int.tryParse(edadController.text.trim());
    final comportamiento = comportamientoController.text.trim();
    final vacunas = vacunasController.text.trim();
    final sexo = sexoController.text.trim();

    if (codigo.isNotEmpty &&
        raza.isNotEmpty &&
        edad != null &&
        comportamiento.isNotEmpty &&
        vacunas.isNotEmpty &&
        sexo.isNotEmpty) {
      await FirebaseFirestore.instance.collection('perros').add({
        'codigo': codigo,
        'raza': raza,
        'edad': edad,
        'comportamiento': comportamiento,
        'vacunas': vacunas,
        'sexo': sexo,
        'timestamp': FieldValue.serverTimestamp(),
      });

      codigoController.clear();
      razaController.clear();
      edadController.clear();
      comportamientoController.clear();
      vacunasController.clear();
      sexoController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType tipo = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextField(
        controller: controller,
        keyboardType: tipo,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Act 5 Roberto Gaytan 6J"),
        backgroundColor: const Color.fromARGB(255, 7, 255, 98),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('perros')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Text(
                "Registro de Perros",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 7, 255, 172),
                ),
              ),
              _buildTextField(controller: codigoController, label: 'Código'),
              _buildTextField(controller: razaController, label: 'Raza'),
              _buildTextField(
                  controller: edadController,
                  label: 'Edad',
                  tipo: TextInputType.number),
              _buildTextField(
                  controller: comportamientoController, label: 'Comportamiento'),
              _buildTextField(controller: vacunasController, label: 'Vacunas'),
              _buildTextField(controller: sexoController, label: 'Sexo'),
              ElevatedButton(
                onPressed: _guardarPerro,
                child: const Text("Guardar"),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const Text("Lista de Perros", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              if (!snapshot.hasData)
                const Center(child: CircularProgressIndicator())
              else if (snapshot.data!.docs.isEmpty)
                const Center(child: Text('No hay registros'))
              else
                ...snapshot.data!.docs.map((doc) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text("Código: ${doc['codigo']} - Raza: ${doc['raza']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Edad: ${doc['edad']} años"),
                          Text("Comportamiento: ${doc['comportamiento']}"),
                          Text("Vacunas: ${doc['vacunas']}"),
                          Text("Sexo: ${doc['sexo']}"),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_forever, color: Colors.red),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('perros')
                              .doc(doc.id)
                              .delete();
                        },
                      ),
                    ),
                  );
                }).toList(),
            ],
          );
        },
      ),
    );
  }
}
