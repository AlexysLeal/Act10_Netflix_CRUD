import 'dart:io';

void main() async {
  print('🚀 CONFIGURADOR DE GITHUB PARA NETFLIX ADMIN PANEL\n');

  stdout.write(
    '🔗 Ingresa la URL de tu repositorio GitHub:\n'
    '(Ejemplo: https://github.com/usuario/netflix-admin-panel.git)\n\n> ',
  );

  String? repoUrl = stdin.readLineSync();

  if (repoUrl == null || repoUrl.trim().isEmpty) {
    print('\n❌ Debes ingresar una URL válida.');
    return;
  }

  try {
    print('\n📦 Inicializando Git...\n');

    await _runCommand('git', ['init']);

    print('📁 Agregando archivos...\n');

    await _runCommand('git', ['add', '.']);

    print('📝 Creando commit...\n');

    await _runCommand('git', [
      'commit',
      '-m',
      'Proyecto Final Netflix Admin Panel',
    ]);

    print('🌐 Conectando repositorio remoto...\n');

    await _runCommand('git', ['remote', 'remove', 'origin'], ignoreError: true);

    await _runCommand('git', ['remote', 'add', 'origin', repoUrl]);

    print('⬆️ Enviando proyecto a GitHub...\n');

    await _runCommand('git', ['branch', '-M', 'main']);

    await _runCommand('git', ['push', '-u', 'origin', 'main']);

    print('\n✅ PROYECTO SUBIDO EXITOSAMENTE A GITHUB');
    print('🎬 Netflix Admin Panel listo.');
  } catch (e) {
    print('\n❌ ERROR DURANTE EL PROCESO');
    print(e);
  }
}

Future<void> _runCommand(
  String executable,
  List<String> arguments, {
  bool ignoreError = false,
}) async {
  print('> $executable ${arguments.join(' ')}');

  final result = await Process.run(executable, arguments, runInShell: true);

  if (result.stdout.toString().isNotEmpty) {
    print(result.stdout);
  }

  if (result.stderr.toString().isNotEmpty) {
    print(result.stderr);
  }

  if (result.exitCode != 0 && !ignoreError) {
    throw Exception('Error ejecutando comando: $executable');
  }
}
