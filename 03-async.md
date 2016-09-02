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

## why async

'cause its single threaded

--

## why

synchronous operation blocks:
  * ui in browser
  * other processes in node

--

## what

* network
* filesystem

--

## History

![](http://www.warmingtonheritage.com/wp-content/uploads/2011/06/PICT0006.jpg)
--

## History

* XMLHttpRequest
* jquery ajax, deferred
* nodejs callbacks
* promises

--

## XMLHttpRequest, meh

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

## jquery ajax, deferred, better

```javascript
$.getJSON('example.json')
  .done(() => console.log('success'))
  .fail(() => console.log('error'))
  .always(() => console.log('complete'));
```

* *[almost deprecated in jquery 3.0 release](https://developer.mozilla.org/en-US/docs/Mozilla/JavaScript_code_modules/Promise.jsm/Deferred)*,
* and now Promises/A+ compatible

--

## nodejs callbacks, kind of good

```javascript
fs.readFile('/etc/passwd', (err, data) => {
  if (err) throw err;
  console.log(data);
});
```

--
## nodejs callbacks, good,  but not really

![](http://icompile.eladkarako.com/wp-content/uploads/2016/01/icompile.eladkarako.com_callback_hell.gif)
--

## nodejs callbacks, not good at all

```javascript
loadImage('one.png', function(err, image1) {
  if (err) throw err;

  loadImage('two.png', function(err, image2) {
    if (err) throw err;

    loadImage('three.png', function(err, image3) {
      if (err) throw err;

      var images = [image1, image2, image3];
      console.log('All images loaded', images);
    });
  });
});
```


--

## promises

```javascript
api.get('/api/2/login')
  .then(data => console.log(data))
  .catch(err => console.error(err));
```

---

## promises, much better

```javascript
const allImages = [
  loadImage('one.png'),
  loadImage('two.png'),
  loadImage('three.png'),  
];

Promise.all(allImages)
  .then(images => {
    console.log('All images loaded!');
  });
```

--

## why promises

### Promises > callbacks

> any (browser) API that involves networking e.g., `<img src>`, `<a href>`, `XMLHttpRequest`, `@font-face`, `WebSocket`) goes through Fetch  
> — [Fetch Standard 101](https://annevankesteren.nl/2016/07/fetch-101)

Fetch is promise based standard for network calls.

--


## how to write code with promises

```javascript
const getImagesByTopic = topic =>
  fetch(`/api/images/?topic=${topic}`)
    .then(res => res.json());

export default getImagesByTopic;
```

* *Note 0:* always return functions
* *Note 1:* reject only with `new Error('err desc')`
* *Note 2:* be aware of [`throw` and implicit catch](https://github.com/mattdesl/promise-cookbook#throw-and-implicit-catch)

--

## how to use promises

```javascript
import getImagesByTopic from '../utils/getImagesByTopic';

getImageUrlsFromAPI('harambe')
  .then(image => { console.log('save harambe!') })
  .catch(err => console.error(err)); // error handling
```

*note:* handle errors when you actually using promises, not in implementation

--

## Promise chain

```javascript
// implementation
const api = url => fetch(url).then(res => res.json());

const isAuthenticated = () =>
  api('/api/status')
    .then(data => data.session_type)
    .then(type => type === 'authenticated');

// usage
isAuthenticated()
  .then(isAuthenticated => console.log(isAuthenticated))
  .catch(err => console.error(err));
  // error handling belongs only to implementation
```
--

## Can we do it better?

### Compose 'em all!

![](https://nerdist.com/wp-content/uploads/2016/07/7ie3E.jpg)

--

## pipe, function composition recap

```javascript
const double = x => x * 2;
const inc = x => x + 1;

const incAndDouble1 = x => double(inc(x));
const incAndDouble2 = x => pipe(inc, double)(x);
const incAndDouble3 = pipe(inc, double);

incAndDouble1(10); // 22
incAndDouble2(10); // 22
incAndDouble3(10); // 22
```

TL;DR: want to inc and double = `pipe(inc, double)`

--

## PipeP to the rescue, in short

`promise1(x).then(promise2)`  
equals  
`pipeP(promise1, promise2, fn1)(x)`

--

## PipeP to the rescue

* *Note: promised based function — function, which returns Promise, which resolves to some value*
* Takes several promise based functions or functions
* Returns one promise based function which takes `arguments`
* Invokes (left to right) each passed function one after another
* Every next function will get calculation result of previous one
* Note 1: left most function can take any arguments
* Note 2: only left most function required to be promise based function

--

## PipeP, (as a blackbox)

Human readable promises composition.

It just works™

```javascript
// const api = url => fetch(url).then(res => res.json());
const api = pipeP(fetch, res => res.json()); // url => pipeP(…)(url);

/* const isAuthenticated = () =>
  api('/api/status')
    .then(data => data.session_type)
    .then(type => type === 'authenticated'); */
const isAuthenticated = pipeP(
  api('/api/status'),
  data => data.session_type,
  type => type === 'authenticated'
);

isAuthenticated()
  .then(isAuthenticated => console.log(isAuthenticated))
  .catch(err => console.error(err)); // error handling belongs to usage
```

--

## Promises composition

For those, who are curious  
And for the reference

```javascript
// synchronous composition
// function composition (left to right)
const pipe = (headFN, ...restFns) => (...args) => restFns.reduce(
  (value, fn) => fn(value),
  headFN(...args),
);

// asynchronous composition
// promises composition (left to right)
const pipeP = (headPromiseFn, ...restPromiseFns) => (...args) => restPromiseFns.reduce(
  (promiseValue, promiseFn) => promiseValue.then(promiseFn),
  headPromiseFn(...args)
);
```

Note: as far as Promise chain can handle regular functions, pipeP can handle them as well

--

## Async FP, network

```javascript
import fetch from 'fetch';

const networkHello = R.pipeP(
  fetch,             // fetch url
  res => res.json(), // get json
  obj => obj.foo,
  str => str.toUpperCase() // convert to uppercase
)

const mockBin = 'http://mockbin.org/bin/bbe7f656-12d6-4877-9fa8-5cd61f9522a9?foo=bar&foo=baz';

networkHello(mockBin)
  .then(str => console.log(str)) // "HELLO WORLD!"
  .catch(err => console.error(err)); // error handling
```

--

## Async FP, filesystem

```javascript
import fs from 'fs';
const readFile = file => new Promise((resolve, reject) => {
  fs.readFile(file, { encoding: 'utf8' }, (err, res) => {
    (err) ? reject(err) : resolve(res);
  })
});

const fsHello = R.pipeP(// open file, convert content to upper case
  readFile,
  str => str.toUpperCase
);

// > less input.txt
// Hello World!
fsHello('input.txt')
  .then(str => console.log(str); ) // "HELLO WORLD!"
  .catch(err => console.error(err)); // error handling
```

--

## Async FP, summary

```javascript
/* const asyncOperation = val =>
  promiseFn1(val)
    .then(fn2)
    .then(fn3)
    .then(promiseFn4)
    .then(fn5); */

const asyncOperation = R.pipeP(
  promiseFn1,
  fn2,
  fn3,
  promiseFn4,
  fn5
);

asyncOperation('some')
  .then(result => console.log(result)) // your result
  .catch(err => console.error(err));   // error handling
```

--

## Async FP, summary 2

```javascript
// synchronous composition
const funPipe = pipe(
  fun1, fun2, fun3
);

// asynchronous composition
const promisePipe = pipeP(
  promiseFn1, promiseFn2, promiseFn3,
  // you can use regular functions here also
);

// usage
funPipe('some'); // result
promisePipe('some')
  .then(result => console.log(result)) // result
  .catch(err => console.error(err));   // error handling
```

--

## Further reading

* [What the heck is the event loop anyway?](https://www.youtube.com/watch?v=8aGhZQkoFbQ)
* http://callbackhell.com/
* [Fetch Standard 101](https://annevankesteren.nl/2016/07/fetch-101)
* [mdn Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise)
* [promises Cookbook](https://github.com/mattdesl/promise-cookbook)
* ["You Don't Know JS: Async & Performance"  
Chapter 3: Promises](https://github.com/getify/You-Dont-Know-JS/blob/master/async%20%26%20performance/ch3.md)
--

## Functional Programming, (recursion)

["real world fp" repo](https://github.com/iamstarkov/fp-js-workshop)  
["#3 async" slides](https://iamstarkov.com/fp-js-workshop/03-async/)

To be continued with ["#4 contracts"](https://iamstarkov.com/fp-js-workshop/04-contracts/)

*Stay tuned*

--

# real world fp
## #3 async

<br>
*In functions we trust*

Sincerely yours [Vladimir Starkov](https://iamstarkov.com)  
_@iamstarkov on [github](https://github.com/iamstarkov) and [twitter](https://twitter.com/iamstarkov)_
