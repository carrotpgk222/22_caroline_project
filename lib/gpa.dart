import 'package:flutter/material.dart';

class GPAHomePage extends StatefulWidget {
  const GPAHomePage({super.key});

  @override
  _GPAHomePageState createState() => _GPAHomePageState();
}

class Semester {
  int semesterNumber;
  List<Map<String, dynamic>> modules;

  Semester(this.semesterNumber, this.modules);
}

class _GPAHomePageState extends State<GPAHomePage> {
  List<String> grades = ['A', 'B', 'C', 'D', 'E', 'F'];
  String selectedGrade = 'A';
  List<Semester> semesters = [];
  double totalCredits = 0, totalGradePoints = 0;
  final TextEditingController titleController = TextEditingController();
  int selectedCredit = 1;
  List<int> creditOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  Map<String, dynamic>? editingModule;
  bool displayCard = false;
  int? selectedLongPressIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Text(
        'GPA ${(totalCredits != 0 ? (totalGradePoints / totalCredits).toStringAsFixed(3) : '0.00')}',
        style:
            const TextStyle(height: 2, letterSpacing: 5, color: Colors.black),
      ),
      appBar: AppBar(
        title: const Center(child: Text('GPA Calculator')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                (totalCredits != 0
                    ? (totalGradePoints / totalCredits).toStringAsFixed(3)
                    : '0.00'),
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(thickness: 1, color: Colors.black),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Icon(Icons.view_module_outlined),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Module Name: ',
                      hintText: 'MAD',
                      fillColor: Colors.yellow,
                    ),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Module name cannot be empty'
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Credit Units: ',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                DropdownButton<int>(
                  value: selectedCredit,
                  onChanged: (value) => setState(() => selectedCredit = value!),
                  items: creditOptions
                      .map((value) => DropdownMenuItem(
                          value: value, child: Text(value.toString())))
                      .toList(),
                ),
                const Text('Grade Attained: ',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                DropdownButton<String>(
                  value: selectedGrade,
                  onChanged: (value) => setState(() => selectedGrade = value!),
                  items: grades
                      .map((value) =>
                          DropdownMenuItem(value: value, child: Text(value)))
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      editingModule == null ? _addModule() : _editModule(),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: editingModule == null
                          ? Colors.blue
                          : Colors.blueGrey),
                  child: Text(
                      editingModule == null ? 'Add Module' : 'Save Module'),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () => editingModule != null
                      ? _deleteModule(editingModule!)
                      : _deleteAllSemesters(),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: editingModule == null
                          ? Colors.red
                          : Colors.redAccent),
                  child: Text(
                      editingModule == null ? 'Delete All' : 'Delete Module'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
                onPressed: _addSemester, child: const Text('Add Semester')),
            for (var semester in semesters) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Semester ${semester.semesterNumber}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const Divider(thickness: 1, color: Colors.black),
                  for (var moduleIndex = 0;
                      moduleIndex < semester.modules.length;
                      moduleIndex++) ...[
                    Dismissible(
                      key: Key(
                          "${semester.semesterNumber}_${semester.modules[moduleIndex]["title"]}"),
                      onDismissed: (direction) =>
                          _deleteModule(semester.modules[moduleIndex]),
                      background: Container(
                        color: Colors.red,
                        child: const Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                      ),
                      child: GestureDetector(
                        onLongPress: () => _startEditing(
                            moduleIndex, semester.modules[moduleIndex]),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: moduleIndex == selectedLongPressIndex
                                  ? Colors.green
                                  : Colors.transparent,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            title: Text(
                              'Module: ${semester.modules[moduleIndex]["title"]} | Credits: ${semester.modules[moduleIndex]["credits"]} | Grade: ${semester.modules[moduleIndex]["grade"]}',
                            ),
                            onTap: () {},
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  void _addSemester() {
    setState(() {
      semesters.add(Semester(semesters.length + 1, []));
    });
  }

  void _addModule() {
    String title = titleController.text;
    if (title.isEmpty) {
      // Show a warning using a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please insert a module name'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    setState(() {
      semesters.last.modules.add({
        "title": title,
        "credits": selectedCredit.toDouble(),
        "grade": selectedGrade,
      });
      totalCredits += selectedCredit.toDouble();
      _calculateGPA();
    });

    titleController.clear();
    selectedCredit = 1;
    selectedGrade = 'A';
  }

  void _deleteModule(Map<String, dynamic> module) {
    setState(() {
      for (var semester in semesters) {
        semester.modules.remove(module);
      }
      _calculateGPA();
    });
    titleController.clear();
    selectedCredit = 1;
    selectedGrade = 'A';
    editingModule = null;
  }

  void _deleteAllSemesters() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this module?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  semesters.clear();
                  _calculateGPA();
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _calculateGPA() {
    setState(() {
      totalGradePoints = 0;
      totalCredits = 0;
      for (var semester in semesters) {
        for (var module in semester.modules) {
          double gradeScale = _getGradeScale(module["grade"]);
          totalGradePoints += (module["credits"] * gradeScale);
          totalCredits += module["credits"];
        }
      }
    });
  }

  double _getGradeScale(String grade) {
    switch (grade) {
      case 'A':
        return 4.0;
      case 'B':
        return 3.0;
      case 'C':
        return 2.0;
      case 'D':
        return 1.0;
      case 'E':
        return 1.0;
      case 'F':
        return 0.0;
      default:
        return 0.0;
    }
  }

  void _editModule() {
    String title = titleController.text;

    setState(() {
      editingModule!["title"] = title;
      editingModule!["credits"] = selectedCredit.toDouble();
      editingModule!["grade"] = selectedGrade;
      _calculateGPA();
    });

    titleController.clear();
    selectedCredit = 1;
    selectedGrade = 'A';
    editingModule = null;
  }

  void _startEditing(int moduleIndex, Map<String, dynamic> module) {
    setState(() {
      titleController.text = module["title"];
      selectedCredit = module["credits"].toInt();
      selectedGrade = module["grade"];
      editingModule = module;
      selectedLongPressIndex = moduleIndex;
    });
  }
}
