
import 'package:flutter/material.dart';
import 'task_model.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onCompletionChanged,
  });

  final Assignment task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onCompletionChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFD),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFF0E5E0),
        ),
      ),
      child: Row(
        children: [
          // 과제 완료 체크
          Checkbox(
            value: task.completed,
            activeColor: const Color(0xFF9B6848),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onChanged: (value) {
              onCompletionChanged(value ?? false);
            },
          ),

          // 과제 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    color: const Color(0xFF49352D),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    decoration: task.completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),

                const SizedBox(height: 7),

                Row(
                  children: [
                    // 중요도
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: task.priority == '높음'
                            ? const Color(0xFFFFE5E0)
                            : const Color(0xFFF5EDE7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task.priority,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9B6848),
                        ),
                      ),
                    ),

                    const SizedBox(width: 9),

                    // 마감일
                    Text(
                      '${task.deadline.year}.'
                      '${task.deadline.month.toString().padLeft(2, '0')}.'
                      '${task.deadline.day.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFFAA9690),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 수정 버튼
          IconButton(
            onPressed: onEdit,
            icon: const Icon(
              Icons.edit_outlined,
              size: 19,
              color: Color(0xFF9B6848),
            ),
          ),

          // 삭제 버튼
          IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outline,
              size: 19,
              color: Color(0xFFE9857D),
            ),
          ),
        ],
      ),
    );
  }
}
