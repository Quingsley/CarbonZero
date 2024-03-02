import 'package:carbon_zero/oss_licenses.dart';
import 'package:flutter/material.dart';

/// licenses page
class LicensesPage extends StatelessWidget {
  /// constructor
  const LicensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Licenses'),
        centerTitle: true,
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: ossLicenses.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                //capitalize the first letter of the string
                title: Text(
                  ossLicenses[index].name[0].toUpperCase() +
                      ossLicenses[index].name.substring(1),
                ),
                subtitle: Text(ossLicenses[index].description),
              ),
            ),
          );
        },
      ),
    );
  }
}
