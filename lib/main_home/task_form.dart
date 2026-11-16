
import 'package:flutter/material.dart';
import 'task_model.dart';

const Color formBrown = Color(0xFF9B6848);
const Color formText = Color(0xFF49352D);
const Color formMuted = Color(0xFFAA9690);
const Color formBg = Color(0xFFFFF8F5);
const Color formLine = Color(0xFFF0E5E0);

class TaskForm extends StatefulWidget {
  final Assignment? task;

  const TaskForm({
    super.key,
    this.task,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _titleController = TextEditingController();
  final _memoController = TextEditingController();

  String _subject = '전공';
  String _priority = '보통';
  String _estimatedTime = '1시간';

  DateTime _deadline = DateTime.now();

  @override
  void initState() {
    super.initState();

    final task = widget.task;

    if (task != null) {
      _titleController.text = task.title;
      _memoController.text = task.memo;
      _subject = task.subject;
      _priority = task.priority;
      _estimatedTime = task.estimatedTime;
      _deadline = task.deadline;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: formBrown,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selected != null) {
      setState(() {
        _deadline = selected;
      });
    }
  }

  void _saveTask() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('과제명을 입력해 주세요.'),
        ),
      );
      return;
    }

    final result = Assignment(
      title: _titleController.text.trim(),
      subject: _subject,
      deadline: _deadline,
      priority: _priority,
      estimatedTime: _estimatedTime,
      memo: _memoController.text.trim(),
      completed: widget.task?.completed ?? false,
    );

    Navigator.pop(context, result);
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        title,
        style: const TextStyle(
          color: formText,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    String hint = '',
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: formMuted,
          fontSize: 13,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: formLine),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: formLine),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: formBrown),
        ),
      ),
    );
  }

  Widget _choiceButtons({
    required List<String> options,
    required String selected,
    required ValueChanged<String> onChanged,
  }) {
    return Wrap(
      spacing: 8,
      children: options.map((value) {
        final isSelected = selected == value;

        return ChoiceChip(
          label: Text(value),
          selected: isSelected,
          onSelected: (_) => onChanged(value),
          selectedColor: formBrown,
          backgroundColor: Colors.white,
          side: const BorderSide(color: formLine),
          showCheckmark: false,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : formMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Container(
      decoration: const BoxDecoration(
        color: formBg,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 15, 22, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: formLine,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Text(
                isEditing ? '과제 수정하기 ✏️' : '새 과제 추가하기 ✨',
                style: const TextStyle(
                  color: formText,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 23),

              _sectionTitle('과제명'),

              _inputField(
                controller: _titleController,
                hint: '과제명을 입력해 주세요.',
              ),

              const SizedBox(height: 20),

              _sectionTitle('과제 종류'),

              _choiceButtons(
                options: const ['전공', '교양'],
                selected: _subject,
                onChanged: (value) {
                  setState(() => _subject = value);
                },
              ),

              const SizedBox(height: 20),

              _sectionTitle('중요도'),

              _choiceButtons(
                options: const ['높음', '보통', '낮음'],
                selected: _priority,
                onChanged: (value) {
                  setState(() => _priority = value);
                },
              ),

              const SizedBox(height: 20),

              _sectionTitle('마감일'),

              InkWell(
                onTap: _selectDeadline,
                borderRadius: BorderRadius.circular(13),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: formLine),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: formBrown,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${_deadline.year}년 '
                        '${_deadline.month}월 '
                        '${_deadline.day}일',
                        style: const TextStyle(
                          color: formText,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: formMuted,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _sectionTitle('예상 소요 시간'),

              _choiceButtons(
                options: const [
                  '30분',
                  '1시간',
                  '2시간',
                  '3시간 이상',
                ],
                selected: _estimatedTime,
                onChanged: (value) {
                  setState(() => _estimatedTime = value);
                },
              ),

              const SizedBox(height: 20),

              _sectionTitle('메모 (선택사항)'),

              _inputField(
                controller: _memoController,
                hint: '추가로 기록할 내용이 있나요?',
                maxLines: 3,
              ),

              const SizedBox(height: 27),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: formBrown,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    isEditing ? '수정 완료' : '과제 등록하기',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
