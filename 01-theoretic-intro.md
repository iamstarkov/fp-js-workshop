title: real world fp, 01 theoretic intro
author:
  name: Vladimir Starkov
  twitter: iamstarkov
  email: iamstarkov@gmail.com
  url: https://iamstarkov.com
output: 01-theoretic-intro.html
theme: sudodoki/reveal-cleaver-theme
controls: true

--

# real world fp
## #1 theoretic intro

<del>Monads, Comonad, Monoids, Setoids, Endofunctors.</del>  
Easy to understand, read, test and debug

--

## Functional programming

* declarative programming paradigm
* computation as the evaluation of mathematical functions
* avoids changing-state and mutable data and side-effects
* encourage functional composition

--

## declarative vs imperative

```javascript
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

## mathematical function, `f(x)`

> Function is a relation between a set of inputs and a set of permissible outputs with the property that each input is related to exactly one output. `f(x)`. aka pure function in computer science  
> — [Wikipedia][wiki1]

*same input = same output, in short*
[wiki1]: https://en.wikipedia.org/wiki/Function_(mathematics))

--

## Pure function

> A pure function is a function that, given the same input, will always return the same output and does not have any observable side effect.  
> — ["Mostly adequate guide to FP"](https://drboolean.gitbooks.io/mostly-adequate-guide/content/ch3.html#oh-to-be-pure-again)

--

## Pure function, in examples

```javascript
// pure
const multiply = (x, y) => x * y;
const double = x => x * 2;

// impure
xs.splice(0, 3);

// also impure
var minimum = 21;
var checkAge = function(age) {
  return age >= minimum;
};
```

--

## Pure function

* Predictability, with [immutability](https://iamstarkov.com/why-immutability-matters/)
* Referential Transparency
* Cacheable / memoizability, `// e.g. hash table`
* Portable / Self-Documenting
* Testable
* Parallel Code / concurrency

--

## avoids changing-state

* **global variables** makes your function unpredictable
* **state, internal variables**, same as global variables but from within

```javascript
console.log('sup /js/') // 'sup /js/'

const log = console.log;
log('sup /js/'); // TypeError: 'log' called on an object…
// because method `log` needs console's
// internal variable `this` — state
```

--

## Side effects

* changing the file system
* database operations
* network requests
* mutations
* printing to the screen / logging
* obtaining user input
* querying the DOM
* accessing system state

--

## Side effects, exactly

```javascript
// mutation, aka side-effects
var arr1 = [1, 3, 2];
arr1.sort(); // [1, 2, 3]
arr1; // [1, 2, 3] wtf mutation

var arr2 = [1, 3, 2];
const sort = arr => arr.sort();
sort(arr2); // [1, 2, 3]
arr2; // [1, 2, 3] wtf mutation

var arr3 = [1, 2, 3];
arr3.slice(1, 2); // [2]
arr3; // [1, 2, 3]
arr3.splice(1, 2); // [2, 3]
arr3; // [1] wtf mutation
```

--

## Side effects and FP

We are not prohibiting side effects, but more like controlling them.
Because without them we can't do anything useful for real world.

--

## Functional Composition

As a part of an answer, why not OOP.

--

## why not oop #1

