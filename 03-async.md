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
$.ajax({
  dataType: "json",
  url: url,
  data: data,
  success: hey => { console.log('im done!'); }
});
```

*[Deprecated](https://developer.mozilla.org/en-US/docs/Mozilla/JavaScript_code_modules/Promise.jsm/Deferred)*

--

## nodejs callbacks, kind of good

```javascript
fs.readFile('/etc/passwd', (err, data) => {
  if (err) throw err;
  console.log(data);
});
```

--
## nodejs callbacks, but not really

![](http://icompile.eladkarako.com/wp-content/uploads/2016/01/icompile.eladkarako.com_callback_hell.gif)
--

## nodejs callbacks, but not really

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
  .then(data => console.log(data));
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

--

## fetch 101

> any API that involves networking e.g., `<img src>`, `<a href>` (through navigation), `XMLHttpRequest`, `@font-face`, `WebSocket`) goes through Fetch  
> — [Fetch Standard 101](https://annevankesteren.nl/2016/07/fetch-101)

--


## how to write code with promises

```javascript
const loadImage = url => new Promise((resolve, reject) => {
  const image = new Image();

  image.onload = () => { resolve(image); };

  image.onerror = () => { reject(
    new Error('Could not load image at ' + url)
  )};

  image.src = url;
});

export default loadImage;
```

* *Note 1:* reject only with `new Error('err desc')`
* *Note 2:* [throw and implicit catch](https://github.com/mattdesl/promise-cookbook#throw-and-implicit-catch)

--

## how to use promises

```javascript
import loadImage from '../utils/loadImage';

loadImage('harambe.jpg')
  .then(image => { console.log('save harambe!') })
  .catch(err => console.error(err)); // error handling
```

*note:* error handling on usage,  
not implementation

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
  .catch(err => console.error(err)); // error handling belongs only to implementation
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

## PipeP to the rescue

* Takes promises, returns Promise
* Returns *piped* function which takes `arguments`
* Invokes (left to right) each passed promise after each other
* Every next promise will get calculation result of previous one
* Note: right left most promise can take any arguments

--

## PipeP to the rescue, in short

`promise1(x).then(promise2)`  
equals  
`pipeP(promise1, promise2)(x)`

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
  api('/api/status').
  data => data.session_type,
  type => type === 'authenticated'
);

isAuthenticated()
  .then(isAuthenticated => console.log(isAuthenticated))
  .catch(err => console.error(err)); // error handling belongs only to implementation
```

--

## Promises composition

For those, who are curious  
And for the reference

```javascript
// function composition (left to right)
const pipe = (headFN, ...restFns) => (...args) => restFns.reduce(
  (value, fn) => fn(value),
  headFN(...args),
);

// promises composition (left to right)
const pipeP = (headPromiseFn, ...restPromiseFns) => (...args) => restPromiseFns.reduce(
  (promiseValue, promiseFn) => promiseValue.then(promiseFn)
  headPromiseFn(...args)
);
```
Note: as far as Promise chain can handle regular functions, pipeP can handle them as well.

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
  PromiseFn(val)
    .then(fn1)
    .then(fn2)
    .then(fn3); */

const asyncOperation = R.pipeP(
  PromiseFn,
  fn1,
  fn2,
  fn3
);

asyncOperation('some')
  .then(result => console.log(result)) // your result
  .catch(err => console.error(err));   // error handling
```

--

## Async FP, summary 2

```javascript
// composition
const funPipe = pipe(
  fun1, fun2, fun3
);

const promisePipe = pipeP(
  promise1, promise2, promise2
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

["real world fp" repo](https://github.com/iamstarkov/fp-js-workshop), [this slides](https://iamstarkov.com/fp-js-workshop/03-async/)

To be continued with ["#4 contracts"](https://iamstarkov.com/fp-js-workshop/04-contracts/)

*Stay tuned*

--

# real world fp
## #3 async

<br>
*In functions we trust*

Sincerely yours [Vladimir Starkov](https://iamstarkov.com)  
_@iamstarkov on [github](https://github.com/iamstarkov) and [twitter](https://twitter.com/iamstarkov)_
