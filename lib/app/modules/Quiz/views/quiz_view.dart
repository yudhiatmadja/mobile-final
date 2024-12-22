import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile/firebase_options.dart';
import '../controllers/quiz_controller.dart';

class QuizView extends GetView<QuizController> {
  final QuizController controller = Get.put(QuizController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
        backgroundColor: Colors.green,
      ),
      body: Obx(() => ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: controller.quizzes.length,
            itemBuilder: (context, index) {
              final quiz = controller.quizzes[index];
              return buildQuizCard(
                context, // Perbaiki pemanggilan context
                quiz['id'],
                quiz['title'],
                quiz['date'],
                quiz['description'],
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  void showAddDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Quiz'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                ListTile(
                  title: Text(selectedDate == null
                      ? 'Select Date'
                      : 'Selected Date: ${selectedDate.toString().split(' ')[0]}'),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      selectedDate = date;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedDate != null && titleController.text.isNotEmpty) {
                  controller.addQuiz(
                    titleController.text,
                    selectedDate!,
                    descriptionController.text,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void showEditDialog(BuildContext context, String quizId, String initialTitle, DateTime initialDate, String initialDescription) {
    final titleController = TextEditingController(text: initialTitle);
    final descriptionController = TextEditingController(text: initialDescription);
    DateTime selectedDate = initialDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Quiz'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                ListTile(
                  title: Text('Selected Date: ${selectedDate.toString().split(' ')[0]}'),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      selectedDate = date;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.editQuiz(
                  quizId,
                  titleController.text,
                  selectedDate,
                  descriptionController.text,
                );
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget buildQuizCard(BuildContext context, String quizId, String title, String date, String description) {
    return Card(
      color: Colors.green.shade50,
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            Text(date, style: TextStyle(fontSize: 14.0, color: Colors.grey)),
            Text(description),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    controller.fetchQuestions(quizId);
                    Get.to(() => QuestionView(quizId: quizId));
                  },
                  icon: Icon(Icons.list, color: Colors.blue),
                  label: Text('View Questions', style: TextStyle(color: Colors.blue)),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.deleteQuiz(quizId),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.grey),
                  onPressed: () {
                    DateTime parsedDate = DateTime.parse(date);
                    showEditDialog(context, quizId, title, parsedDate, description);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionView extends StatelessWidget {
  final String quizId;
  const QuestionView({Key? key, required this.quizId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final QuizController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text('Questions'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showQuestionDialog(context, quizId);
            },
          ),
        ],
      ),
      body: Obx(() => ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: controller.questions.length,
            itemBuilder: (context, index) {
              final question = controller.questions[index];
              return buildQuestionCard(context, quizId, question);
            },
          )),
    );
  }

  Widget buildQuestionCard(BuildContext context, String quizId, Map<String, dynamic> question) {
    final QuizController controller = Get.find();
    return Card(
      color: Colors.grey.shade100,
      margin: EdgeInsets.only(bottom: 10.0),
      child: ListTile(
        title: Text(question['question']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (String option in question['options']) Text(option),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            controller.deleteQuestion(quizId, question['id']);
          },
        ),
        onTap: () {
          showQuestionDialog(context, quizId, question: question);
        },
      ),
    );
  }

  void showQuestionDialog(BuildContext context, String quizId, {Map<String, dynamic>? question}) {
    final QuizController controller = Get.find();
    final questionController = TextEditingController(text: question?['question'] ?? '');
    final optionControllers = [
      TextEditingController(text: question?['options'][0] ?? ''),
      TextEditingController(text: question?['options'][1] ?? ''),
      TextEditingController(text: question?['options'][2] ?? ''),
      TextEditingController(text: question?['options'][3] ?? ''),
    ];
    final correctAnswerController = TextEditingController(text: question?['correctAnswer'] ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(question == null ? 'Add Question' : 'Edit Question'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: questionController,
                  decoration: InputDecoration(labelText: 'Question'),
                ),
                for (int i = 0; i < optionControllers.length; i++)
                  TextField(
                    controller: optionControllers[i],
                    decoration: InputDecoration(labelText: 'Option ${i + 1}'),
                  ),
                TextField(
                  controller: correctAnswerController,
                  decoration: InputDecoration(labelText: 'Correct Answer'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (question == null) {
                  controller.addQuestion(
                    quizId,
                    questionController.text,
                    optionControllers.map((c) => c.text).toList(),
                    correctAnswerController.text,
                  );
                } else {
                  controller.editQuestion(
                    quizId,
                    question['id'],
                    questionController.text,
                    optionControllers.map((c) => c.text).toList(),
                    correctAnswerController.text,
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: QuizView(),
  ));
}
