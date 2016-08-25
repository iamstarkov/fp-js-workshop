title: real world fp, 02 practical intro
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
## #2 practical intro

<del>Monads, Comonad, Monoids, Setoids, Endofunctors.</del>  
Easy to understand, read, test and debug

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

## imperative example

* function `keywords`
* takes `string`
* returns `Array of String` — keywords separated by comma

--

## tdd ftw

```javascript
import test from 'ava';
import keywords from 'keywords';

test('basic', t => {
  t.deepEqual( keywords('uni,corns'), ['uni', 'corns'] );
});

test('space-padded keywords', t => {
  t.deepEqual( keywords('uni , corns'), ['uni', 'corns'] );
});

test('meaningless keywords', t => {
  t.deepEqual( keywords('uni , , corns'), ['uni', 'corns'] );
});

```

--

```javascript
test('empty input', t => {
  t.throws(
    () => { keywords(); },
    TypeError
  );
});

test('invalid input', t => {
  t.throws(
    () => { keywords(2); },
    TypeError
  );
});
```

--

## keywords, naive

```javascript
const keywords = input => input.split(',');
```

<!-- No help guide for consumers, who will misuse it. -->

--

## keywords, typecheck

```javascript
const keywords = input => {
  if (typeof input !== 'string') {
    throw new Error('input should be String, got: ' + input);
  }
  return input.split(',');
}
```

simple, readable, debug, ~~tests~~
<!-- More tests to pass -->

--

## space-padded keywords

```javascript
const keywords = input => {
  if (typeof input !== 'string') {
    throw new Error('input should be String, got: ' + input);
  }
  return input.split(',').map(str => str.trim());
}
```

~~simple, kind of readable, debug, ~~tests~~

<!-- Better, though meaningless keywords still need to be fixed -->

--

## meaningless keywords

```javascript
const keywords = input => {
  if (typeof input !== 'string') {
    throw new Error('input should be String, got: ' + input);
  }
  return input.split(',').map(str => str.trim()).filter(str => str !== '');
}
```
~~simple, readable, debug~~, tests

--

## gather specification

Function needs to:
* takes input
* validate it
* split it
* map trim it
* reject empty
* summary: validate, split, map trim, reject empty

Can we write code as easy as this specification?

--

## readability

```javascript
const keywords = input => {
  if (typeof input !== 'string') {
    throw new Error('input should be String, got: ' + input);
  }
  var input = input.split(',');
  var input = input.map(str => str.trim());
  var input = input.filter(str => str !== '');
  return input;
}
```

~~simple~~, readable, ~~debug~~, tests

*immutability matters*

--

## debugability

```javascript
const keywords = input => {  
  if (typeof input !== 'string') {
    throw new Error('input should be String, got: ' + input);
  }
  var inputArray = input.split(',');
  var trimmedArray = inputArray.map(str => str.trim());
  var filteredArray = trimmedArray.filter(str => str !== '');
  return filteredArray;
}
```

~~simple~~, kind of readable, debug, tests

--

## validation

```javascript
const validate = input => {
  if (typeof input !== 'string') {
    throw new Error('input should be String, got: ' + input);
  }
  return input;
}
```

--

## everything in line

```javascript
const keywords = input => {
  var validInput = validate(input);
  var inputArray = validInput.split(',');
  var trimmedArray = inputArray.map(str => str.trim()); // can simplify
  var filteredArray = trimmedArray.filter(str => str !== ''); // can simplify
  return filteredArray;
}
```

~~simple~~, kind of readable, debug, tests

--

## simplification

```javascript
const trim = str => str.trim();
const isNotEmpty = str => str !== '';

const keywords = input => {
  var validInput = validate(input);
  var inputArray = validInput.split(',');
  var trimmedArray = inputArray.map(trim);
  var filteredArray = trimmedArray.filter(isNotEmpty);
  return filteredArray;
}
```
~~simple~~, kind of readable, debug, tests

Variables are useless except for passing them to next function.

--

## naive compose, preparation

```javascript
const keywords = input => {
  var validInput = validate(input);
  var inputArray = validInput.split(','); // str => str.split(',');
  var trimmedArray = inputArray.map(trim); // arr => arr.map(trim)
  var filteredArray = trimmedArray.filter(isNotEmpty); // arr => arr.filter(isNotEmpty)
  return filteredArray;
}
```
--

