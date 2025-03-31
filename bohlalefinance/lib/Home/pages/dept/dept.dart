import 'package:bohlalefinance/util/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DeptScreen extends StatefulWidget {
  const DeptScreen({super.key});

  @override
  State<DeptScreen> createState() => _DeptScreenState();
}

class _DeptScreenState extends State<DeptScreen> {
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  var selectedValue;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).copyWith().size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:AppColors.mainColor,
        title: const Text(
          'Bohlale Finance',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(left: size.width * 0.07),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              FloatingActionButton(
                backgroundColor: AppColors.mainColor,
                child: const Icon(Icons.send, color: Colors.white),
                onPressed: () {},
              ),
            ]),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Financial Summary Section
              SelectableText(
                'Financial Summary',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.title),
                  ),
                ),
                ),
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.title),
                  ),
                ),
                ),
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.title),
                  ),
                ),
                ),
              ),
              SelectableText(
                'Debt & Loan Overview',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Card(
                child: ListTile(
                  title: SelectableText('Total Debt'),
                  trailing: SelectableText('\$10000'),
                ),
              ),
              Card(
                child: ListTile(
                  title: SelectableText('Monthly Loan Payment'),
                  trailing: SelectableText('\$500'),
                ),
              ),
              
              SizedBox(height: 10),
            

  
            ],
          ),
        ),
      ),
    );
  }
  
}