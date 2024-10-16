import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms and Conditions',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '1. 50% Advance along-with Purchase Order & balance before delivery',
                style: textTheme.displayMedium
                    ?.copyWith(fontSize: 16, color: Colors.black)),
            SizedBox(height: 10),
            Text('2. The Prices are subject to change without prior notice.',
                style: textTheme.displayMedium
                    ?.copyWith(fontSize: 16, color: Colors.black)),
            SizedBox(height: 10),
            Text('3. The above prices are GOVT TAX PAID (i.e GST)',
                style: textTheme.displayMedium
                    ?.copyWith(fontSize: 16, color: Colors.black)),
            SizedBox(height: 10),
            Text('4. The above Prices are Ex-FACTORY',
                style: textTheme.displayMedium
                    ?.copyWith(fontSize: 16, color: Colors.black)),
            SizedBox(height: 10),
            Text(
                '5. Availability of model, Colours is subject to current stock position and not on order',
                style: textTheme.displayMedium
                    ?.copyWith(fontSize: 16, color: Colors.black)),
            SizedBox(height: 10),
            Text(
                '6. All responsibility shall be on Dealers/Buyer\'s account once goods despatched from Factory',
                style: textTheme.displayMedium
                    ?.copyWith(fontSize: 16, color: Colors.black)),
            SizedBox(height: 10),
            Text('7. Freight TO PAY BASIS',
                style: textTheme.displayMedium
                    ?.copyWith(fontSize: 16, color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
