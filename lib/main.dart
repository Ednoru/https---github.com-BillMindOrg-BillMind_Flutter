import 'package:flutter/material.dart';
import 'package:nav_bar/database/database.dart';
import 'package:nav_bar/pages/principal/alerts_page.dart';
import 'package:nav_bar/pages/principal/balance_page.dart';
import 'package:nav_bar/pages/principal/debts_page.dart';
import 'package:nav_bar/pages/principal/profile_page.dart';
import 'package:nav_bar/services/client_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.openDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClientProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final clientId = Provider.of<ClientProvider>(context).clientId;
    const int clientId = 1;

    return Scaffold(
        appBar: AppBar(
          title: const Text('BillMind'),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            DebtsPage(clientId: clientId /*?? 0*/),
            AlertsPage(clientId: clientId),
            BalancePage(),
            ProfilePage(clientId: clientId /*?? 0*/),
          ],
        ),
        bottomNavigationBar: Material(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor:
                Colors.green,
            unselectedLabelColor: Colors.blue,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: const EdgeInsets.all(5.0),
            tabs: const [
              Tab(icon: Icon(Icons.account_balance_wallet), text: 'Cuentas'),
              Tab(icon: Icon(Icons.notifications_active), text: 'Alertas'),
              Tab(icon: Icon(Icons.account_balance), text: 'Balance'),
              Tab(icon: Icon(Icons.person_outline), text: 'Perfil'),
            ],
          ),
        )
    );
  }
}
