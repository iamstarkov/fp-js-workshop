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

## Hindlye-Milner signature

Brief function's documentation about arguments' types and returned value's type

```
// functionName :: argType1 -> argType2 -> argType3 -> resultType
```

--

## Hindlye-Milner signature

```javascript
// double takes Number returns Number
// double :: Number -> Number
const double = x => x * 2;

// split takes String returns Array of String's
// split :: String -> [String] same as
const split = str => str.split(' ');
```

--

## Problem

```js
double(); // nope
double('2'); // nope

split(); // no split on undefined
split(123); // no split on number
```

--

## Signature as Contract

Our functions will work *only* when our functions are used with proper types.
See Hindlye-Milner signatures. In other words, arguments should satisfy contract of that function.

```javascript
// double :: Number -> Number
const double = x => x * 2;

// split :: String -> [String]
const split = str => str.split(' ');

// fine
double(2);
split('sup js');

// every mus-usage will be broken
double();
double('sup');
split();
split(2);
```
--

## Misusages

* empty input (`undefined`)
* invalid input (`wrong type`)

--

## Satisfied contract

Every passed argument belongs to type, specified in contract.

--

## contract function

```javascript
// javascript types magic, dont bother
// Constructor, as Ctor, because Constructor is a keyword
const is = (Ctor, val) => val != null && val.constructor === Ctor || val instanceof Ctor;
const type = val => (val !== null && val !== undefined)
  ? Object.prototype.toString.call(val).slice(8, -1)
  : (val === null) ? 'Null': 'Undefined';
const ctorType = Ctor => (val !== null && val !== undefined)
  ? type(Ctor())
  : (val === null) ? 'Null': 'Undefined';

const contract = (argName, Ctor, actualArg) => {
  if (is(Ctor, actualArg)) {
    return actualArg;
  } else {
    throw new TypeError(
       `\`${argName}\` should be an \`${ctorType(Ctor}\`, but got \`${type(actualArg)}\`: ${actualArg}`;
    )
  }
}

contrac
```


--

## Further reading

* [The Error Model](http://joeduffyblog.com/2016/02/07/the-error-model/)
* [Is your JavaScript function actually pure?](http://staltz.com/is-your-javascript-function-actually-pure.html)
--

## Functional Programming, (recursion)

["real world fp" repo](https://github.com/iamstarkov/fp-js-workshop)  
["#4 contracts" slides](https://iamstarkov.com/fp-js-workshop/03-contracts/)

To be continued with real world implementation with you.

*Stay tuned*

--

# real world fp
## #3 contracts

<br>
*In functions we trust*

Sincerely yours [Vladimir Starkov](https://iamstarkov.com)  
_@iamstarkov on [github](https://github.com/iamstarkov) and [twitter](https://twitter.com/iamstarkov)_
