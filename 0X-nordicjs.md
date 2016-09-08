title: real world fp, why and how
theme: sudodoki/reveal-cleaver-theme
style: https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.6.0/styles/zenburn.min.css
controls: true

--

# real world fp
## why and how

<del>Monads, Comonad, Monoids, Setoids, Endofunctors.</del>  
Easy to understand, read, test and debug

<br/><br/><br/>
<small>by [Vladimir Starkov](https://iamstarkov.com)</small>  
<small>frontend engineer at [Nordnet Bank AB](https://www.nordnet.se/)</small>

--

## disclaimer

<br>
### no category theory

--

## why FP

* declarative
* composition

--

## sync example

* split by comma
* trim array
* reject empty items

--

## without FP

```javascript
const fn = str =>
  rejectEmptyItems(
    trimArray(
      splitByComma(str)
    )
  )

fn('hello, ,  nordicjs') // ['hello', 'nordicjs']
```
--

## with FP

```javascript
const fn = pipe(
  splitByComma,
  trimArray,
  rejectEmptyItems,
)

fn('hello, nordicjs') // ['hello', 'nordicjs']
```
--

## without FP

```javascript
const fetchJson = url =>
  fetch(url)
    .then(checkStatus)
    .then(parseJSON)

fn('/api/hello') // { hello: 'nordicjs' }
```

--

## with FP

```javascript
const fetchJson = pipeP(
  url,
  checkStatus,
  parseJSON
)

fn('/api/hello') // { hello: 'nordicjs' }
```

--

## debug FP

```javascript
const tap = fn => val => { fn(val); return val; }
const log = tap(val => console.log(val));

const fn = pipe(
  log, // ' hello,    nordicjs'
  splitByComma,
  log, // [' hello', ' ', '  nordicjs']
  trimArray,
  log, // ['hello', '', 'nordicjs']
  rejectEmptyItems,
  log, // ['hello', 'nordicjs']
)

fn(' hello, ,  nordicjs') // ['sup', 'nordicjs']
```
--

## summary

* `pipe`: combine your complexed functions from simple ones
* `pipeP`: even with async and
* `tap`: debug in realtime

--

## References

* "real world fp" workshop repo
    https://github.com/iamstarkov/fp-js-workshop
* "why and how" slides
    https://iamstarkov.com/fp-js-workshop/0X-nordicjs/

--

# real world fp
## why and how

<br>
*In functions we trust*

Sincerely yours [Vladimir Starkov](https://iamstarkov.com)  
_@iamstarkov on [github](https://github.com/iamstarkov) and [twitter](https://twitter.com/iamstarkov)_
