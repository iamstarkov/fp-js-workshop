# real world fp

## what is fp

Functional programming:

* declarative programming paradigm
* computation as the evaluation of mathematical functions
* avoids changing-state and mutable data and side-effects
* encourage functional composition

### declarative vs imperative

```js
function imperativeDoubleArray(arr) {
  var result = [];
  for (var i = 0, i++, i<arr.length) {
    result.push(arr[i] * 2);
  }
  return result;
}

function declarativeDoubleArray(arr) {
  const double = i => i*2;
  return arr.map(double);
  // you dont care how map or double is implemented undernearth
}
```

## mathematical function f(x)

In mathematics, a function is a relation between a set of inputs and a set of permissible outputs with the property that each input is related to exactly one output. `f(x)`. aka pure function in computer science.

in short:
* same input = same output

https://en.wikipedia.org/wiki/Function_(mathematics)

## Pure function

A pure function is a function that, given the same input, will always return the same output and does not have any observable side effect.

Pros:
* predictability `// reduce cognitive load`
* ReferentialTransparency / Reasonable `// function invocation can be changed with produced value`
* Cacheable / memoizability `// perf boost`
* Portable / Self-Documenting `// reduce cognitive load`
* Testable `// oh my gosh`
* Parallel Code / concurrency / no race condition given `// one more perf boost`
* immutability `// as far as no mutation is happening in fp` https://iamstarkov.com/why-immutability-matters/
* headache painkiller

https://en.wikipedia.org/wiki/Pure_function

## Side effects sucks

Any interaction with the world outside of a function is a side effect, which is a fact that may prompt you to suspect the practicality of programming without them

You are not in control anymore

Side effects may include, but are not limited to

* changing the file system
* inserting a record into a database
* making an http call
* mutations
* printing to the screen / logging
* obtaining user input
* querying the DOM
* accessing system state
* ...
* Profit `// not really`


We are not prohibiting side effects, but more like controlling them.
Because wo/ them we cant do anything useful for real world.

## why the fuck not oop

> You wanted a banana but what you got was a gorilla holding the banana and the entire jungle.
> Joe Armstrong, creator of Erlang "Coders at Work".
> http://www.johndcook.com/blog/2011/07/19/you-wanted-banana/

* composition over inheritance https://www.youtube.com/watch?v=wfMtDGfHWpA
* its not oop from the start
* erlang is more oop in original oop sense https://www.youtube.com/watch?v=YaUPdgtUYko
* refactor functions easier than complex class architecture

## cognitive load

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

## another arguments

// ## global variables
// everybody knows its bad,
// because your function is unpredictable relied on variables outside of function scope

// state, internal variables
// are variables still outside of function scope? yes, so its similar to global variables
Promise.resolve(1).then(Promise.resolve); // TypeError
Promise.resolve(1).then(Promise.resolve.bind(Promise)); // 1

// side-effects, you are not in control
arr.sort, arr.splice cause a lot of side effects, which you cant control


/*
sup /js/

i wanna share some functional programming knowledge in application to JS tooling,
more specially bundling (not really, but close).

I will try to cover some fp topics, like:
* why does it mean "functional"
* pureness, side-effects
* what is currying
* what is composition
* a bit of lenses

what im not going to tell about
* monads, functors, applicative functors: nope



```
const splitByComma = {
  naive: input => input.split(','), // oh my god, no, no… no!
  typecheck: input => {
    if (typeof input !== 'string') {
      throw new Error('input should be String, got: ' + input);
    }
    return input.split(',');
    // error prone
  }
  edgecase: input => {
    if (typeof input !== 'string') {
      throw new Error('input should be String, got: ' + input);
    }
    return input.split(',').filter(Boolean);
    // better, though more edgecases left
  }
  edgecase2: input => {
    if (typeof input !== 'string') {
      throw new Error('input should be String, got: ' + input);
    }
    return input.split(',').map(_ => _.trim()).filter(_ => typeof _ !=== 'undefined');
    // best in terms of edgecases, worst in readability and debugging
  }
  readable: input => {
    if (typeof input !== 'string') {
      throw new Error('input should be String, got: ' + input);
    }
    var inputArray = input.split(',');
    var trimmedArray = inputArray.map(_ => _.trim());
    var filteredArray = trimmedArray.filter(_ => typeof _ !=== 'undefined');
    return filteredArray;
    // best in terms of edgecases
    // debug-friendly, kind of
    // readable
    // but tedious and repetitive
    // also input validation is not in line with everything else
  }
  validateAsFn: input => {
    const validate = input => {
      if (typeof input !== 'string') {
        throw new Error('input should be String, got: ' + input);
      }
      return input;
    }
    var validInput = validate(input);
    var inputArray = validInput.split(',');
    var trimmedArray = inputArray.map(_ => _.trim());
    var filteredArray = trimmedArray.filter(_ => typeof _ !=== 'undefined');
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
      inputArray => inputArray.map(_ => _.trim()),
      trimmedArray => trimmedArray.filter(_ => typeof _ !=== 'undefined')
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
      inputArray => inputArray.map(_ => _.trim()),
      trimmedArray => trimmedArray.filter(_ => typeof _ !=== 'undefined')
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
  ) // readable, debuggable, all edgecases covered and declarative
  // look ma,
  // no variables, no mutation!
}
```
