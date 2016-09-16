import test from 'ava';
import esDepsFromString from './index';

const input = ['some', 'other'];

test('basic', t => {
  const actual = esDepsFromString(input);
  const expected = ['some', 'other'];
  t.deepEqual(actual, expected);
})

test.skip('empty input', t => t.throws(esDepsFromString(), TypeError));
test.skip('invalid files', t => t.throws(esDepsFromString(2), TypeError));
