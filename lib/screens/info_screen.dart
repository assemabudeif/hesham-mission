import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);
  final assemEmail = 'assemdev0@gmail.com';
  final assemPhone = '+201125522530';
  final ehabEmail = 'ehabahmedelsheikh@gmail.com';
  final ehabPhone = '+201025273191';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بيانات المبرمج'),
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الاسم: عاصم أشرف عادل',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'البريد الالكتروني:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse('mailto:$assemEmail'));
                  },
                  child: Text(
                    assemEmail,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'رقم الهاتف:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse('tel:$assemPhone'));
                  },
                  child: Text(
                    assemPhone,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'الاسم: أيهاب أحمد صابر',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'البريد الالكتروني:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse('mailto:$ehabEmail'));
                  },
                  child: Text(
                    ehabEmail,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'رقم الهاتف:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse('tel:$ehabPhone'));
                  },
                  child: Text(
                    ehabPhone,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
