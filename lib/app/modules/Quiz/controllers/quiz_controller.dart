import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class QuizController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Objek yang digunakan untuk menyimpan data quiz dan questions dari Firestore
  var quizzes = <Map<String, dynamic>>[].obs;
  var questions = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuizzes();
  }

  // Fungsi untuk mengambil data quiz dari Firestore
  void fetchQuizzes() async {
    final querySnapshot = await _firestore.collection('quizzes').get();
    quizzes.value = querySnapshot.docs.map((doc) => {
      'id': doc.id,
      'title': doc['title'],
      'date': (doc['date'] as Timestamp).toDate().toString(), // Konversi Timestamp ke String
      'description': doc['description'],
    }).toList();
  }

  // Fungsi untuk menambah data quiz baru
  Future<void> addQuiz(String title, DateTime date, String description) async {
    DocumentReference docRef = await _firestore.collection('quizzes').add({
      'title': title,
      'date': Timestamp.fromDate(date), // Simpan sebagai Timestamp
      'description': description,
    });
    print('Quiz added with ID: ${docRef.id}'); // Mendapatkan ID dokumen yang dihasilkan
    fetchQuizzes(); // Refresh data setelah menambah
  }

  // Fungsi untuk mengedit data quiz
  Future<void> editQuiz(String id, String title, DateTime date, String description) async {
    await _firestore.collection('quizzes').doc(id).update({
      'title': title,
      'date': Timestamp.fromDate(date), // Simpan sebagai Timestamp
      'description': description,
    });
    fetchQuizzes(); // Refresh data setelah update
  }

  // Fungsi untuk menghapus quiz
  Future<void> deleteQuiz(String id) async {
    await _firestore.collection('quizzes').doc(id).delete();
    fetchQuizzes(); // Refresh data setelah hapus
  }

  // Fungsi untuk mengambil data pertanyaan dari Firestore berdasarkan quizId
  void fetchQuestions(String quizId) async {
    final questionSnapshot = await _firestore
        .collection('quizzes')
        .doc(quizId)
        .collection('questions')
        .get();

    questions.value = questionSnapshot.docs.map((doc) => {
      'id': doc.id,
      'question': doc['question'],
      'options': doc['options'],
      'correctAnswer': doc['correctAnswer'],
    }).toList();
  }

  // Fungsi untuk menambah pertanyaan ke dalam quiz
  Future<void> addQuestion(String quizId, String question, List<String> options, String correctAnswer) async {
    await _firestore.collection('quizzes').doc(quizId).collection('questions').add({
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
    });
    fetchQuestions(quizId); // Refresh data setelah menambah
  }

  // Fungsi untuk mengedit pertanyaan
  Future<void> editQuestion(String quizId, String questionId, String question, List<String> options, String correctAnswer) async {
    await _firestore
        .collection('quizzes')
        .doc(quizId)
        .collection('questions')
        .doc(questionId)
        .update({
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
    });
    fetchQuestions(quizId); // Refresh data setelah update
  }

  // Fungsi untuk menghapus pertanyaan
  Future<void> deleteQuestion(String quizId, String questionId) async {
    await _firestore
        .collection('quizzes')
        .doc(quizId)
        .collection('questions')
        .doc(questionId)
        .delete();
    fetchQuestions(quizId); // Refresh data setelah hapus
  }
}