> I made up the term 'object-oriented', and I can tell you I didn't have C++ in mind  
> — [Alan Kay, OOPSLA '97](http://programmers.stackexchange.com/a/58732/56648)

* objects: biological cells only able to communicate with messages
* objects could have several algebras associated with it
* inheritance came from Simula `// TODO: bad implementation, reimplement, when understand how do it better © Alan Kay`
* polymorhism invented later and isnt quite correct.

--

## why not oop #2

> You wanted a banana but what you got was a gorilla holding the banana and the entire jungle.  
> — [Joe Armstrong][jungle], creator of Erlang in the "Coders at Work".

[jungle]: http://www.johndcook.com/blog/2011/07/19/you-wanted-banana/

--

## why not oop #3,
### composition over inheritance

Few following slides will briefly describe a problem with inheritance

<iframe width="100%" height="400" src="https://www.youtube.com/embed/wfMtDGfHWpA" frameborder="0" allowfullscreen></iframe>

--

## why not oop #3,
### composition over inheritance

```javascript
Robot
  .drive()
    MurderRobot
      .kill()
    CleaningRobot
      .clean()

Animal
  .poop()
    Dog
      .bark()
    Cat
      .meow()
```

--

## why not oop #3,
### composition over inheritance

> Our customers demand MurderRobotDog  
> — Sincerely, yours manager.  
> ` // every once in a while`

But robots do not have digestive system to be able to poop.  
No good way to refactor.

--

## why not oop #4,
### composition over inheritance

On the other side, with composition:
* Dog: pooper + barker
* Cat: pooper + meower
* CleaningRobot: driver + cleaner
* MurderRobot: driver + killer

*MurderRobotDog: driver + killer + barker*, boom!

--

## why not oop, summary

* its not oop from the start
* [even erlang is more oop in the original OOP sense](https://www.youtube.com/watch?v=YaUPdgtUYko)
* composition over inheritance, because refactor functions easier than complex class architecture

--

<img style="min-width: 80%" src="http://www.reactiongifs.com/r/2013/10/tim-and-eric-mind-blown.gif" />

--

## FP utilities belt

* curry
* compose
* pipe aka reversed compose `// wait for it`

--

## Curry

![](https://smithwealth.com.au/wp-content/uploads/2015/11/Curry_2710104b.jpg)

--

## Curry

* Takes function, returns curried function
* Curried function doesnt need all arguments to be provided from the start
* Curried function will postpone calculation until it gets all needed arguments, meanwhile returning function to consume arguments which left

--

## Curry

```javascript
// naive simple currying
var add = function(x) {
  return function(y) {
    return x + y;
  };
};
var alsoAdd = x => y => x + y;

add(1)(2) === alsoAdd(1)(2) === 3; // true
// though add(1, 2) isnt working, lets fix that
```

--

## Curry, (as a blackbox)

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
      // return curried function which accumulates arguments
      ? (...newArgs) => curry(fn)(...args.concat(newArgs))
      // if all arguments are provided,
      // just invoke function with them
      : fn(...args)
```

--

## Curry, why? (double case)

```javascript
const double = x => x * 2;
```

--

## Curry, why? (double case)

```javascript
const multiply = (x, y) => x * y;
const double = x => multiply(x, 2);
const alsoDouble = y => multiply(2, y);
```

--

## Curry, why? (double case)

```javascript
const multiply = (x, y) => x * y;
const curriedMultiply = curry(multiply);

// const double = y => curriedMultiply(2, y);
const double = curriedMultiply(2); // y => multiply(2, y)

double(50); // multiply(2, 50) → 100
```

--

## Curry, why? (another shot)

```javascript
// NOTE: exponent is first argument, base is last
const power = curry( (exponent, base) => {
  return Math.pow(base, exponent);
} );

const square = power(2); // base => power(base, 2)

square(3); // power(2, 3) → 9
```
--

## Curry, why? (another shot)

```javascript
cont add = curry( (x, y) => x + y );

const inc = add(1); // y → add(1, y)

inc(1); // add(1, 1) → 2
```
--

## Curry, why? (another shot)

```javascript
const match = curry( (pattern, str) => str.match(pattern) );

const hasSpaces = match(/\s+/g);
// str => str.match(/\s+/g);

hasSpaces('hello world');
// match(/\s+/g, 'hello world') → [' ']

hasSpaces('spaceless');
// match(/\s+/g, 'spaceless') → null
```

--

## Curry, why? (another shot)

```javascript
// three arguments in original function
const replace = curry( function (pattern, replacement, str) {
  return str.replace(pattern, replacement);
} );

const noVowels = replace(/[aeiouy]/ig);
// replace() got `/[aeiouy]/ig` as a 1st argument, 2 left
// (replacement, str) => str.replace(/[aeiouy]/ig, replacement);

const censored = noVowels('*');
// replace() got '*' as a 2nd argument, 1 to go
// str => str.replace(/[aeiouy]/ig, '*');

censored('Chocolate Rain');
// replace(/[aeiouy]/ig, '*', 'Chocolate Rain') → 'Ch*c*l*t* R**n'

```

--

## Curry, summary

* do not write extra code
* write one wide purpose function
* curry it and derive more specific functions
* *obs* data is last

--

## Functional composition

![](http://mattiasfest.in/images/composition.jpg)

--

## Functional composition

* Takes functions, returns composed function
* Returns composed function which takes `arguments`
* Invokes (right to left) each passed function after each other
* Every next function will get calculation result of previous one
* Note: right most function can take any arguments

`f(g(x)) === compose(f, g)(x)`, in short


---

## Functional composition, (simple)

It just works™

```javascript
var compose = function(f, g) {
  return function(x) {
    return f(g(x));
  };
};
var alsoCompose = (f, g) => x => f(g(x));
```
--

## Functional composition, (shout case)

```javascript
const compose = (f, g) => x => f(g(x));
// compose(f, g)(x) ≣ f(g(x))

const toUpperCase = x => x.toUpperCase();
const exclaim = x => x + '!';

const shout = str => exclaim(toUpperCase(str));
const alsoShout = compose(exclaim, toUpperCase);

shout('send in the clowns'); // "SEND IN THE CLOWNS!"
alsoShout('send in the clowns'); // "SEND IN THE CLOWNS!"
```
--

## Functional composition, (in depth)

For those, who are curious:

```javascript
const compose = (...fns) => { // Takes functions
  // separate right most function from rest functions
  const [tailFn, ...restFns] = fns.reverse();
  // Returns composed function
  return (...args) => { // which takes `arguments`
    // Invokes each passed function after each other
    return restFns.reduce(
      // each function takes result of previous one
      (value, fn) => fn(value),
      // but right most function can take any arguments
      tailFn(...args)
    );
  };
};

// pipe is reversed compose, more human friendly
const pipe = (...fns) => compose(...fns.reverse());
```

--

## Functional composition, (example)

```javascript
// keywords(' hello,, world'); // ['hello', 'world']
// function needs to validate, split, trim and filter
const keywords1 = input =>
  filter(trim(split(validate(input))));

const keywords2 = input => compose(
  filter, trim, split, validate // NOTE: right to left
)(input);

// though input => compose(…)(input) === compose(…), so
const keywords  = compose(filter, trim, split, validate);

keywords(' hello,, world'); // ['hello', 'world']
```

--

## Functional composition (summary example)

```javascript
const keywords = input =>
  filter(trim(split(validate(input))));

const alsoKeywords = compose(
  filter, trim, split, validate
);
```

*Problem:* humans read from left to right, not other way around.

--

## Functional composition, (pipe to the rescue)

Reversed compose, in short

```javascript
const pipe = (...fns) => compose(...fns.reverse())
```
or

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

---

## Functional composition, (pipe to the rescue #2)

```javascript
// keywords(' hello,, world'); // ['hello', 'world']
// so you have a function which needs
//                 to validate, split, trim and filter
const keywords = pipe(validate, split, trim, filter);
// NOTE: same order as we described in requirements

keywords(' hello,, world'); // ['hello', 'world']
```

--

## Functional composition (pipe as Unix pipe)

* LiSt node_modules content
* Word Count by -lines

```bash
➜  rollup git:(master) ls node_modules | wc -l
     350
```

---

## Functional composition (pipe as Promise.then chain)

```javascript
/* const keywords = pipe(
  validate,
  split,
  trim,
  filter
); */

const keywords = str => Promise.resolve(str)
  .then(validate)
  .then(split)
  .then(trim)
  .then(filter);
```

--

## Functional Programming, summary

Functions takes functions and returns functions

![](http://img2-ak.lst.fm/i/u/arO/2a6031c9d53d48fda501d84bac7089ff)

--

## Functional Programming, summary

* pure functions
* avoid side effects
* write small widely applicable functions
* derive more specific functions from them with `curry`
* `compose` existing functions to create new ones
* declare your data flow with `pipe`
* have fun and functions

--

![](https://img.rt.com/files/2016.05/original/5725d86ac46188bd038b45a1.jpg)

--

## Functional Programming, further reading

* [Mostly adequate guide to FP (in javascript)](https://github.com/MostlyAdequate/mostly-adequate-guide), book
* [Purity and Side effects](https://drboolean.gitbooks.io/mostly-adequate-guide/content/ch3.html), article
* Curry — [definition](curry-def) and [explanation](curry-expl)
* Function composition — [definition][compose-def] and [explanation][compose-expl]
* [Why immutability matters](https://iamstarkov.com/why-immutability-matters/), article
* [Alan Kay about OOP](http://programmers.stackexchange.com/a/58732/56648), article
* [Joe Armstrong about OOP](http://www.johndcook.com/blog/2011/07/19/you-wanted-banana/), article
* [Joe Armstrong about Erlang is being more OOP than C++](https://www.youtube.com/watch?v=YaUPdgtUYko), video
* [Composition over Inheritance][comp-over-inher] by [@mpjme][mpjme], video

[curry-def]: https://en.wikipedia.org/wiki/Currying
[curry-expl]: https://drboolean.gitbooks.io/mostly-adequate-guide/content/ch4.html#cant-live-if-livin-is-without-you
[compose-def]: https://en.wikipedia.org/wiki/Function_composition_(computer_science)
[compose-expl]: https://drboolean.gitbooks.io/mostly-adequate-guide/content/ch5.html
[comp-over-inher]: https://youtu.be/wfMtDGfHWpA
[mpjme]: twitter.com/mpjme

--

## Functional Programming, (recursion)

* You can find more about "real world fp" workshop in the github repo
https://github.com/iamstarkov/fp-js-workshop

* This presentation is available on url
https://iamstarkov.com/fp-js-workshop/01-theoretic-intro/.

* To be continued with "#2 Practical intro"

* *Stay tuned*
