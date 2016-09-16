import test from 'ava';
import esDepsFromString from './index';

test('basic', t => {
  const actual = esDepsFromString(input);
  const expected = ['some', 'other'];
  t.deepEqual(actual, expected);
})

test('empty input', t => t.throws(esDepsDeep(), TypeError));
test('invalid files', t => t.throws(esDepsDeep(2), TypeError));
