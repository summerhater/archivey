import 'package:drift/drift.dart';

// 웹 빌드 에러를 막기 위한 '빈(Empty)' 실행기입니다.
QueryExecutor openConnection() {
  return LazyDatabase(() async => UnsupportedDatabase());
}

class UnsupportedDatabase extends QueryExecutor {
  @override
  bool get canBeginTransaction => false;
  @override
  Future<void> runCustom(String statement, [List<Object?>? args]) async {}
  @override
  Future<int> runDelete(String statement, List<Object?> args) async => 0;
  @override
  Future<int> runInsert(String statement, List<Object?> args) async => 0;
  @override
  Future<List<Map<String, dynamic>>> runSelect(String statement, List<Object?> args) async => [];
  @override
  Future<int> runUpdate(String statement, List<Object?> args) async => 0;
  @override
  TransactionExecutor beginTransaction() => throw UnimplementedError();
}