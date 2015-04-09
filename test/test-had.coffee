assert = require 'assert'
Had = require '../index'

describe 'test had\'s functions', ->

  describe 'test had id', ->

    it 'should have id in had', ->
      id = 'test-id'
      had = Had id:id
      assert.equal had.id, id, 'had should have its id'

  describe 'test isSuccess', ->
    #before ->
    beforeEach 'create new had(\'isSuccess\')', ->
      this.had = Had id:'isSuccess'

    describe 'isSuccess of null', ->

      it 'should return false', ->

        result = this.had.isSuccess null
        assert.equal result, false

    describe 'isSuccess of undefined', ->

      it 'should return false', ->

        result = this.had.isSuccess undefined
        assert.equal result, false

    describe 'isSuccess of empty object', ->

      it 'should return true', ->

        result = this.had.isSuccess {}
        assert.equal result, true

    describe 'isSuccess of non-empty object', ->

      it 'should return true', ->

        result = this.had.isSuccess some:'thing'
        assert.equal result, true

    describe 'isSuccess of object with had prop', ->

      it 'should return true', ->

        result = this.had.isSuccess had:'test'
        assert.equal result, true

    describe 'isSuccess of empty array', ->

      it 'should return true', ->

        result = this.had.isSuccess []
        assert.equal result, true

    describe 'isSuccess of non-empty array', ->

      it 'should return true', ->

        result = this.had.isSuccess ['one']
        assert.equal result, true

    describe 'isSuccess of true', ->

      it 'should return true', ->

        result = this.had.isSuccess true
        assert.equal result, true

    describe 'isSuccess of false', ->

      it 'should return false', ->

        result = this.had.isSuccess false
        assert.equal result, false

    describe 'isSuccess of a had success result, single', ->

      it 'should return true', ->

        successResult = had:'sample name', success:true, some:'test'
        result = this.had.isSuccess successResult
        assert.equal result?, true, 'result should exist'
        assert.equal result, true

    describe 'isSuccess of a had success result, multiple', ->

      it 'should return true', ->

        successResult =
          had:'sample name'
          success:true
          successes: [
            had:'sample name', success:true, some:'test'
            had:'sample name', success:true, some:'test2'
          ]
        result = this.had.isSuccess successResult
        assert.equal result?, true, 'result should exist'
        assert.equal result, true

    describe 'isSuccess of a had success+error result', ->

      it 'should return false', ->

        comboResult =
          had:'sample name'
          success:true
          error  :'multiple'
          successes: [had:'sample name', success:true, some:'test']
          errors: [had:'sample name', error:'test', type:'test', some:'testy']
        result = this.had.isSuccess comboResult
        assert.equal result?, true, 'result should exist'
        assert.equal result, false

    describe 'isSuccess of a had error result, single', ->

      it 'should return false', ->

        errorResult = had:'sample name', error:'sample error'
        result = this.had.isSuccess errorResult
        assert.equal result?, true, 'result should exist'
        assert.equal result, false

    describe 'isSuccess of a had error result, multiple', ->

      it 'should return false', ->

        errorResult =
          had:'sample name'
          error:'multiple'
          errors: [
            had:'sample name', error:'test', some:'test'
            had:'sample name', error:'test', some:'test2'
          ]
        result = this.had.isSuccess errorResult
        assert.equal result?, true, 'result should exist'
        assert.equal result, false

  describe 'test nullArg', ->

    beforeEach 'create new had(\'nullArg\')', ->
      this.had = Had id:'nullArg'

    describe 'with undefined', ->

      it 'should fill error content and return true', ->

        result = this.had.nullArg 'test', undefined
        assert.equal result?, true, 'result should exist'
        assert.equal result, true
        assert.equal this.had.current.had, 'nullArg'
        assert.equal this.had.current.error, 'null'
        assert.equal this.had.current.type,  'arg'
        assert.equal this.had.current.name,  'test'

    describe 'with null', ->

      it 'should fill error content and return true', ->

        result = this.had.nullArg 'test', null
        assert.equal result?, true, 'result should exist'
        assert.equal result, true
        assert.equal this.had.current.had, 'nullArg'
        assert.equal this.had.current.error, 'null'
        assert.equal this.had.current.type,  'arg'
        assert.equal this.had.current.name,  'test'

    describe 'twice with undefined', ->

      it 'should fill error content and return true', ->

        first = had:'nullArg', error:'null', type:'arg', name:'test1'
        second= had:'nullArg', error:'null', type:'arg', name:'test2'

        result1 = this.had.nullArg 'test1', undefined
        result2 = this.had.nullArg 'test2', undefined

        assert.equal result1?, true, 'result1 should exist'
        assert.equal result2?, true, 'result2 should exist'
        assert.equal result1, true
        assert.equal result2, true
        assert.equal this.had.current.had, 'nullArg'
        assert.equal this.had.current.error, 'multiple'
        assert.equal this.had.current.errors.length, 2, 'current.errors should contain two errors'
        assert.deepEqual this.had.current.errors[0], first
        assert.deepEqual this.had.current.errors[1], second

    describe 'with empty string', ->

      it 'should return false', ->

        result = this.had.nullArg 'test', ''
        assert.equal result, false

    describe 'with non-empty string', ->

      it 'should return false', ->

        result = this.had.nullArg 'test', 'string'
        assert.equal result, false

    describe 'with 0', ->

      it 'should return false', ->

        result = this.had.nullArg 'test', 0
        assert.equal result, false

    describe 'with 1', ->

      it 'should return false', ->

        result = this.had.nullArg 'test', 1
        assert.equal result, false

    describe 'with -1', ->

      it 'should return false', ->

        result = this.had.nullArg 'test', -1
        assert.equal result, false

    describe 'with empty array', ->

      it 'should return false', ->

        result = this.had.nullArg 'test', []
        assert.equal result, false

    describe 'with non-empty array', ->

      it 'should return false', ->

        result = this.had.nullArg 'test', [ 'something' ]
        assert.equal result, false

    describe 'with empty object', ->

      it 'should return false', ->

        result = this.had.nullArg 'test', {}
        assert.equal result, false

    describe 'with non-empty object', ->

      it 'should return false', ->

        result = this.had.nullArg 'test', { some: 'thing' }
        assert.equal result, false

    describe 'with Date', ->

      it 'should return false', ->

        result = this.had.nullArg 'test', new Date()
        assert.equal result, false

    describe 'with Function', ->

      it 'should return false', ->

        result = this.had.nullArg 'test', ->
        assert.equal result, false

  describe 'test success', ->

    beforeEach 'create new had(\'success\')', ->
      this.had = Had id:'success'

    describe 'with no options', ->

      it 'should return success result', ->

        result = this.had.success()
        assert.equal result?, true, 'result should exist'
        assert.equal result.had, 'success', 'result.had should be \'success\''
        assert.equal result.success, true, 'result.success should be true'

    describe 'with one option', ->

      it 'should return success result with extra option', ->

        result = this.had.success test:'option'
        assert.equal result?, true, 'result should exist'
        assert.equal result.had, 'success', 'result.had should be \'success\''
        assert.equal result.success, true, 'result.success should be true'
        assert.equal result.test?, true, 'result.test should exist'
        assert.equal result.test, 'option'

    describe 'with an \'error\' property true', ->

      it 'returns the success result with an _error_ property', ->

        successResult =
          had: 'success'
          success: true
          _error_:'test'
        result = this.had.success error:'test'
        assert.equal result?, true, 'result should exist'
        assert.deepEqual result, successResult

    describe 'with previous error result to include', ->

      it 'should return both results', ->

        previousError =
          had: 'anotherHad'
          error:'previous issue'
          type:'something else'
          some:'thing'

        thisResult =
          had: 'success'
          success:'true'

        combinedResult =
          had: 'success'
          success:true
          successes: [thisResult]
          error: 'multiple'
          errors: [previousError]
        result = this.had.success previousError, thisResult

        assert.equal result?, true, 'result should exist'
        assert.equal result.had?, true, 'result.had should exist'
        assert.equal result.had, 'success', 'result.had should be \'error\''
        assert.equal result.error?, true, 'result.error should exist'
        assert.equal result.error, 'multiple'
        assert.deepEqual result, combinedResult

    describe 'with previous success result to include', ->

      it 'should return both successes', ->

        previousResult =
          had: 'anotherHad'
          success:true
          some:'thing'

        thisResult =
          had: 'success'
          success:true
          something:'else'

        combinedResult =
          had: 'success'
          success:true
          successes: [previousResult, thisResult]
        result = this.had.success previousResult, something:'else'

        assert.equal result?, true, 'result should exist'
        assert.deepEqual result, combinedResult

    describe 'with previous true result to include', ->

      it 'should return the one success', ->

        thisResult =
          had: 'success'
          success:true
          some:'thing'

        result = this.had.success true, some:'thing'

        assert.equal result?, true, 'result should exist'
        assert.deepEqual result, thisResult

    describe 'with previous false result to include', ->

      it 'should return the one success', ->

        thisResult =
          had: 'success'
          success:true
          some:'thing'

        result = this.had.success false, some:'thing'

        assert.equal result?, true, 'result should exist'
        assert.deepEqual result, thisResult

  describe 'test error', ->

    beforeEach 'create new had(\'error\')', ->
      this.had = Had id:'error'

    describe 'with no options', ->

      it 'should return error result', ->

        result = this.had.error()
        assert.equal result?, true, 'result should exist'
        assert.equal result.had?, true, 'result.had should exist'
        assert.equal result.had, 'error', 'result.had should be \'error\''
        assert.equal result.error?, true, 'result.error should exist'
        assert.equal result.error, 'error'
        assert.equal result.type?, true, 'result.type should exist'
        assert.equal result.type, 'unknown'

    describe 'with \'error\' option', ->

      it 'should return error result with error option', ->

        result = this.had.error error:'test'
        assert.equal result?, true, 'result should exist'
        assert.equal result.had?, true, 'result.had should exist'
        assert.equal result.had, 'error', 'result.had should be \'error\''
        assert.equal result.error?, true, 'result.error should exist'
        assert.equal result.error, 'test'
        assert.equal result.type?, true, 'result.type should exist'
        assert.equal result.type, 'unknown'

    describe 'with \'type\' option', ->

      it 'should return error result with type option', ->

        result = this.had.error type:'test'
        assert.equal result?, true, 'result should exist'
        assert.equal result.had?, true, 'result.had should exist'
        assert.equal result.had, 'error', 'result.had should be \'error\''
        assert.equal result.error?, true, 'result.error should exist'
        assert.equal result.error, 'error'
        assert.equal result.type?, true, 'result.type should exist'
        assert.equal result.type, 'test'

    describe 'with \'extra\' option', ->

      it 'should return error result with extra option', ->

        result = this.had.error extra:'test'
        assert.equal result?, true, 'result should exist'
        assert.equal result.had?, true, 'result.had should exist'
        assert.equal result.had, 'error', 'result.had should be \'error\''
        assert.equal result.error?, true, 'result.error should exist'
        assert.equal result.error, 'error'
        assert.equal result.type?, true, 'result.type should exist'
        assert.equal result.type, 'unknown'
        assert.equal result.extra?, true, 'result.extra should exist'
        assert.equal result.extra, 'test'

    describe 'with \'success\' option', ->

      it 'should return error result with _success_ property', ->

        result = this.had.error _success_:'test'
        assert.equal result?, true, 'result should exist'
        assert.equal result.had?, true, 'result.had should exist'
        assert.equal result.had, 'error', 'result.had should be \'error\''
        assert.equal result.error?, true, 'result.error should exist'
        assert.equal result.error, 'error'
        assert.equal result.type?, true, 'result.type should exist'
        assert.equal result.type, 'unknown'
        assert.equal result._success_?, true, 'result._success_ should exist'
        assert.equal result._success_, 'test'

    describe 'with previous error result to include', ->

      it 'should return both errors', ->

        previousError =
          had: 'anotherHad'
          error:'previous issue'
          type:'something else'
          some:'thing'

        thisError =
          had: 'error'
          error:'testing'
          type:'test'

        combinedError =
          had: 'error'
          error: 'multiple'
          errors: [previousError, thisError]
        result = this.had.error previousError, thisError

        assert.equal result?, true, 'result should exist'
        assert.equal result.had?, true, 'result.had should exist'
        assert.equal result.had, 'error', 'result.had should be \'error\''
        assert.equal result.error?, true, 'result.error should exist'
        assert.equal result.error, 'multiple'
        assert.deepEqual result, combinedError

    describe 'with previous success result to include', ->

      it 'should return both errors', ->

        previousResult =
          had: 'anotherHad'
          success:true
          some:'thing'

        thisError =
          had: 'error'
          error:'testing'
          type:'test'

        combinedResult =
          had: 'error'
          success:true
          successes: [previousResult]
          error: 'multiple'
          errors: [thisError]
        result = this.had.error previousResult, thisError

        assert.equal result?, true, 'result should exist'
        assert.equal result.had?, true, 'result.had should exist'
        assert.equal result.had, 'error', 'result.had should be \'error\''
        assert.equal result.error?, true, 'result.error should exist'
        assert.equal result.error, 'multiple'
        assert.equal result.success?, true, 'result.error should exist'
        assert.equal result.success, true, 'result.success should be true'
        assert.deepEqual result, combinedResult

    describe 'with previous true result to include', ->

      it 'should return the one error', ->

        thisError =
          had: 'error'
          error:'testing'
          type:'test'

        result = this.had.error true, error:'testing', type:'test'

        assert.equal result?, true, 'result should exist'
        assert.equal result.had?, true, 'result.had should exist'
        assert.equal result.had, 'error', 'result.had should be \'error\''
        assert.equal result.error?, true, 'result.error should exist'
        assert.equal result.error, 'testing'
        assert.equal result.type?, true, 'result.type should exist'
        assert.equal result.type, 'test',
        assert.deepEqual result, thisError

    describe 'with previous false result to include', ->

      it 'should return the one error', ->

        thisError =
          had: 'error'
          error:'testing'
          type:'test'

        result = this.had.error true, error:'testing', type:'test'

        assert.equal result?, true, 'result should exist'
        assert.equal result.had?, true, 'result.had should exist'
        assert.equal result.had, 'error', 'result.had should be \'error\''
        assert.equal result.error?, true, 'result.error should exist'
        assert.equal result.error, 'testing'
        assert.equal result.type?, true, 'result.type should exist'
        assert.equal result.type, 'test',
        assert.deepEqual result, thisError
