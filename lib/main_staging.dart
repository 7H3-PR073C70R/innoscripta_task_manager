import 'package:innoscripta_task_manager/bootstrap.dart';
import 'package:innoscripta_task_manager/src/app/page/app.dart';
import 'package:innoscripta_task_manager/src/core/enums/enums.dart';

Future<void> main() {
  return bootstrap(
    builder: App.new,
    environment: Environment.staging,
  );
}
