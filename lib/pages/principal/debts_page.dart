import 'package:flutter/material.dart';
import 'package:nav_bar/models/client.dart';
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
  
  Future<void> showAddDebtDialog() async {
    TextEditingController expirationController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    String? selectedRelevance;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar nueva deuda'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Monto a pagar'),
                ),
                TextField(
                  controller: expirationController,
                  decoration: const InputDecoration(labelText: 'Fecha de vencimiento'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedRelevance,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRelevance = newValue;
                    });
                  },
                  items: <String>['Baja', 'Media', 'Alta']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Relevancia'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Debts newDebt = Debts(
                  id: 1,
                  expiration: expirationController.text,
                  amount: amountController.text,
                  description: descriptionController.text,
                  relevance: selectedRelevance ?? '',
                  client: Client(id: widget.clientId, name: '', lastName: '', mail: '', phone: '', password: '',),
                );

                // Llamar a la función addDebt() para agregar la nueva deuda
                await addDebt(newDebt);

                // Cerrar el cuadro de diálogo
                Navigator.of(context).pop();
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }
  /*
  Future<void> showAddDebtDialog() async {
    TextEditingController expirationController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController relevanceController = TextEditingController();
    late String selectedRelevance;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar nueva deuda'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: expirationController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Monto a pagar'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration:
                      const InputDecoration(labelText: 'Fecha de vencimiento'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedRelevance,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRelevance = newValue!;
                    });
                  },
                  items: <String>['Baja', 'Media', 'Alta']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Relevancia'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Crear una nueva deuda con los datos ingresados por el usuario
                Debts newDebt = Debts(
                  id: 0, // Este valor puede ser 0 si el servidor asigna el ID
                  expiration: expirationController.text,
                  amount: amountController.text,
                  description: descriptionController.text,
                  relevance: relevanceController.text,
                  client: Client(id: widget.clientId, name: '', lastName: '', email: ''),
                );

                // Llamar a la función addDebt() para agregar la nueva deuda
                addDebt(newDebt);

                // Cerrar el cuadro de diálogo
                Navigator.of(context).pop();
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }
  */

  Icon getRelevanceIcon(String relevance) {
  switch (relevance) {
    case 'Alta':
      return const Icon(Icons.warning, color: Colors.red);
    case 'Media':
      return const Icon(Icons.emergency, color: Colors.amber);
    case 'Baja':
      return const Icon(Icons.low_priority, color: Colors.green);
    default:
      return const Icon(Icons.error); // En caso de que no se reconozca la relevancia
  }
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
                    leading: getRelevanceIcon(debt.relevance),
                    title: Text(debt.description),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Monto: S/. ${debt.amount.toString()}'),
                        Text('Vencimiento: ${debt.expiration}'),
                        Text('Relevancia: ${debt.relevance}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
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
          showAddDebtDialog();
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
