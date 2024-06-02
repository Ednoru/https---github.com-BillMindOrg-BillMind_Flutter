import 'package:flutter/material.dart';
import 'package:nav_bar/models/client.dart';
import 'package:nav_bar/services/client_service.dart';

class ProfilePage extends StatefulWidget {
  final int clientId;

  const ProfilePage({super.key, required this.clientId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Client> _client;

  @override
  void initState() {
    super.initState();
    _client = fetchClient();
  }

  Future<Client> fetchClient() async {
    final service = ClientService();
    final client = await service.getClientById(widget.clientId, clientId: 1);
    return client;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Client>(
      future: _client,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final client = snapshot.data!;
          return ListView(
            children: [
              Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Nombre'),
                  subtitle: Text(client.name),
                  trailing: IconButton(
                    icon:const Icon(Icons.edit),
                    onPressed: () {
                      // Acción para editar el nombre
                    },
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: const Icon(Icons.person_outline),
                  title:const Text('Apellido'),
                  subtitle: Text(client.lastName),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Acción para editar el apellido
                    },
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Correo'),
                  subtitle: Text(client.mail),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Acción para editar el correo
                    },
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: const Icon(Icons.phone_android),
                  title: const Text('Teléfono'),
                  subtitle: Text(client.phone),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Acción para llamar al número de teléfono
                    },
                  ),
                ),
              ),
              // Agrega más tarjetas o botones según sea necesario
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
