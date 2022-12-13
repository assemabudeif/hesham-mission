class NoteModel {
  int? id;
  int? notificationId;
  String? noteDate;
  String? noteTime;
  String? noteDay;
  String? voicePath;
  String? name;
  String? status;
  String? type;
  String? tableName;

  NoteModel({
    this.id,
    this.notificationId,
    this.name,
    this.voicePath,
    this.noteDate,
    this.noteTime,
    this.noteDay,
    this.status,
    this.type,
    this.tableName,
  });

  NoteModel.fromJson(Map<String, dynamic>? json) {
    id = json!['noteId'];
    notificationId = json['notificationId'];
    noteDate = json['noteDate'];
    noteTime = json['noteTime'];
    noteDay = json['noteDay'] ?? 'none';
    name = json['name'];
    voicePath = json['voicePath'];
    status = json['status'];
    type = json['type'];
    tableName = json['tableName'];
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'notificationId': notificationId,
        'noteDate': noteDate,
        'noteTime': noteTime,
        'noteDay': noteDay ?? 'none',
        'voicePath': voicePath,
        'status': status,
        'type': type,
        'tableName': tableName,
      };
}
