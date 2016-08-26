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

## brief recap

* curry
* compose
* pipe

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
      // return curried function which accumulates arguments
      ? (...newArgs) => curry(fn)(...args.concat(newArgs))
      // if all arguments are provided,
      // just invoke function with them
      : fn(...args)
```

--

## Compose, (as a blackbox)

It just works™

```javascript
const shout1 = str => exclaim(toUpperCase(str));
// or
const shout2 = str => compose(exclaim, toUpperCase)(str);
// or
const shout3 = compose(exclaim, toUpperCase); // right to left order

shout1('sup /js/'); // SUP /JS/!
shout2('sup /js/'); // SUP /JS/!
shout3('sup /js/'); // SUP /JS/!
```

--

## Compose, (in depth)

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

## Pipe, (as a blackbox)

Reversed compose or human readable compose.

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

Reversed compose, in short

```javascript
const pipe = (...fns) => compose(...fns.reverse());
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

--

## Functional Programming, further reading

* list of links

--

## Functional Programming, (recursion)

["real world fp" repo](https://github.com/iamstarkov/fp-js-workshop), [this slides](https://iamstarkov.com/fp-js-workshop/02-practical-intro-intro/)

To be continued with live coding real world node modules

*Stay tuned*

--

# real world fp
## #2 practical intro

<br>
*In functions we trust*

Sincerely yours [Vladimir Starkov](https://iamstarkov.com)  
_@iamstarkov on [github](https://github.com/iamstarkov) and [twitter](https://twitter.com/iamstarkov)_