## naive compose, function extraction

```javascript
// validate already defined
const split = str => str.split(',');
const mapTrim = arr => arr.map(trim);
const filterNonEmptyStrings = arr => arr.filter(isNotEmpty);

const keywords = input => {
  return filterNonEmptyStrings( mapTrim( split( validate(input) ) ));
}
```

perfect for `compose()`!

--

## proper compose


```javascript
// validate already defined
const split = str => str.split(',');
const mapTrim = arr => arr.map(trim);
const filterNonEmptyStrings = arr => arr.filter(isNotEmpty);

const keywords = input => {
  return compose(
    // filterNonEmptyStrings( mapTrim( split( validate(input) ) ));
    filterNonEmptyStrings, mapTrim, split, validate
  )(input);
}
```
--

## proper compose, improvement

```javascript
httpGet('/post/2', function(json, err) {
  return renderPost(json, err);
});
// same as
httpGet(renderPost);
```
--

## proper compose, improvement

```javascript
const keywords = input => {
  const fn = compose( filterNonEmptyStrings, mapTrim, split, validate );
  return fn(input);
}
// same as
const fn = compose( filterNonEmptyStrings, mapTrim, split, validate );
const keywords = input => fn(input);
// =>
const keywords = compose( filterNonEmptyStrings, mapTrim, split, validate );
```

--

## compose vs pipe

<!-- spec is: validate, split, map trim, reject empty -->

```javascript
const keywords = compose( filterNonEmptyStrings, mapTrim, split, validate );

// exactly as spec:    validate, split, map trim, reject empty
const keywords = pipe( validate, split, mapTrim, filterNonEmptyStrings );
```
--

## full example

```javascript
// general
const pipe = /* */

// helpers
const trim = str => str.trim();
const isNotEmpty = str => str !== '';

const validate = input => {
  if (typeof input !== 'string') {
    throw new Error('input should be String, got: ' + input);
  }
  return input;
};
const split = str => str.split(',');
const mapTrim = arr => arr.map(trim);
const filterNonEmptyStrings = arr => arr.filter(isNotEmpty);

cosnt keywords = pipe(
  validate,
  split,
  mapTrim,
  filterNonEmptyStrings
);
```

--

<!--

