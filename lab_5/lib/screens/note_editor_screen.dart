import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note; // null = tạo mới, có giá trị = chỉnh sửa

  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isModified = false;

  bool get isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.note?.title ?? '',
    );
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );

    // Lắng nghe thay đổi
    _titleController.addListener(_onChanged);
    _contentController.addListener(_onChanged);
  }

  void _onChanged() {
    if (!_isModified) {
      setState(() => _isModified = true);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // Lưu note
  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập tiêu đề!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final provider = context.read<NoteProvider>();
    final now = DateTime.now();

    if (isEditing) {
      // Cập nhật note cũ
      final updated = widget.note!.copyWith(
        title: title,
        content: content,
        updatedAt: now,
      );
      await provider.updateNote(updated);
    } else {
      // Tạo note mới
      final newNote = Note(
        title: title,
        content: content,
        createdAt: now,
        updatedAt: now,
      );
      await provider.addNote(newNote);
    }

    if (mounted) Navigator.pop(context);
  }

  // Xử lý back khi có thay đổi chưa lưu
  Future<bool> _onWillPop() async {
    if (!_isModified) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Hủy thay đổi?'),
        content: const Text(
            'Bạn có thay đổi chưa lưu. Bạn có muốn hủy không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Tiếp tục chỉnh sửa'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Hủy bỏ',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isModified,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFDE7),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFDE7),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && mounted) Navigator.pop(context);
            },
          ),
          title: Text(
            isEditing ? 'Edit Note' : 'New Note',
            style: const TextStyle(
              color: Color(0xFF212121),
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            // Nút Save
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton.icon(
                onPressed: _saveNote,
                icon: const Icon(Icons.save_outlined,
                    color: Color(0xFF1976D2)),
                label: const Text(
                  'Save',
                  style: TextStyle(
                    color: Color(0xFF1976D2),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // Title field
              TextField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFBDBDBD),
                  ),
                  border: InputBorder.none,
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),

              // Divider
              Divider(color: Colors.grey.withValues(alpha: 0.3)),

              const SizedBox(height: 8),

              // Content field
              Expanded(
                child: TextField(
                  controller: _contentController,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF424242),
                    height: 1.6,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Start writing your note...',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFBDBDBD),
                    ),
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}