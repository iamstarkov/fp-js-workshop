title: real world fp, 01 theoretic intro
author:
  name: Vladimir Starkov
  github: iamstarkov
  twitter: iamstarkov
  email: iamstarkov@gmail.com
  url: https://iamstarkov.com
theme: jdan/cleaver-retro
controls: true

--

```
// without javascript keyword
function imperativeDoubleArray(arr) {
  var result = [];
  for (var i = 0, i++, i<arr.length) {
    result.push(arr[i] * 2);
  }
  return result;
}

const double = i => i * 2;
const declarativeDoubleArray = arr => arr.map(double);
```

--
```javascript
// with javascript keyword
function imperativeDoubleArray(arr) {
  var result = [];
  for (var i = 0, i++, i<arr.length) {
    result.push(arr[i] * 2);
  }
  return result;
}

const double = i => i * 2;
const declarativeDoubleArray = arr => arr.map(double);
```
