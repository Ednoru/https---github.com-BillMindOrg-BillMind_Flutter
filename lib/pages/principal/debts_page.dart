import 'package:flutter/material.dart';
import 'package:nav_bar/models/debts.dart';
import 'package:nav_bar/services/client_service.dart';
import 'package:nav_bar/services/debts_service.dart';

class DebtsPage extends StatefulWidget {
  final int clientId;
  const DebtsPage({super.key, required this.clientId});

  @override
  State<DebtsPage> createState() => _DebtsPageState();
}

class _DebtsPageState extends State<DebtsPage> {
  late Future<List<Debts>> _debts;
  final dService = DebtsService();
  final cService = ClientService();

  @override
  void initState() {
    _debts = fetchDebts();
    super.initState();
  }

  Future<List<Debts>> fetchDebts() async {
    try {
      final debts = await cService.getClientDebts(widget.clientId, clientId: 1);
      return debts;
    } catch (e) {
      print('Error fetching debts: $e');
      // Imprimir la respuesta JSON si hay un error
      print('Response body: ${e.toString()}');
      throw Exception('Error fetching debts: $e');
    }
  }

  Future<void> addDebt(Debts debt) async {
    final dService = DebtsService();
    await dService.addDebt(debt);
  }

  Future<void> deleteDebt(int debtId) async {
    final dService = DebtsService();
    await dService.deleteDebt(debtId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debts'),
      ),
      body: FutureBuilder<List<Debts>>(
        future: _debts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final debt = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: const Icon(Icons.payment,
                        color: Colors.green),
                    title: Text(debt.description),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Monto: S/. ${debt.amount.toString()}'),
                        Text('Vencimiento: ${debt.expiration}')
                      ],
                    ),

                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red
                      ),
                      onPressed: () => deleteDebt(debt.id),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No se encontraron deudas'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción para agregar una nueva deuda
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
