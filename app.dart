
void main() {
  const text = 'caio@mail.com';
  final parts = text.split('@');
  for (final part in parts) {
    print('-- $part');
  }
}
