# had
[![Build Status](https://travis-ci.org/elidoran/had.svg?branch=master)](https://travis-ci.org/elidoran/had)
[![Dependency Status](https://gemnasium.com/elidoran/had.png)](https://gemnasium.com/elidoran/had)
[![npm version](https://badge.fury.io/js/had.svg)](http://badge.fury.io/js/had)

Results generator tool for returning objects which contain either success
results or errors.

For more explanation, read [Why had?](#why-had)

## Quick Start

### Install

    npm install had --save

### Require + Create

```coffeescript
had = require('had') name:'name your had'
```

### Return success or error

```coffeescript
return had.error
  error:'invalid user'  # if null, it'll be set to 'error'
  type:'auth'           # if null, it'll be set to 'unknown'
  username:'someone'    # optional value, you can specify as many as you want

return had.success # success only sets value: success:true
  username:'someone'               # optional value
  token:'kJFO2fs8gvhhhg2o34uh9g7f' # optional value
```

### Use success or error result

```coffeescript
result = someCall() # provides someValue

unless had.isSuccess result
  return had.error result

console.log 'I have: ', result.someValue

```

# Table of Contents

1. [Install](#install)
2. [Basic Use](#basic-use)
    1. [Require](#require) and create `had`
    2. [Success](#success) result example
    3. [Error](#error) result example
    4. [Null Argument Check](#null-argument-check)
    5. [Result check](#result-check)
3. [Advanced Use](#advanced-use)
    1. [Had Result ?](#had-result-)
    1. [Include Other Results](#include-other-results)
4. [What's in a Result Object](#whats-in-a-result-object)
    1. [Single Success Result](#single-success-result)
    2. [Multiple Success Results](#multiple-success-results)
    3. [Single Error Result](#single-error-result)
    4. [Multiple Error Results](#multiple-error-results)
    5. [Combined Success and Error Results](#combined-results)
4. [API](#api)
    1. [had.success(options)](#hadsuccessoptions)
    2. [had.error(options)](#haderroroptions)
    3. [had.results(options)](#hadresultsoptions)
    4. [had.addSuccess(options)](#hadaddsuccessoptions)
    5. [had.addError(options)](#hadadderrorptions)
    6. [had.nullArg(argName, arg)](#hadnullargargname-arg)
    7. [had.isSuccess(result)](#hadissuccessresult)
5. [Why had?](#why-had)

## Basic Use

### Require

Require `had` and call its function with options to create an instance.

```coffeescript
had = require('had') name:'my had'
```

### Success

See [had.success(options)](#hadsuccessoptions) for full example.

```coffeescript
add = (num1, num2) -> had.success sum: num1 + num2

result = add 11, 22

console.log 'sum = ', result.sum
```

### Error

See [had.error(options)](#haderroroptions) for full example.

```coffeescript
work = (info) ->
  had.error error:'invalid value', type:'validation', value:'offending value'

result = work someInfo

console.log 'bad value: ', result.value
```

### Null argument check

See [had.nullArg(options)](#hadnullargoptions) for full example.

```coffeescript
if had.nullParam 'info', info
  return had.results() # already contains the error info
```

### Result check

See [had.isSuccess(result)](#hadissuccessresult) for full example.

```coffeescript
result = someCall()

unless had.isSuccess result
  return had.error result

# else it has your success result, use them
```


## Advanced Use


### Had Result ?

```coffeescript
```

### Include other results

You may combine a `had` result you received from elsewhere into your own results. See [Had Result ?](#had-result-) about testing if an object is a `had` result.

```coffeescript
theirResult = someCall()
```



## What's in a Result Object

### Success Results

#### Single Success Result

```coffeescript
successResult = had.success key1:value1, key2:value2, ...
# same as this:
successResult =
  # know which 'had' made this
  had: 'the had name you provided when building the had'
  success: true
  # for categorizing/handling
  type : 'unknown type'
  # all properties provided to had.error() would be here
  key1: value1
  key2: value2
    ....
  keyN: valueN
```

#### Multiple Success Results

When a second success result is added it combines them into an array.

* When the second result is an error they are placed in separate arrays. See [Combined Results](#combined-results)

```coffeescript
had.addSuccess some:'thing'
result = had.success something:'else'
result = # contents of result
  success: true
  successes: [
    { some:'thing'}
    { something:'else'}
  ]
  had: 'the had name you gave it'
```


### Error Results

#### Single Error Result
```coffeescript
errorResult = had.error key1:value1, key2:value2, ...
# same as this:
errorResult =
  # know which 'had' made this
  had: 'the had name you provided when building the had'
  # default error message
  error: 'error'
  # for categorizing/handling
  type : 'unknown type'
  # all properties provided to had.error() would be here
  key1: value1
  key2: value2
    ....
  keyN: valueN
```

#### Multiple Error Results

When a second error result is added it combines them into an array.

* When the second result is a success they are placed in separate arrays. See [Combined Results](#combined-results)

```coffeescript
had.addError error:'unexpected disconnect', type:'network', id:737526355
result = had.error error:'reconnect denied', type:'network', reason:'invalid token'
result = # contents of result
  error: true
  errors: [
    {
      error:'unexpected disconnect'
      type :'network'
      id:737526355
    }
    {
      error:'reconnect denied'
      type :'network'
      reason:'invalid token'
    }
  ]
  had: 'the had name you gave it'
```


### Combined Results

When a second result is added, either success or error, via any of the functions, the results are stored in arrays.

```coffeescript
had.addError error:'someError', type:'theType', input:123
had.addError error:'someError', type:'theType', input:456
had.addSuccess some:'thing'
had.addSuccess something:'else'
results = had.results() # or had.success/error to add another result
results =
  success: true
  error  : true
  successes: [
    {success: true, something:'else'},
    {success: true, some:'thing'},
  ]
  errors: [
    {error:'someError', type:'theType', input:123}
    {error:'someError', type:'theType', input:456}
  ]
```

## API


### **had.success(options)**

Does:
1. creates new Success result from options. See [Success Results](#success-results)
2. if previous results exist, it combines them into arrays. See [Combined Results](#combined-results)
3. clears the `had` so it's ready for new results
4. returns the results

```coffeescript
result = had.success key1:value1, key2:value2
result = # contents of result are:
  success: true
  key1: value1
  key2: value2
  had: name # name provided when creating the 'had'
```

### **had.error(options)**

Does:
1. creates new Error result from options. See [Error Results](#error-results)
2. if previous results exist, it combines them into arrays. See [Combined Results](#combined-results)
3. clears the `had` so it's ready for new results
4. returns the results

```coffeescript
result = had.error error:'null', type:'param', name:'someParam'
result = # contents of result are:
  error: 'null'
  type : 'param'
  name : 'someParam'
  had: name # name provided when creating the 'had'
```

### **had.results(options)**

Return the results stored in `had`.

Does:
1. clears the `had` so it's ready for new results
2. returns the results

```coffeescript
result = had.error error:'null', type:'param', name:'someParam'
result = # contents of result are:
  error: 'null'
  type : 'param'
  name : 'someParam'
  had: name # name provided when creating the 'had'
```

### **had.addSuccess(options)**

Stores a Success result from options and does **not** return the results. The info is held until one of these calls:

1. [had.results(options)](#hadresultsoptions)
2. [had.error(options)](#haderroroptions)
3. [had.success(options)](#hadsuccessoptions)

Does:
1. creates new Error result from options. See [Error Results](#error-results)
2. if previous results exist, it combines them into arrays. See [Combined Results](#combined-results)

```coffeescript
had.addSuccess file: 'someFile', note:'file already existed'
result = had.success file:'anotherFile', note:'file created'
result = # contents of results are:
  success: true
  successes: [
    { file:'someFile', note:'file already existed' }
    { file:'anotherFile', note:'file created'
  ]
```

### **had.addError(options)**

Stores an Error result from options and does **not** return the results. The info is held until one of these calls:

1. [had.results(options)](#hadresultsoptions)
2. [had.error(options)](#haderroroptions)
3. [had.success(options)](#hadsuccessoptions)

Does:
1. creates new Error result from options. See [Error Results](#error-results)
2. if previous results exist, it combines them into arrays. See [Combined Results](#combined-results)

```coffeescript
had.addError error:'delete file failed', type:'fs', file:'fileName'

# had holds that error info until
result = # contents of result are:
  error: 'null'
  type : 'param'
  name : 'someParam'
  had: name # name provided when creating the 'had'
```

### **had.nullArg(argName, arg)**

Returns true if `arg` is null or undefined; false otherwise.

```coffeescript
someParam = 1234
if had.nullArg 'someArg', someArg
  # result = false, so the if's then doesn't run

someArg = null
if had.nullArg 'someArg', someArg
  result = had.results()
  result = # contents of results are:
    error: 'null'
    type : 'arg'
    name : 'someArg'

```

### **had.isSuccess(result)**

Returns true when `result` is `true` or a `had` success result.

```coffeescript
result = someWork() # any value, might be a `had` result

unless had.isSuccess result # unless falsey or a `had` error result
  had.error result          # return an error containing other result  
```


## Why had?

I've had enough of throwing errors when a common problem occurs and
writing try-catch statements to handle errors thrown by other's. They are often
poorly descriptive of the issue. In JavaScript they are often swallowed by some
layer of an application.

Avoid throw/catching errors by returning results in an object. Then, when
errors occur, they can be placed in the `had` object and returned. Normal flow
control, no *throw* involved. All the code using `had` for its results should
check if there's an error and do something different when there is. This causes:

1. the programmer **must** directly write helpful error information into an error
object instead of throwing an Error with a general message. This aids in
debugging, of course. It also encourages the programmer to spend time really
thinking about what's happening and what information someone else will want to
know about the error from that point in the source code.

2. the programmer calling the code can know what *detailed* information they'll
receive when an error is returned and it's readily available in the object. No
testing strings in Error messages.

3. with standard error `type`, and corresponding info, we can write reusable
error handling tools which make writing error handling simpler.

4. no stepping outside the normal program flow to fly up through layers until a
try-catch is encountered. That has use for errors representing system failures
which must bail up to a handler. All those other errors? Let's manage them
directly. Instead, require the caller directly above the error occurrence to
inspect the return results, discover the error, and respond. We can include a
lot of information rarely included in thrown errors.


## MIT License
