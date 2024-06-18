import 'package:flutter/material.dart';
import 'package:nav_bar/models/debts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:nav_bar/services/client_service.dart';
import 'package:nav_bar/services/debts_service.dart';
import 'package:intl/intl.dart'; // Para manejar fechas

class AlertsPage extends StatefulWidget {
  final int clientId;
  const AlertsPage({super.key, required this.clientId});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  late Future<List<Debts>> _debts;
  final dService = DebtsService();
  final cService = ClientService();
  final Map<DateTime, List<Debts>> _debtsByDate = {};
  DateTime today = DateTime.now();
  DateTime? selectedDay;
  late final ValueNotifier<List<Debts>> _selectedDebts;

  @override
  void initState() {
    super.initState();
    _debts = fetchDebts();
    selectedDay = today;
    _selectedDebts = ValueNotifier(_getDebtsForDay(today));
  }

  Future<List<Debts>> fetchDebts() async {
    try {
      final debts = await cService.getClientDebts(widget.clientId, clientId: 1);
      _groupDebtsByDate(debts);
      return debts;
    } catch (e) {
      print('Error fetching debts: $e');
      throw Exception('Error fetching debts: $e');
    }
  }

  void _groupDebtsByDate(List<Debts> debts) {
    _debtsByDate.clear();
    for (var debt in debts) {
      DateTime expirationDate = DateFormat('dd-MM-yyyy').parse(debt.expiration);
      DateTime dateOnly = DateTime(expirationDate.year, expirationDate.month, expirationDate.day);
      if (_debtsByDate[dateOnly] == null) {
        _debtsByDate[dateOnly] = [];
      }
      _debtsByDate[dateOnly]!.add(debt);
    }
  }

  List<Debts> _getDebtsForDay(DateTime day) {
    DateTime dateOnly = DateTime(day.year, day.month, day.day);
    return _debtsByDate[dateOnly] ?? [];
  }

  void onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      selectedDay = day;
      _selectedDebts.value = _getDebtsForDay(day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Alerts'),
      ),
      body: FutureBuilder<List<Debts>>(
        future: _debts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No debts found.'));
          } else {
            return Column(
              children: [
                TableCalendar(
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  availableGestures: AvailableGestures.all,
                  selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                  focusedDay: today,
                  firstDay: DateTime.utc(2024, 6, 1),
                  lastDay: DateTime(2030, 3, 14),
                  onDaySelected: onDaySelected,
                  eventLoader: _getDebtsForDay,
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ValueListenableBuilder<List<Debts>>(
                    valueListenable: _selectedDebts,
                    builder: (context, value, _) {
                      if (value.isEmpty) {
                        return const Center(child: Text('No debts found for this day.'));
                      }
                      return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          final debt = value[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              onTap: () => print('Debt ${debt.id} tapped'),
                              title: Text(debt.description),
                              subtitle: Text('Amount: ${debt.amount}\nExpiration: ${debt.expiration}'),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}