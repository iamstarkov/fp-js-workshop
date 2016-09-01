title: real world fp, 03 async
theme: sudodoki/reveal-cleaver-theme
style: https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.6.0/styles/zenburn.min.css
controls: true

--

# real world fp
## #3 async

<del>Monads, Comonad, Monoids, Setoids, Endofunctors.</del>  
Easy to understand, read, test and debug

<br/><br/><br/>
<small>by [Vladimir Starkov](https://iamstarkov.com)</small>

--

## why

because js is one threaded
* synchronous operation blocks
  * ui in browser
  * other processes in node

--

## what

* network
* filesystem

*tip:* use `fs.readFileSync` or other `fs.*Sync` method to write slow nodejs apps.

--

## History

* XMLHttpRequest
* jquery ajax, deferred
* nodejs callbacks
* promises
* fetch

--

## XMLHttpRequest

```javascript
function reqListener () {
  console.log(this.responseText);
}

var oReq = new XMLHttpRequest();
oReq.addEventListener("load", reqListener);
oReq.open("GET", "http://www.example.org/example.txt");
oReq.send();
```

--

## XMLHttpRequest, bad

```javascript
const r = new XMLHttpRequest();
// false for async, so its sync now
r.open('GET', 'https://www.angio.net/pi/digits/pi1000000.txt', false);
r.send();
```
--

## jquery ajax, deferred

```javascript
$.ajax({
  dataType: "json",
  url: url,
  data: data,
  success: success
});
```

--

## nodejs callbacks

```javascript
fs.readFile('/etc/passwd', (err, data) => {
  if (err) throw err;
  console.log(data);
});
```

--

## promises

```
api.get('/api/2/login')
  .then(data => console.log(data));
```

--

## fetch

standard 101

--

## Async, network

```javascript
import fetch from 'fetch';

const networkHello = R.pipeP(
  fetch,             // fetch url
  res => res.json(), // get json
  obj => obj.foo,    
  str => str.toUpperCase() // convert to uppercase
)

networkHello('http://mockbin.org/bin/bbe7f656-12d6-4877-9fa8-5cd61f9522a9?foo=bar&foo=baz');
// "HELLO WORLD!"
```

--

## Async, fs

```javascript
import fs from 'fs';
import pify from 'pify';

// convert cb based fn to promise based one
const readFile = pify(fs.readFile);

const fsHello = R.pipeP(// open file, convert content to upper case
  readFile,
  str => str.toUpperCase
);

// > less input.txt
// Hello World!
fsHello('input.txt')
  .then(str => {
    console.log(str); // "HELLO WORLD!"
  });
```

--

## Async, summary

```javascript
const before = val =>
  PromiseFn(val)
    .then(fn1)
    .then(fn2)
    .then(fn3);

// equals
const now = R.pipeP(
  PromiseFn,
  fn1,
  fn2,
  fn3
);

before('some');
// same as
now('some');
```

--

## Further reading

* event loop in NodeJS
* callback hell
* Promises
* promises Cookbook
* fetch

--

## Functional Programming, (recursion)

["real world fp" repo](https://github.com/iamstarkov/fp-js-workshop), [this slides](https://iamstarkov.com/fp-js-workshop/03-async/)

To be continued with ["#3 contracts"](https://iamstarkov.com/fp-js-workshop/04-contracts/)

*Stay tuned*

--

# real world fp
## #3 async

<br>
*In functions we trust*

Sincerely yours [Vladimir Starkov](https://iamstarkov.com)  
_@iamstarkov on [github](https://github.com/iamstarkov) and [twitter](https://twitter.com/iamstarkov)_
