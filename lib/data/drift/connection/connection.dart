import 'package:drift/drift.dart';

/// 인터페이스 역할: 플랫폼에 맞는 openConnection을 찾아감
QueryExecutor openConnection() => throw UnsupportedError('플랫폼을 알 수 없습니다.');