```javascript
const splitByComma = {
  validateAsFn: input => {
    const validate = input => {
      if (typeof input !== 'string') {
        throw new Error('input should be String, got: ' + input);
      }
      return input;
    }
    var validInput = validate(input);
    var inputArray = validInput.split(',');
    var trimmedArray = inputArray.map(str => str.trim());
    var filteredArray = trimmedArray.filter(str => str !== '');
    return filteredArray;
    // input validation is in line with everything else
    // a lot of temp variables
  }
  draftPipe: input => {
    const validate = input => {
      if (typeof input !== 'string') {
        throw new Error('input should be String, got: ' + input);
      }
      return input;
    }
    const pipe = (...args) => result => args.reduce((res, arg) => arg.call(this, res), result);
    const fn = pipe(
      input => validate(input),
      validInput => validInput.split(','),
      inputArray => inputArray.map(str => str.trim()),
      trimmedArray => trimmedArray.filter(str => str !== '')
    );
    return fn(input);
    // better, but do we really need all those variables in pipe
    // and you will ask me about debuggin this shit, right?
  }
  draftPipeV2debugwise: input => {
    const tap = (fn, input) => { fn(input); return input; }
    const log = input => tap(console.log.bind(this), input);
    const validate = input => {
      if (typeof input !== 'string') {
        throw new Error('input should be String, got: ' + input);
      }
      return input;
    }
    const pipe = (...args) => result => args.reduce((res, arg) => arg.call(this, res), result);
    const fn = pipe(
      validate,
      validInput => split(',', validInput),
      log, // ['some', 'array']
      inputArray => inputArray.map(str => str.trim()),
      trimmedArray => trimmedArray.filter(str => str !== '')
    );
    return fn(input);
    // hey, kind of readable and with debuggin!
    // yes, but whats about all of that temp variables?
    // lets try one approach to remove them
    // but first lets try to simplify stuff
  }
  draftPipeV4moreFunctions: input => {
    const tap = (fn, input) => { fn(input); return input; }
    const log = input => tap(console.log.bind(this), input);
    const validate = input => {
      if (typeof input !== 'string') {
        throw new Error('input should be String, got: ' + input);
      }
      return input;
    }
    const pipe = (...args) => result => args.reduce((res, arg) => arg.call(this, res), result);
    const split = (separator, input) => input.split(separator);
    const trim = input => input.trim();
    const isNil = input => typeof input === 'undefined';
    const fn = pipe(
      validate,
      validInput => split(',', validInput),
      log,
      inputArray => inputArray.map(trim),
      trimmedArray => trimmedArray.filter(isNil)
    );
    return fn(input);
    // a bit cleaner
    // yes, but still whats about all of that temp variables?
    // wait a bit one more step required
  }
  draftPipeV5moreFunctionsToTheFunctionsGod: input => {
    const tap = (fn, input) => { fn(input); return input; }
    const log = input => tap(console.log.bind(this), input);
    const validate = input => {
      if (typeof input !== 'string') {
        throw new Error('input should be String, got: ' + input);
      }
      return input;
    }
    const pipe = (...args) => result => args.reduce((res, arg) => arg.call(this, res), result);
    const split = (separator, input) => input.split(separator);
    const trim = input => input.trim();
    const isNil = input => typeof input === 'undefined';
    const map = (fn, arr) => arr.map(fn);
    const filter = (fn, arr) => arr.filter(fn);
    const fn = pipe(
      validate,
      validInput => split(',', validInput),
      log,
      inputArray => map(trim, inputArray),
      trimmedArray => filter(isNil, trimmedArray)
    );
    return fn(input);
    // now we are ready to add some curry
  }
  draftPipeV6currying: input => {
    const tap = (fn, input) => { fn(input); return input; }
    const log = input => tap(console.log.bind(this), input);
    const validate = input,  => {
      if (typeof input !== 'string') {
        throw new Error('input should be String, got: ' + input);
      }
      return input;
    }
    const pipe = (...args) => result => args.reduce((res, arg) => arg.call(this, res), result);
    // simple auto currying
    // (does NOT separately handle f.length == args.length or f.length < args.length cases)
    const curry = (f, ...args) => (f.length <= args.length)
      ? f(...args)
      : (...more) => curry(f, ...args, ...more);
    const split = curry((separator, input) => input.split(separator));
    const trim = input => input.trim();
    const isNil = input => typeof input === 'undefined';
    const map = curry((fn, arr) => arr.map(fn));
    const filter = curry((fn, arr) => arr.filter(fn));
    const fn = pipe(
      validate,
      split(','),
      log,
      map(trim),
      filter(isNil)
    );
    return fn(input);
    // now we are ready to extract apply currying!
  }
  dataflowContract: input => {
    const tap = (fn, input) => { fn(input); return input; }
    const log = input => tap(console.log.bind(this), input);
    const contract = (argName, type, arg)  => {
      if (typeof input !== 'string') {
        throw new Error('input should be String, got: ' + input);
      }
      return input;
    }
    const pipe = (...args) => result => args.reduce((res, arg) => arg.call(this, res), result);
    // simple auto currying
    // (does NOT separately handle f.length == args.length or f.length < args.length cases)
    const curry = (f, ...args) => (f.length <= args.length)
      ? f(...args)
      : (...more) => curry(f, ...args, ...more);
    const split = curry((separator, input) => input.split(separator));
    const trim = input => input.trim();
    const isNil = input => typeof input === 'undefined';
    const map = curry((fn, arr) => arr.map(fn));
    const filter = curry((fn, arr) => arr.filter(fn));
    const fn = pipe(
      validate,
      split(','),
      log,
      map(trim),
      filter(isNil)
    );
    return fn(input);
    // now we are ready to extract apply currying!
  }
  // extract everything and result will look like this
  dataflow: pipe(
    validate,       // validate input
    split(','),     // split
    map(trim),      // trim array
    filter(isEmpty) // filter array
  ) // readable, debug, all edgecases covered and declarative
  // look ma,
  // no variables, no mutation!
}
```
-->
