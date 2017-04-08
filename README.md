# had
[![Build Status](https://travis-ci.org/elidoran/had.svg?branch=master)](https://travis-ci.org/elidoran/had)
[![Dependency Status](https://gemnasium.com/elidoran/had.png)](https://gemnasium.com/elidoran/had)
[![npm version](https://badge.fury.io/js/had.svg)](http://badge.fury.io/js/had)

Results generator tool for returning objects which contain either a success
result or an error result.

It's possible to use this for every function return result. However, I think it's most appropriate at boundaries.

For example, when returning a result from a library's public API. The boundary is where values leave a library's control. It may also be helpful in important or significant functions. There are plenty of "little functions" to simply return the straight value.

However, if this was used everywhere, the insight and control of return results would be considerable. It can build up a history of return results which allows an insight into an error which was passed up multiple times.

Also, the information about an error is much more specific when it's used to specify exactly what's going on in the code at the place the error result is generated. It can say which array variable, which index, what it is trying to do with it, and more.

The main thing to keep in mind is this means a function will always return an object. That object is an error if it has an `error` property. Otherwise, it's a success result, and may have a `value` property containing the success result value.

For more explanation, read [Why had?](#why-had)

Note, v0.7.0 includes significant changes due to a rewrite.


## Quick Start

### Install

    npm install had --save


### Require + Create

```javascript
var had = require('had')({ id:'name your had' })

// OR:
var buildHad = require('had')
  , had = buildHad({ id: 'name your had' })
```


### Return success or error

```javascript
// provide the object you want stored in the `error` property
// of the error result object.
// if you don't provide one then `'unknown'` will be used.
return had.error({
  message:'invalid user',
  type:'auth',
  username:'someone',
})

// provide the object you want stored in the `value` property
// of the success result object.
// if you don't provide one then no `value` property
// is set on the result object.
return had.success({
  username:'someone',               // optional value
  token:'kJFO2fs8gvhhhg2o34uh9g7f', // optional value
})
```


### Use success or error result

```javascript
// receive a result from a function which provides
// `had` result objects.
var result = someCall()

// test if it is a successful result or an error.
// NOTE: do this yourself by check for `error` property.
if (had.isSuccess(result)) {
  // success, so, use `result.value`
} else {
  // return the error result, but,
  // wrap it with our had.
  return had.error(result)
  // or, provide our own error info about
  // receiving this error here.
  // NOTE: we provide the error result we just
  // received first so it is part of the error
  // result we return as a `previous` result.
  return had.error(result, {
    our:'error', info:'for', right:'here'
  })
}

// OR:
// check for error property:
if (result.error) {
  // return the error result instead of wrapping
  // it with your own had.error() call.
  return result
} else {
  // no error, so, use `result.value`
}

console.log('I have: ', result.value.something)
```


# Table of Contents

1. [Install](#install)
2. [Basic Use](#basic-use)
    1. [Require](#require) and create `had`
    2. [Success](#success) result example
    3. [Error](#error) result example
    4. [Null Argument Check](#null-argument-check)
    5. [Null Property Check](#null-property-check)
    6. [Result check](#result-check)
    7. [Combo](#combo)
3. [Advanced Use](#advanced-use)
    1. [Had Result ?](#had-result-)
    1. [Include Other Results](#include-other-results)
4. [What's in a Result Object](#whats-in-a-result-object)
    1. [Single Success Result](#single-success-result)
    2. [Single Error Result](#single-error-result)
    3. [Multiple Success Results](#multiple-success-results)
    4. [Multiple Error Results](#multiple-error-results)
    5. [Some Mixed Results](#some-mixed-results)
4. [API](#api)
    1. [had.success(value)](#hadsuccessvalue)
    2. [had.error(value)](#haderrorvalue)
    3. [had.results(options)](#hadresultsoptions)
    4. [had.addSuccess(value)](#hadaddsuccessvalue)
    5. [had.addError(value)](#hadadderrvalue)
    6. [had.nullArg(argName, arg)](#hadnullargargname-arg)
    7. [had.nullProp(key, object)](#hadnullpropskey-object)
    8. [had.isSuccess(result)](#hadissuccessresult)
5. [Why had?](#why-had)
6. [Future Plans](#future-plans)
    1. [Register Handlers](#register-handlers)
7. [MIT License](LICENSE)


## Basic Use


### Require

Require `had` and call its function with options to create an instance.

```javascript
var had = require('had')({ id:'name your had' })

// OR:
var buildHad = require('had')
  , had = buildHad({ id: 'name your had' })
```


### Success

[Back to: Table of Contents](#table-of-contents)

See [had.success(value)](#hadsuccessvalue) for full example.

```javascript
function add(num1, num2) {
  return had.success({ sum: num1 + num2 })
}

var result = add(11, 22)

console.log('sum = ', result.value.sum)
```


### Error

[Back to: Table of Contents](#table-of-contents)

See [had.error(value)](#haderrorvalue) for full example.

```javascript
function work(info) {
  return had.error({
    message:'invalid value', type:'validation', value:'offending value'
  })
}

var result = work(someInfo)

console.log('bad value: ', result.error)
```


### Null argument check

[Back to: Table of Contents](#table-of-contents)

See [had.nullArg(options)](#hadnullargoptions) for full example.

```javascript
if (had.nullArg('info', info))
  return had.results() // already contains the error info
```


### Null property check

[Back to: Table of Contents](#table-of-contents)

See [had.nullProp(options)](#hadnullpropoptions) for full example.

```javascript
var object = {
  some: 'thing',
  another: null
}

if (had.nullProp('some', object)) {
  // would already contain the error info
  return had.results()
}

// returns true when property:
//   1. doesn't exist
//   2. is null
//   3. is undefined
if (had.nullProp('another', object)) {
  // would already contain the error info.
  return had.results()
}

// NOTE:
//  because it builds up results it's possible to run
//  nullProp() and nullArg() multiple times and
//  then return had.results() which will contain all the
//  error results.
```


### Result check

[Back to: Table of Contents](#table-of-contents)

See [had.isSuccess(result)](#hadissuccessresult) for full example.

```javascript
var result = someCall()

if ( ! had.isSuccess(result))
  return had.error(result)
// else it has your success result, use them

// OR:
if (result.error) {
  // handle the error or pass it up via return
} else {
  // use the success result value
}
```


### Combo

[Back to: Table of Contents](#table-of-contents)

Above sections are simple "this is how to call it" examples. Below is a more complete example using all of the "basic usage" functions.

```javascript
var had = require('had')({ id:'sum' })

function valid(num) {
  var type

  type = typeof num

  if (had.nullArg('num', num)) {
    // returns the null arg error result
    return had.result()
  } else if (type != 'number') {
    return had.error({
      // allows adding extra info such as the type of error: typeof
      // what the value was and what its typeof value is.
      // this can be used to inform error handlers and provide
      // specifics to error logging.
      message:'number required', type:'typeof', is:type, value:num
    })
  } else {
    // return a simple success result (empty, no value)
    return had.success()
  }
}

function add(num1, num2) {
  var sum
    , result

  result = valid(num1)

  if (result.error) {
    // include error result and our added info
    return had.error(result, { message:'invalid num1' })
  }

  result = valid(num2)

  if (result.error) {
    // include error result and our added info
    return had.error(result, { message:'invalid num2' })
  }

  sum = num1 + num2

  return had.success({ sum: sum })
}

var result = add(123, 'abc')
// this is what the result is like.
// contains both errors.
result = {
  had: 'sum',
  error: {
    message: 'invalid num2'
  },
  previous: [
    {
      had: 'sum'
      error: {
        message: 'number required',
        type   : 'typeof',
        is     :'string',
        value  : 'abc',
      }
    }
  ]
}

if (had.isSuccess(result)) {
  console.log('sum =', result.value.sum)
} else {
  // handle the `result.error` info
}

result = add(11, 22)
// this is the success result:
result = {
  had: 'sum',
  value: {
    sum: 33
  },
  previous: null
}

if (result.error) {
  // handle error result
} else {
  console.log('sum = ', result.value.sum)
}
```


## Advanced Use

### Had Result ?

[Back to: Table of Contents](#table-of-contents)

Check a result to see if it was provided by a `had` instance?

I haven't implemented this specifically because I haven't seen a use for it yet.

Instead, what I do is check for a falsey value, or `had` error, and return an error including the result.

```javascript
// receive a result from something using had
var result = someCall()

// check if it's a success result
if ( ! had.isSuccess(result)) {
  // when it's not, include it in the error result.
  return had.error(result)
}
```

See [had.isSuccess(result)](#hadissuccessresult)

See directly below for explanation of how the result is included.


### Include other results

[Back to: Table of Contents](#table-of-contents)

You may combine a `had` result you received from elsewhere into your own results.
See [Had Result ?](#had-result-) about testing if an object is a `had` result.
(also shown directly above this section.)

```javascript
var result = someCall()

return had.error(result, {
  message:'something failed', type:'fail'
})
// (bad examples)
```

That's it. If it's a `had` result it will be included in your error result.

**Note:** When it's instead a falsey value (false, null, undefined, empty string) then only
the error info you provide is used to create your error.


## What's in a Result Object

### Single Success Result

[Back to: Table of Contents](#table-of-contents)

```javascript
var had = require('had')({ id:'success' })
  , result

// it's okay to call success() w/out a value.
result = had.success()
// it looks like this:
result = {
  had: 'success',
  previous: null
}

// or, provide anything you want for the value
result = had.success({
  key1:'value1', key2:'value2'
})
// looks like this:
result = {
  had: 'success',
  value: {
    key1:'value1', key2:'value2'
  },
  previous: null
}
```


### Single Error Result

[Back to: Table of Contents](#table-of-contents)

```javascript
var had = require('had')({ id:'error' })
  , result = had.error({
    message:'something bad'
  })

// it looks like this:
result = {
  had: 'error',
  error: {
    message:'something bad',
  },
  previous: null
}
```


### Multiple Results

#### Multiple Success Results

[Back to: Table of Contents](#table-of-contents)

When a second result is added it becomes the current return result and stores the previous result.

This pattern continues with each subsequent result added until the result is finally pulled out for a return.

How to pull out all stored return results:

1. `had.results()` - uses the most recent result as the main return result and all others are in an array set into property `previous`.
2. `had.error()` and `had.success()` - they will gather all results and return them. These accept a single result to use for the most recent result, and, they can accept two arguments with the first one a "had result" from another call to include as well.

It doesn't matter whether results are success or error results. The most recent result is what's returned to `result` and the previous results are in an array set into `previous` property on the result.

```javascript
var had = require('had')({ id:'multi' })
  , result

// this stores a success result into the `had`  
had.addSuccess({ some:'thing', first:true })

// this creates a new success result and puts the previous one
// into `previous` property in an array.
result = had.success({ something:'else', second:true })
result = { // contents of result
  had: 'multi',
  value: {
    something:'else', second:true
  },
  previous: [
    // array order is first element is the *oldest* result
    // second most recent result is last in the array
    // (most recent is the one set into `result` above)
    {
      had: 'multi',
      value: {
        some:'thing', first:true
      }
      // no previous property on results in the `previous` array.
    },
  ],
}
```

#### Multiple Error Results

[Back to: Table of Contents](#table-of-contents)

```javascript
var had = require('had')({ id:'multi' })
  , result

had.addError({
  message:'unexpected disconnect',
  type:'network',
  id:737526355
})

result = had.error({
  message:'reconnect denied',
  type:'network',
  reason:'invalid token'
})
result = { // contents of result
  had: 'multi',
  error: {
    message:'reconnect denied',
    type :'network',
    reason:'invalid token',
  },
  previous: [
    {
      message:'unexpected disconnect',
      type :'network',
      id:737526355,
    },
  ],
}
```

#### Some mixed results:

[Back to: Table of Contents](#table-of-contents)

```javascript
var had = require('had')({ id:'mixed' })
  , result

had.addError({ message:'someError', type:'theType', input:123 })
had.addSuccess({ some:'thing' })
had.addError({ message:'someError', type:'theType', input:456 })
had.addSuccess({ something:'else' })
// use had.results() to get current results.
// or,use had.success() instead of had.addSuccess() above.
var results = had.results()
results = {
  // the last result, a success
  had: 'mixed',
  value: {
    something: 'else'
  },
  previous: [
    { // the first result, an error
      had: 'mixed',
      error: {
        message:'someError', type:'theType', input:123,
      }
    },
    { // the second result, a success
      had: 'mixed',
      value: {
        some:'thing'
      }
    },
    { // the third result, an error
      had: 'mixed',
      error: {
        message:'someError', type:'theType', input:456,
      }
    },
  ],
}
```

## API
[Back to: Table of Contents](#table-of-contents)


### **had.success(value)**
[Back to: Table of Contents](#table-of-contents)

Does:

1. creates new success result with `value`. See [Success Results](#success-results)
2. if previous results exist, they are included in an array in the `previous` property. See [Multiple Results](#multiple-results)
3. clears the `had` so it's ready for new results
4. returns the results

```javascript
var had = require('had')({ id:'success' })
  , result = had.success({
    key1:'value1', key2:'value2'
  })

result = { // contents of result are:
  had: 'success',
  value: {
    key1: 'value1',
    key2: 'value2',
  },
  // previous results would be in an array here.
  // ordered oldest to newest
  previous: null
}
```

##### Note

Two arguments are used when including another result into this one. When both arguments are provided it is assumed the first one is the result to include, and the second is your success value. When the first argument is a simple (non-had) value then it isn't used.

```javascript
result = someCall()
// if result is a "had result" then it is included as a
// previous result and then the second argument is used
// to make the main return result.
had.success(result, { some:'thing' })
```


### **had.error(value)**

[Back to: Table of Contents](#table-of-contents)

Does:

1. creates new error result from error. See [Error Results](#error-results)
2. if previous results exist, they are included in an array in the `previous` property. See [Multiple Results](#multiple-results)
3. clears the `had` so it's ready for new results
4. returns the results

```javascript
var had = require('had')({ id:'error' })
  , result = had.error({
    message:'null', type:'param', name:'someParam'
  })
result = { // contents of result are:
  had: 'error',
  error: {
    message:'null',
    type: 'param',
    name: 'someParam',
  },
  // previous results would be in an array here.
  // ordered oldest to newest
  previous: null
}
```

##### Note

Two arguments are used when including another result into this one. When both arguments are provided it is assumed the first one is the result to include, and the second is your error. When the first argument is a simple (non-had) value then it isn't used.

```javascript
result = someCall()
// if result is a "had result" then it is included as a
// previous result and then the second argument is used
// to make the main return result.
had.error(result, { message:'error' })
```


### **had.results(options)**

[Back to: Table of Contents](#table-of-contents)

Return the results stored in `had`.

Does:

1. clears the `had` so it's ready for new results
2. returns the results
3. if there are no results then it returns `{ had: 'its id' }`
4. I didn't have a use for the `options` argument so it's currently copying its properties into the result object so it's possible to override the result info.

```javascript
var had = require('had')({ id:'results' })
  , result = had.addError({
    message:'null', type:'param', name:'someParam'
  })

// result = true, it was added
// now call results() to get that object
result = had.results()
result = { // contents of result are:
  had: 'results',
  error: {
    message: 'null',
    type: 'param',
    name: 'someParam',
  },
  previous: null
}
```


### **had.addSuccess(value)**

[Back to: Table of Contents](#table-of-contents)

Stores a Success result from value and does **not** return the results. The info is held until one of these are called:

1. [had.results(options)](#hadresultsoptions)
2. [had.error(value)](#haderrorvalue)
3. [had.success(value)](#hadsuccessvalue)

Does:

1. creates new error result from value. See [Error Results](#error-results)
2. if previous results exist, they are included in an array in the `previous` property. See [Multiple Results](#multiple-results)

```javascript
var had = require('had')({ id:'add' })
  , result

had.addSuccess({
  file: 'someFile', note:'file already existed',
})

result = had.success({
  file:'anotherFile', note:'file created'
})
result = { // contents of results are:
  had: 'add',
  value: {
    file:'anotherFile', note:'file created',
  },
  previous: [
    {
      had: 'add',
      value: {
        file:'someFile', note:'file already existed',
      },
    },
  ],
}
```

### **had.addError(value)**

[Back to: Table of Contents](#table-of-contents)

Stores an Error result from options and does **not** return the results. The info is held until one of these calls:

1. [had.results(options)](#hadresultsoptions)
2. [had.error(value)](#haderrorvalue)
3. [had.success(value)](#hadsuccessvalue)

Does:

1. creates new error result from value. See [Error Results](#error-results)
2. if previous results exist, they are included in an array in the `previous` property. See [Multiple Results](#multiple-results)

```javascript
var had = require('had')({ id:'add' })
  , result

had.addError({
  message:'path is a directory',
  type:'fs',
  file:'fileName'
})

result = had.error({
  message:'delete file failed',
  type:'fs',
  file:'fileName',
})
result = { // contents of result are:
  had: 'add'
  error: {
    message:'delete file failed',
    type:'fs',
    file:'fileName',
  },
  previous: [
    {
      had: 'add',
      error: {
        message:'path is a directory'
        type:'fs',
        file:'fileName',
      },
    }
  ]
}
```

### **had.nullArg(argName, arg)**

[Back to: Table of Contents](#table-of-contents)

Returns true if `arg` is null or undefined; false otherwise.

```javascript
var had = require('had')({ id:'arg' })
  , someArg = 1234
  , result

if (had.nullArg('someArg', someArg)) {
  // result = false, so the if won't run
}

someArg = null
if (had.nullArg('someArg', someArg)) {
  // it is null so this if does run.
  // what the results() looks like right now:
  result = had.results()
  result = { // contents of results are:
    had: 'arg',
    error: {
      message: 'null',
      type: 'arg',
      name: 'someArg',
    },
    previous: null,
  }
}
```


### **had.nullProps(key, object)**

[Back to: Table of Contents](#table-of-contents)

Returns true if the `key` in `object` is null or undefined; false otherwise.

```javascript
var had = require('had')({ id:'prop' })
  , object1 = { some: 'thing' }
  , object2 = { some: null }
  , object3 = null

if (had.nullProp('some', object1)) {
  // result = false, so the if won't run
}

if (had.nullProp('some', object2)) {
  // it is null so this if does run.
  // what the results() looks like right now:
  result = had.results()
  result = { // contents of results are:
    had: 'prop',
    error: {
      message: 'null',
      type: 'prop',
      name: 'some',
      // NOTE:
      // no `object` property cuz
      // the object wasn't null, the prop was.
    },
    previous: null,
  }
}

if (had.nullProp('some', object3)) {
  // the object itself is null
  // so, this if will run.
  // what the results() looks like right now:
  result = had.results()
  result = { // contents of results are:
    had: 'prop',
    error: {
      message: 'null',
      type: 'prop',
      name: 'some',
      // NOTE:
      //   this means the object itself was null.
      object: true,
    },
    previous: null,
  }
}
```


### **had.isSuccess(result)**

[Back to: Table of Contents](#table-of-contents)

Returns true when `result` is a `had` success result with no error property or when a truthy value; otherwise, false.

```javascript
// any value, might be a `had` result, might not
var result = someWork()

// if not a truthy or a `had` success result
if ( ! had.isSuccess(result)) {
  // return an error containing other result  
  had.error(result)
}
```


## Why had?

[Back to: Table of Contents](#table-of-contents)

I've had enough of throwing errors when a common problem occurs and
writing try-catch statements to handle errors thrown by other's. They are often
poorly descriptive of the issue. In JavaScript they are often swallowed by some
layer of an application. And, try-catch blocks aren't optimized by V8.

Avoid throwing/catching errors by always returning a result object. Put errors into the `error` property and put success values into `value` property. Then, test for error by checking if the `error` property exists.

Then, when errors occur, they can returned using `had` to format them. Then we're using normal flow control with no *throw* involved; no exception. All the code using `had` for its results should check if there's an error and do something different when there is.

This causes:

1. the programmer may provide helpful error information into an error object instead of throwing an Error with a general message. This aids in debugging, of course. It also encourages the programmer to spend time really thinking about what's happening and what information someone else will want to know about the error at that point in the source code.

2. the programmer calling the code can know ahead of time what *detailed* information they'll receive when an error is returned. No testing strings in Error messages.

3. develop a standard error property usage pattern, such as a `type`, and corresponding info, then, you can write reusable error handling tools which make writing error handling simpler.

4. no stepping outside the normal program flow to fly up through layers until a try-catch is encountered. That has use for errors representing system failures which must bail up to a handler. All those other errors? Let's manage them directly. Instead, require the caller directly above the error occurrence to inspect the return results, discover the error, and respond. We can include a lot of information rarely included in thrown errors. It's possible to still pass-the-buck up by returning received error results directly or by including it in a new call to `had.error()` to add your error info on top of the previous one. Then, the receiver above gets both results.

5. changes the perception from always expecting return results to be a success value to expecting the return result to either have the success value in `result.value` or an error in `result.error`.


## Future Plans

[Back to: Table of Contents](#table-of-contents)

There are more checks I could add, such as one which helps test arrays.

The current API primarily expects synchronous usage. It's possible to generate the results and pass them to a callback instead of returning them. In which case, the callbacks would need to shift from expecting two args like `(error, success)` to expecting a single arg containing the result like `(result)`.

Then, instead of doing:

```javascript
function callback(error, result) {
  if (error) {
    // handle the error
    return
  }

  // handle the `result`
}
```

We'd have callbacks like:

```javascript
function callback(result) {
  if (result.error) {
    // handle the error
    return
  }

  // handle the result: `result.value`
}
```

Although the above is possible I'm sure I could do more to support asynchronous code.

For example, provide an adaptor which wraps traditional callbacks to accept a had result object and then call the traditional callback with `(result.error, result.value)`.


### Register Handlers

[Back to: Table of Contents](#table-of-contents)

I have an idea to allow registering functions on a `had` which run for specific
`error` or `type` values. Could let the functions look at the object and decide
if they will do anything or not, or, use a strategy pattern to select them.

Then, if someone wanted to change a library to throw Errors instead, (hey, some
persons really like thrown errors), they can register a handler which does
exactly that.

Or, it could alter an error object, or log it, or report it to another tool, or
send info to a developer-mode tool, or grab extra info from a service, or
prevent the error from being used (maybe a library is sending something as an
error and the library user disagrees).

There are a lot of possibilities.

[Back to: Table of Contents](#table-of-contents)

## License

[MIT](LICENSE)
