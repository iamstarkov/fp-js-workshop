title: real world fp, 02 practical intro
theme: sudodoki/reveal-cleaver-theme
style: https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.6.0/styles/zenburn.min.css
controls: true

--

# real world fp
## #2 practical intro

<del>Monads, Comonad, Monoids, Setoids, Endofunctors.</del>  
Easy to understand, read, test and debug

<br/><br/><br/>
<small>by [Vladimir Starkov](https://iamstarkov.com)</small>  
<small>frontend engineer at [Nordnet Bank AB](https://www.nordnet.se/)</small>

--

## Toolbox

![](https://i.kinja-img.com/gawker-media/image/upload/s--IKcH8eFk--/c_fit,fl_progressive,q_80,w_636/18pabzmbdy79gjpg.jpg)

--

## Toolbox

* curry
* pipe (compose)
* debug: tap function
* collections
  * map
  * reduce
  * filter / reject
--

## curry, (as a blackbox)

It just works™

```javascript
const sum = (a, b, c) => a + b + c;
sum(1, 2, 3); // 6

const curriedSum = curry(sum);
curriedSum(1, 2, 3); // 6
curriedSum(1, 2)(3); // 6
curriedSum(1)(2)(3); // 6
curriedSum(1)(2, 3); // 6
```

--

## Curry, (from the inside)

For those, who are curious  
And for the reference

```javascript
const curry = fn => // takes function
  // returns a function to await for all arguments
  (...args) =>
    // if not all arguments provided
    args.length < fn.length
      // return curried function which accumulates other required arguments
      ? (...rest) => curry(fn)(...args, ...rest)
      // if all arguments are provided,
      // just invoke function with them
      : fn(...args)
```

--

## Curry, (Use cases)

When you need specific function, so you can create one from general function.

```javascript
// general
const add = curry((a, b) => a + b);

// specific
var increment = add(1); // b => add(1, b)
var addTen = add(10); // b => add(10, b)

increment(2); // 3
addTen(2); // 12
```

--

## Curry, (Use cases)

```javascript
const general = curry( (fn, data) => {
  // …
  return fn(data);
} );

const someFn = data => { /* do smth here */ }
const specific = general(someFn); // data => general(someFn, data);

specific(data); // general(someFn, data);

const anotherFn = data => { /* do smth else here */ }
const anotherSpecific = general(anotherFn); // data => general(anotherFn, data);

anotherSpecific(data); // general(anotherFn, data)
```

--

## Pipe, (as a blackbox)

Human readable functional composition.

It just works™

```javascript
const shout1 = str => exclaim(toUpperCase(str));
// or
const shout2 = str => pipe(toUpperCase, exclaim)(str);
// or
const shout3 = pipe(toUpperCase, exclaim); // left to right order

shout1('sup /js/'); // SUP /JS/!
shout2('sup /js/'); // SUP /JS/!
shout3('sup /js/'); // SUP /JS/!
```

--

## Pipe, (in depth)

For those, who are curious  
And for the reference

```javascript
// takes functions
// separate left most function from rest functions
const pipe = (headFN, ...restFns) =>
  // return piped function,
  (...args) => // which takes any arguments
    // invoke rest functions after each other
    restFns.reduce(
      // each function takes result of previous one
      (value, fn) => fn(value),
      // reduce's initial value is a left most function's result
      headFN(...args),
    );

const compose = (...fns) => pipe(...fns.reverse());
```

--

## Pipe, (Use cases)

When you need to convert one value to another and its complicated.

You need express this convertion in combination of steps, in which input value should be processed.

```javascript
// simple
const split = str => str.split('  ');
const addHashtag = str => '#' + str;
const join = arr => arr.join(' ');

// complex
// function takes 'sup js' returns '#sup #js'
// steps are: split, add hashtag to all items and join back
const hashtagify = pipe(
  split,
  arr => arr.map(addHashtag),
  join
);

hashtagify('sup js'); // '#sup #js'
```

--

## Debug, tap function

When you want to see whats going on  
on specific step of your pipe

> Runs the given function with the supplied value, then returns the value

```javascript
const tap = curry( (fn, value) => {
  fn(value);
  return value;
} );

const _log = val => console.log(val);
const log = tap(_log); // val => tap(_log, val);

log('test'); // same as `tap(_log, 'test')`
// console.log('test');
// return 'test';
```
---

## Debug, tap function

How to use that

```javascript
const hashtagify = pipe(
  log, // 'sup js'
  split,
  log, // ['sup', 'js']
  arr => arr.map(addHashtag),
  log, // ['#sup', '#js']
  join,
  log // '#sup #js'
);

hashtagify('sup js'); // '#sup #js'
```
--

## Collections

* No for loops
* No temporary variables

--

## Map Collections

When you need to convert one collection to another,  
while changing all items in the same manner

*tldr: collection to changed collection*

```javascript
const map = curry( (fn, arr) => arr.map(fn) );

const double = i => i * 2;
const doubleArr = map(double); // arr => map(double, arr);

doubleArr([1, 2, 3]); // [2, 4, 6]
//> map(double, [1, 2, 3]);

const addHashtag = str => '#' + str;
const addHashtagToArr = map(addHashtag); // arr => map(addHashtag, arr);

addHashtagToArr(['abc', 'xyz']);  // ['#abc', '#xyz']
//> map(addHashtag, ['abc', 'xyz']);
```

--

## Reduce Collections

When you need to reduce collection to single value.

*tldr: collection to changed collection*

```javascript
const reduce = curry( (fn, initial, arr) => arr.reduce(fn, initial) );

const sum = (a, b) => a + b;

const sumArr = reduce(sum, 0); //> arr => reduce(sum, 0, arr);

sumArr([1, 2, 3]); // 6
```
--

## Filter Collections
### and reject items from it

Filter — keep in collection only items, which satisfy you.

Reject is opposite — you want to drop some.

```javascript
const filter = curry( (fn, arr) => arr.filter(fn) );
const reject = curry( (fn, arr) => arr.filter(item => !fn(item)) );

const isEven = n => (n % 2 === 0);

const filterEven = filter(isEven); // arr => filter(isEven, arr);

const rejectEven = reject(isEven); // arr => reject(isEven, arr);

filterEven([1, 2, 3, 4]); // [2, 4]
rejectEven([1, 2, 3, 4]); // [1, 3]
```

--

## FP Toolbox, recap

```javascript
const map = curry( ( fn, arr ) => arr.map(fn));

const split = str => str.split(' ');
const addHashtag = str => '#' + str;
const join = str => str.join(' ');

const hashtagify = pipe(
  split,
  //> arr => arr.map(addHashtag)
  //> arr => map(addHashtag, arr)
  //> arr => map(addHashtag)(arr) === map(addHashtag)
  map(addHashtag),
  log, // ['#you', '#are', '#prepared!']
  join
);

hashtagify('you are prepared!') // '#you #are #prepared!'
```

--

## FP Toolbox, summary

* `curry` — to create specific functions
* `pipe` — to create complicated convertion
* debug: `tap` function — to be on track
* collections
  * `map` — change collection as a whole
  * `reduce` — reduce collection to single value
  * `filter` — keep items you need
  * `reject` — drop items you dont want
* No `for` loops
* No temporary variables

--

## Functional Programming, further reading

* [Mostly adequate guide to FP (in javascript)](https://github.com/MostlyAdequate/mostly-adequate-guide), book
* [Ramda](http://ramdajs.com/), as kind of FP's lodash
* [What Function Should I Use?](https://github.com/ramda/ramda/wiki/What-Function-Should-I-Use%3F)
* [Ramda Cookbook / Recipes](https://github.com/ramda/ramda/wiki/Cookbook)
* [Ramda's REPL](http://ramdajs.com/repl/)
* [Ramda Gitter Chat room](http://gitter.im/ramda/ramda)

--

## Live coding

![](https://m.popkey.co/6e322c/Al5Lp.gif)

--

## Functional Programming, (recursion)

["real world fp" workshop repo](https://github.com/iamstarkov/fp-js-workshop)  
["#2 practical intro" slides](https://iamstarkov.com/fp-js-workshop/02-practical-intro/)

To be continued with ["#3 async"](https://iamstarkov.com/fp-js-workshop/03-async/)

*Stay tuned*

--

# real world fp
## #2 practical intro

<br>
*In functions we trust*

Sincerely yours [Vladimir Starkov](https://iamstarkov.com)  
_@iamstarkov on [github](https://github.com/iamstarkov) and [twitter](https://twitter.com/iamstarkov)_
