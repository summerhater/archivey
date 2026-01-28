import 'package:drift/drift.dart';

/// 웹 빌드 에러를 막기 위한 빈껍데기 실행기
QueryExecutor openConnection() {
  return LazyDatabase(() async => UnsupportedDatabase());
}

class UnsupportedDatabase extends QueryExecutor {
  @override
  SqlDialect get dialect => SqlDialect.sqlite;

  @override
  Future<bool> ensureOpen(QueryExecutorUser user) async => true;

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

  @override
  QueryExecutor beginExclusive() => this;

  @override
  Future<void> runBatched(BatchedStatements statements) async {}
}