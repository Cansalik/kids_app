import 'dart:convert';

class QuizTable {
  int? categoryId;
  int? subCategoryId;
  int? quizId;
  String? question;
  String? answer;
  String? option1;
  String? option2;
  String? option3;
  String? option4;

  QuizTable({
    this.categoryId,
    this.subCategoryId,
    this.question,
    this.answer,
    this.option1,
    this.option2,
    this.option3,
    this.option4,
    this.quizId,
  });

  factory QuizTable.fromRawJson(String str) =>
      QuizTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QuizTable.fromJson(Map<String, dynamic> json) =>
      QuizTable(
        categoryId: json["category_id"],
        subCategoryId: json["sub_category_id"],
        question: json["question"],
        answer: json["answer"],
        option1: json["option1"],
        option2: json["option2"],
        option3: json["option3"],
        option4: json["option4"],
        quizId: json["quiz_id"],

      );

  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "sub_category_id": subCategoryId,
    "question": question,
    "answer": answer,
    "option1": option1,
    "option2": option2,
    "option3": option3,
    "option4": option4,
    "quiz_id": quizId,
  };
}
