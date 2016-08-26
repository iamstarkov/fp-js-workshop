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

--

## Toolbox

![](https://i.kinja-img.com/gawker-media/image/upload/s--IKcH8eFk--/c_fit,fl_progressive,q_80,w_636/18pabzmbdy79gjpg.jpg)

--

## Toolbox

* curry
* pipe (compose)
* single value, just write this function
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

For those, who are curious:

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
const specificBefore = data => {
  // …
  const internalFn1 = data => { /* do smth here */ };
  // …
  return internalFn1(data);
};
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

cosnt anotherFn = data => { /* do smth else here */ }
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

You need express this convertion in combination of steps, in which input should be processed after each other.

```javascript
// simple
const split = str => str.split('  ');
const addHashtag = arr => arr.map(str => '#' + str);
const join = arr => arr.join(' ');

// complex
// function takes 'sup js' returns '#sup #js'
// steps are: split, add hashtag and join back
const hashtagify = pipe(split, addHashtag, join);

hashtagify('sup js'); // '#sup #js'
```

--

## Debug, tap function

When you to see whats going on on specific step of your pipe.

```javascript
const tap = curry( (fn, value) => {
  fn(value);
  return value;
} );

const _log = val => console.log(val);
const log = tap(_log); // val => tap(_log, val);

const hashtagify = pipe(
  log, // 'sup js'
  split,
  log, // ['sup', 'js']
  addHashtag,
  log, // ['#sup', '#js']
  join,
  log // '#sup #js'
);

hashtagify('sup js'); // '#sup #js'
```

--

## Functional Programming, further reading

* list of links

--

## Functional Programming, (recursion)

["real world fp" repo](https://github.com/iamstarkov/fp-js-workshop), [this slides](https://iamstarkov.com/fp-js-workshop/02-practical-intro/)

To be continued with live coding real world node modules

*Stay tuned*

--

# real world fp
## #2 practical intro

<br>
*In functions we trust*

Sincerely yours [Vladimir Starkov](https://iamstarkov.com)  
_@iamstarkov on [github](https://github.com/iamstarkov) and [twitter](https://twitter.com/iamstarkov)_
