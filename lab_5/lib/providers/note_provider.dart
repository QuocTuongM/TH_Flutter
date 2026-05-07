import 'package:flutter/material.dart';
import '../models/note.dart';
import '../database/db_helper.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];
  List<Note> _searchResults = [];
  bool _isSearching = false;
  bool _isLoading = false;

  List<Note> get notes => _isSearching ? _searchResults : _notes;
  bool get isSearching => _isSearching;
  bool get isLoading => _isLoading;

  NoteProvider() {
    loadNotes();
  }

  // Load tất cả notes từ database
  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();

    _notes = await DatabaseHelper.instance.readAll();

    _isLoading = false;
    notifyListeners();
  }

  // Thêm note mới
  Future<void> addNote(Note note) async {
    await DatabaseHelper.instance.create(note);
    await loadNotes();
  }

  // Cập nhật note
  Future<void> updateNote(Note note) async {
    await DatabaseHelper.instance.update(note);
    await loadNotes();
  }

  // Xóa note
  Future<void> deleteNote(int id) async {
    await DatabaseHelper.instance.delete(id);
    await loadNotes();
  }

  // Tìm kiếm notes
  Future<void> searchNotes(String query) async {
    if (query.isEmpty) {
      _isSearching = false;
      _searchResults = [];
    } else {
      _isSearching = true;
      _searchResults = await DatabaseHelper.instance.search(query);
    }
    notifyListeners();
  }

  // Dừng tìm kiếm
  void stopSearch() {
    _isSearching = false;
    _searchResults = [];
    notifyListeners();
  }

  // Lấy tổng số notes
  int get noteCount => _notes.length;
}