

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
