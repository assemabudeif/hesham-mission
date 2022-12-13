import 'package:flutter/material.dart';

const KBackgroundColor = Color(0xFFF1EFF1);
const KPrimaryColor = Color(0xfffc2904);
const KSecondaryColor = Color(0xfff3d49f);
const KTextColor = Color(0xFFCEFFC9);
const KgrayColor = Color(0xFFD8DAD8);
const KTextLightColor = Color(0xFF1A1414);
const KdividerColor = Color(0x8B0C0B0B);
const KIcon1Color = Color(0xE8FA6631);
const KIcon2Color = Color(0xE836C70B);
const KIcon3Color = Color(0xE8444D46);
const KDefaultPadding = 20.0;

const dbName = 'notes.db';
const tableName = 'singleNotes';
const archiveTableName = 'archiveTable';
const fixedTableName = 'fixedTable';
const dbVersion = 1;

//cols
const colId = 'noteId';
const colNotificationId = 'notificationId';
const colVoicePath = 'voicePath';
const colDate = 'noteDate';
const colTime = 'noteTime';
const colDay = 'noteDay';
const colName = 'name';
const colStatus = 'status';
const colType = 'type';
const colTableName = 'tableName';

// values
const noteStatusNotComplete = 'لم يتم';
const noteStatusComplete = 'تم';
const noteStatusArchive = 'Archive';

const noteTypeSingle = 'Single';
const noteTypeMulti = 'Multi';
const noteTypeFixed = 'Fixed';

const channelKey = 'scheduled_notification';

int? noteId;

const complexMissionNamesKey = 'complexMissionNames';
List<String> complexMissionNames = [];

const fixedMissionNamesKey = 'fixedMissionNames';
List<String> fixedMissionNames = [];
