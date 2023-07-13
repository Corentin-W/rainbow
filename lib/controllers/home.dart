import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nouga/controllers/home_case.dart';
import 'package:nouga/controllers/search.dart';
import 'package:nouga/controllers/warning.dart';
import 'package:nouga/globals/globals.dart';
import '../globals/drawer.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Globals globals = Globals();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Column(
            children: [
              globals.getRainbowLogo(height: 80, width: 100, withName: false),
              const SizedBox(height: 10)
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        drawer: DrawerGlobal(contextFrom: context),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: homePage(context: context),
        ));
  }

  homePage({required BuildContext context}) {
    Globals globals = Globals();
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 10,
        height: MediaQuery.of(context).size.height - 10,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            actionsButton(),
            actionsButton2(),
            const SizedBox(height: 20),
            globals.textWithRainbowPolice(
                textData: 'Derniers cases ouverts',
                weight: FontWeight.w700,
                align: TextAlign.center,
                size: 20),
            lastCases(context: context),
          ],
        ),
      ),
    );
  }

  lastCases({required BuildContext context}) {
    return SizedBox(
      height: 180,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream:
            FirebaseFirestore.instance.collection('cases').limit(6).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          return Expanded(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: snapshot.data!.docs.map((doc) {
                DateTime date = doc.data()['date'].toDate();
                Duration difference = DateTime.now().difference(date);

                int days = difference.inDays;
                int hours = difference.inHours % 24;
                int minutes = difference.inMinutes % 60;
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeCase(id: doc.id)),
                      );
                    },
                    child: SizedBox(
                      width: 200,
                      height: 250,
                      child: ListTile(
                        title: Text(
                            doc.data()['prenom'] + ' ' + doc.data()['nom']),
                        subtitle: Text(
                            'Disparu(e) depuis $days jours, $hours heure(s) et $minutes minute(s)'),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  actionsButton() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [addButton(), searchButton()],
      ),
    );
  }

  actionsButton2() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [favoriteButton(), settingsButton()],
      ),
    );
  }

  addButton() {
    return Column(
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: FloatingActionButton(
            backgroundColor: const Color.fromARGB(175, 255, 239, 8),
            heroTag: 'addButton',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Warning()));
            },
            child: const Icon(
              Icons.add,
              color: Color.fromARGB(255, 87, 49, 49),
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Text('Ajouter un case')
      ],
    );
  }

  searchButton() {
    return Column(
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: FloatingActionButton(
            backgroundColor: const Color.fromARGB(175, 255, 239, 8),
            heroTag: 'searchButton',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => const Search())));
            },
            child: const Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 5),
        const Text('Chercher un case')
      ],
    );
  }

  favoriteButton() {
    return Column(
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: FloatingActionButton(
            backgroundColor: const Color.fromARGB(175, 255, 239, 8),
            heroTag: 'Mes cases suivis',
            onPressed: () {},
            child: const Icon(Icons.favorite),
          ),
        ),
        const SizedBox(height: 5),
        const Text('Chercher un case')
      ],
    );
  }

  settingsButton() {
    return Column(
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: FloatingActionButton(
            backgroundColor: const Color.fromARGB(175, 255, 239, 8),
            heroTag: 'Parametres',
            onPressed: () {},
            child: const Icon(Icons.settings),
          ),
        ),
        const SizedBox(height: 5),
        const Text('Chercher un case')
      ],
    );
  }
}
