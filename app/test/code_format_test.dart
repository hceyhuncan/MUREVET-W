import 'package:flutter_test/flutter_test.dart';
import 'package:murevet/domain/code_format.dart';

void main() {
  test('kod normalleştirilir', () {
    expect(normalizeCode('abc d234'), 'ABCD234');
    expect(normalizeCode('ABC-D234'), 'ABCD234');
    expect(normalizeCode('ABCDEFGHJK'), 'ABCDEFGHJK');
  });
  test('karışan karakterler ve yanlış uzunluk reddedilir', () {
    expect(normalizeCode('ABCDEF0'), isNull); // 0 yok
    expect(normalizeCode('ABCDEFI'), isNull); // I yok
    expect(normalizeCode('ABC'), isNull);
    expect(normalizeCode('ABCDEFGH'), isNull); // 8 karakter
  });
}
