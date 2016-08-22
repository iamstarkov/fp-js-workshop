title: real world fp. #1 theoretic intro
author:
  name: Vladimir Starkov
  twitter: iamstarkov
  email: iamstarkov@gmail.com
  url: https://iamstarkov.com
output: 01-theoretic-intro.html
theme: jdan/cleaver-retro

--

# real world fp
## #1 theoretic intro

<del>Monads, Comonad, Monoids, Setoids, Endofunctors</del>.  
Easy to understand, read, test and debug

--

### Functional programming

* declarative programming paradigm
* computation as the evaluation of mathematical functions
* avoids changing-state and mutable data and side-effects
* encourage functional composition

--

### declarative vs imperative

<!-- you dont care how map or double is implemented undernearth -->

```
function imperativeDoubleArray(arr) {
  var result = [];
  for (var i = 0, i++, i<arr.length) {
    result.push(arr[i] * 2);
  }
  return result;
}


const double = i => i*2;
const declarativeDoubleArray = arr => arr.map(double);
```
--

### mathematical function `f(x)`

> In mathematics, a function is a relation between a set of inputs and a set of permissible outputs with the property that each input is related to exactly one output. `f(x)`. aka pure function in computer science
> — [Wikipedia][wiki1]

*same input = same output, in short*
[wiki1]: https://en.wikipedia.org/wiki/Function_(mathematics))

--

### Pure function

