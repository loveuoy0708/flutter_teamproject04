class Assignment {
  Assignment({
    required this.title,
    required this.subject,
    required this.deadline,
    required this.priority,
    required this.estimatedTime,
    this.memo = '',
    this.completed = false,
  });

  String title;
  String subject;
  DateTime deadline;
  String priority;
  String estimatedTime;
  String memo;
  bool completed;
}
