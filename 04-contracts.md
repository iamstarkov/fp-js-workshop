title: real world fp, 04 contracts
theme: sudodoki/reveal-cleaver-theme
style: https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.6.0/styles/zenburn.min.css
controls: true

--

# real world fp
## #4 contracts

<del>Monads, Comonad, Monoids, Setoids, Endofunctors.</del>  
Easy to understand, read, test and debug

<br/><br/><br/>
<small>by [Vladimir Starkov](https://iamstarkov.com)</small>

--

## what

```javascript
// double takes Number returns Number
const double = x => x * 2;

// split takes String returns Array of String's
const split = str => str.split(' ');
```

--

## Problem

```javascript
double();     // NaN
double('2q'); // NaN

split();      // TypeError: str is undefined
split(123);   // TypeError: str.split is not a function
```

--

## Problem, exactly

`double()` and `split()` will work properly only when input belongs to specified Type.

Let's establish this convention.

--

## Hindley-Milner signature

Brief function's documentation about arguments' types and returned value's type

```
// functionName :: argType1 -> argType2 -> argType3 -> resultType
```

--

## Hindley-Milner signature

```javascript
// double takes Number returns Number
// double :: Number -> Number
const double = x => x * 2;

// split takes String returns Array of String's
// split :: String -> [String]
const split = str => str.split(' ');
```

--

## Signature as Contract

> Contract — as far as arguments satisfy signature, function will work as expected.

Every mususage leads to broken function

--

## Misusages

* empty input: `undefined` or `fn()`
* invalid input: `wrong type` or `fn(invalidType)`

--

## Problem definition, revisited

1. Function can be used only in specific condition
2. Function will be broken otherwise
3. Function consumer will get unhelpful messages

Function consumer — your co-worker in the office or another developer in the open-source.

--

## Problem definition, solution

> 1. Function can be used only in specific condition

Thats fine, as far as it really works!

--

## Problem definition, solution

> 2. Function will be broken otherwise
> 3. Function consumer will get unhelpful messages

* force desired types
* if types are invalid, print helpful and careful messages for consumer

--

## JavaScript Type System™

![](http://ci.memecdn.com/216/7046216.jpg)

--

## JavaScript Type System™
### Static typing JS dialects

* TypeScript
* Flow

--

## TypeScript and Flow

* Both are great
* Its vendor lock, though
* Introduces compilation build-step
* [TypeScript doesn't expose run-time checks and will not do it](https://github.com/Microsoft/TypeScript/issues/1573)
    It means no help for your code consumers =(

<br/>

Why do we need to introduce new language superset  
if we can do it with one function?

--

## Solution

Function — which type-check arguments.

* If type is correct just returns value
* Otherwise `throw new TypeError(helpfulMessage)`
* Where helpful message, should contain
  * argument name
  * desired type
  * actual type
  * actual argument value

--

## contract function, preparation
### `is` helper

```javascript
/**
 * typecheck is value belongs to Constructor
 * @example:
 *   is(Number, 2); // true
 *   is(Number, 'qwe'); // false
 * @signature:
 *   is :: Constructor -> value -> Boolean
 */
const is = (Ctor, val) => val != null && val.constructor === Ctor || val instanceof Ctor;
```

--

## contract function, preparation
### `type` helper

```javascript
/**
 * returns value's type
 * @example:
 *   type(2); // 'Number'
 *   type('qwe'); // 'String'
 * @signature:
 *   type :: value -> String
 */
const type = val => (val !== null && val !== undefined)
  ? Object.prototype.toString.call(val).slice(8, -1)
  : (val === null) ? 'Null': 'Undefined';
```

--

## contract function, preparation
### `ctorType` helper

```javascript
/**
 * returns Constructor's type
 * @example:
 *   type(Number); // 'Number'
 *   type(String); // 'String'
 * @signature:
 *   ctorType :: Constructor -> String
 */
const ctorType = Ctor => (Ctor !== null && Ctor !== undefined)
  ? type(Ctor())
  : (val === null) ? 'Null': 'Undefined';
```

--

## contract function, implementation

```javascript
const contract = (argName, Ctor, actualArg) => {
  if (is(Ctor, actualArg)) {
    return actualArg;
  } else {
    throw new TypeError(
       `${argName} should be an ${ctorType(Ctor)}, but got ${type(actualArg)}: ${actualArg}`
    );
  }
}

contract('x', Number, 2); // 2
contract('x', Number, 'nope');
//> TypeError: x should be an Number, but got String: nope
```

--

## Contract function, usage

So we need to contract function and then invoke actual implementation, so its two steps — ideal case for `pipe`.

--

## Contract function, usage

```javascript
// double :: Number -> Number
const double = pipe(
  x => contract('x', Number, x),
  x => x * 2
)

// split :: String -> [String]
const split = pipe(
  str => contract('str', String , str),
  str => inputStr.split(' ')
)
```

--

## Contract function, improvement
### `curry` it!

```javascript
const contract = curry( (argName, Ctor, actualArg) => {
  if (is(Ctor, actualArg)) {
    return actualArg;
  } else {
    throw new TypeError(
       `${argName} should be an ${ctorType(Ctor)}, but got ${type(actualArg)}: ${actualArg}`
    );
  }
} );
```

--

## Contract function, improvement

```javascript
// double :: Number -> Number
const double = pipe(
  // x => contract('x', Number, x),
  // x => contract('x', Number)(x),
  contract('x', Number),
  x => x * 2
);

// split :: String -> [String]
const split = pipe(
  // str => contract('str', String, str),
  // str => contract('str', String)(str),
  contract('str', String),
  str => inputStr.split(' ')
);
```

--

## Result

```javascript
double(2); // 4
double('nope'); //> TypeError: x should be an Number, but got String: nope

split('sup js'); // ['sup', 'js'];
split(2); //> TypeError: str should be an String, but got Number: 2
```

--

## Summary

* Function is happy and will work if contract is satisfied
* You co-workers are happy to use your code
* If your code is not working for them they can fix it easily

--

## Further reading

* [The Error Model](http://joeduffyblog.com/2016/02/07/the-error-model/)
* [Is your JavaScript function actually pure?](http://staltz.com/is-your-javascript-function-actually-pure.html)
* [neat-contract lib, a bit extended function from this talk](https://github.com/iamstarkov/neat-contract)

--

## Functional Programming, (recursion)

["real world fp" repo](https://github.com/iamstarkov/fp-js-workshop)  
["#4 contracts" slides](https://iamstarkov.com/fp-js-workshop/03-contracts/)

To be continued with real world implementation with you.

*Stay tuned*

--

# real world fp
## #4 contracts

<br>
*In functions we trust*

Sincerely yours [Vladimir Starkov](https://iamstarkov.com)  
_@iamstarkov on [github](https://github.com/iamstarkov) and [twitter](https://twitter.com/iamstarkov)_