> A pure function is a function that, given the same input, will always return the same output and does not have any observable side effect.  
> — [Professor Frisby, "Mostly adequate guide to FP"](https://drboolean.gitbooks.io/mostly-adequate-guide/content/ch3.html#oh-to-be-pure-again)

--

### Pure function, in examples

```
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

### Pure function

* Predictability, with [immutability](https://iamstarkov.com/why-immutability-matters/)
* Referential Transparency
* Cacheable / memoizability, `// function as hashtable`
* Portable / Self-Documenting
* Testable
* Parallel Code / concurrency

--

### avoids changing-state

**global variables** makes your function unpredictable.

**state, internal variables**, same as global variables but from within

```
Promise.resolve(1).then(Promise.resolve); // TypeError
Promise.resolve(1).then(Promise.resolve.bind(Promise)); // 1
```
--

### Side effects

* changing the file system
* database operations
* network requests
* mutations
* printing to the screen / logging
* obtaining user input
* querying the DOM
* accessing system state

--

### Side effects, exactly

```
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

### Side effects and FP

We are not prohibiting side effects, but more like controlling them.
Because without them we cant do anything useful for real world.

--

### Functional Composition

As a part of an answer, why not OOP.

--

### why not oop #1

> I made up the term 'object-oriented', and I can tell you I didn't have C++ in mind  
> -- [Alan Kay, OOPSLA '97](http://programmers.stackexchange.com/a/58732/56648)

* objects: biological cells only able to communicate with messages
* objects could have several algebras associated with it
* inheritance came from Simula `// TODO: reimplement, when understand how do it better © Alan Kay`
* polymorhism invented later and isnt quite correct.

--

### why not oop #2

> You wanted a banana but what you got was a gorilla holding the banana and the entire jungle.  
> — [Joe Armstrong][jungle], creator of Erlang in the "Coders at Work".

[jungle]: http://www.johndcook.com/blog/2011/07/19/you-wanted-banana/

--

### why not oop #3, composition&nbsp;over&nbsp;inheritance

<iframe width="100%" height="400" src="https://www.youtube.com/embed/wfMtDGfHWpA" frameborder="0" allowfullscreen></iframe>

--

### why not oop #3, composition&nbsp;over&nbsp;inheritance

```
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

### why not oop #3, composition&nbsp;over&nbsp;inheritance

> Our customers demand MurderRobotDog  
> — Sincerely, yours manager. ` // every once in a while`

--

### why not oop #4, composition&nbsp;over&nbsp;inheritance

With inheritance:
* Dog: pooper + barker
* Cat: pooper + meower
* CleaningRobot: driver + cleaner
* MurderRobot: driver + killer

*MurderRobotDog: driver + killer + barker*

--

### why not oop, summary

* its not oop from the start
* [erlang is more oop in original OOP sense](https://www.youtube.com/watch?v=YaUPdgtUYko)
* composition over inheritance, because refactor functions easier than complex class architecture

--

<img width="100%" src='http://www.reactiongifs.com/r/2013/10/tim-and-eric-mind-blown.gif' />

--

### FP utilities belt

* curry
* compose
* pipe aka reversed compose `// wait for it`

--

### Curry

<img
  style="max-width: 100%; max-height: 100%; display: block; margin: 0 auto;"
  src='https://smithwealth.com.au/wp-content/uploads/2015/11/Curry_2710104b.jpg'
  />

--

### Curry

* Takes function, returns curried function.
* Curried function doesnt need all arguments to be provided from the start
* Curried function will postpone calculation until it gets all needed arguments, meanwhile returning function to consume arguments which left.

---

### Curry

```
var add = function(x) {
  return function(y) {
    return x + y;
  };
};
var alsoAdd = x => y => x + y;
```

--

### Curry

```
const sum = (a, b, c) => a + b + c;
sum(1, 2, 3); // 6

const curriedSum = curry(sum);
curriedSum(1, 2, 3); // 6
curriedSum(1, 2)(3); // 6
curriedSum(1)(2)(3); // 6
curriedSum(1)(2, 3); // 6
```
--

### Curry, why? `double case`

```
const double = x => x * 2;
```

--

### Curry, why? `double case`

```
const multiply = (x, y) => x * y;
const double = x => multiply(x, 2);
const alsoDouble = x => multiply(2, x);
```

--

### Curry, why? `double case`

```
const multiply = (x, y) => x * y;
const curriedMultiply = curry(multiply);

// const double = x => curriedMultiply(2, x);
const double = curriedMultiply(2); // x => multiply(2, x)

double(50); // 100
```

--

### Curry, why? `another shot`

```
const pow = curry( (x, y) => Math.pow(x, y) );

const square = pow(2); // x => pow(2, x)

square(3); // 9
```
--

### Curry, why? `another shot`

```
cont add = curry( (x, y) => x + y );

const inc = curriedAdd(1); // x => add(1, x)

inc(1); // 2
```
--

### Curry, why? `another shot`

```
const match = curry( (pattern, str) => str.match(pattern) );

const hasSpaces = match(/\s+/g); // str => str.match(/\s+/g);

hasSpaces('hello world'); // [' ']

hasSpaces('spaceless'); // null
```

--

### Curry, why? `another shot`

```
const replace = curry(
  function (pattern, replacement, str) {
    return str.replace(pattern, replacement);
  }
);

const noVowels = replace(/[aeiouy]/ig);
// (replacement, str) => str.replace(/[aeiouy]/ig, replacement);

const censor = noVowels('*');
// str => str.replace(/[aeiouy]/ig, '*');

censored('Chocolate Rain'); // 'Ch*c*l*t* R**n'

```

--

### Curry, summary

* do not write extra code
* write one wide purpose function
* curry it and derive more specific functions
* *obs* data is last


--

### Functional composition

<img
  style="max-width: 100%; max-height: 100%; display: block; margin: 0 auto;"
  src="http://mattiasfest.in/images/composition.jpg" />

--

### Functional composition

```
var compose = function(f, g) {
  return function(x) {
    return f(g(x));
  };
};
var alsoCompose = (f, g) => x => f(g(x));
```

---

### Functional composition, `shout case`

```
const compose = (f, g) => x => f(g(x));

const toUpperCase = x => x.toUpperCase();
const exclaim = x => x + '!';

const shout = str => exclaim(toUpperCase(str));
const alsoShout = compose(exclaim, toUpperCase);

shout('send in the clowns'); // "SEND IN THE CLOWNS!"
alsoShout('send in the clowns'); // "SEND IN THE CLOWNS!"
```
--

### Functional composition, `compose, broad sense`

```
// compose :: ...functions -> function

// keywords(' hello,, world'); // ['hello', 'world']
// so you have a function which needs
// to validate, split, trim and filter
const keywords1 = input => validate(input);
const keywords2 = input => split(validate(input));
const keywords3 = input => trim(split(validate(input)));
const keywords4 = input => filter(trim(split(validate(input))));

const keywords = compose(filter, trim, split, validate);
keywords(' hello,, world'); // ['hello', 'world']
```

*Problem*, humans read from left to right, not other way around.

--

### Functional composition,  
### `pipe to the rescue`

```
// pipe :: ...functions -> function
// const pipe = (...functions) => {
//  return compose(functions.reverse())
// }

// keywords(' hello,, world'); // ['hello', 'world']
// so you have a function which needs
// to validate, split, trim and filter
const keywords = pipe(validate, split, trim, filter);
keywords(' hello,, world'); // ['hello', 'world']
```

--

### Functional composition, `pipe as Unix pipe`

* LiSt node_modules content
* Word Count by -lines

```
➜  rollup git:(master) ls node_modules | wc -l
     350
```

---

### Functional composition, `pipe as Promise.then chain`

```
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

### Functional Programming, summary

<img
  style="max-width: 100%; max-height: 100%; display: block; margin: 0 auto;"
  src="http://img2-ak.lst.fm/i/u/arO/2a6031c9d53d48fda501d84bac7089ff">

--

### Functional Programming, summary

* pure functions
* avoid side effects
* write small widely applicable functions
* derive more specific functions from them with `curry`
* `compose` existing functions to create new ones
* declare your data flow with `pipe`
* have fun
