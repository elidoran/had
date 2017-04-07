assert = require 'assert'
Had = require '../lib'

describe 'test had\'s functions', ->

  describe 'test had id', ->

    it 'should have id in had', ->
      id = 'test-id'
      had = Had id:id
      assert.equal had.id, id, 'had should have its id'

  describe 'test isSuccess', ->

    describe 'isSuccess of null', ->

      it 'should return false', ->

        had = Had id:'isSuccess'
        result = had.isSuccess null
        assert.equal result, false


    describe 'isSuccess of undefined', ->

      it 'should return false', ->

        had = Had id:'isSuccess'
        result = had.isSuccess undefined
        assert.equal result, false


    describe 'isSuccess of empty object', ->

      it 'should return true', ->

        had = Had id:'isSuccess'
        result = had.isSuccess {}
        assert.equal result, true


    describe 'isSuccess of non-empty object', ->

      it 'should return true', ->

        had = Had id:'isSuccess'
        result = had.isSuccess some:'thing'
        assert.equal result, true


    describe 'isSuccess of object with had prop', ->

      it 'should return true', ->

        had = Had id:'isSuccess'
        result = had.isSuccess had:'test'
        assert.equal result, true


    describe 'isSuccess of empty array', ->

      it 'should return true', ->

        had = Had id:'isSuccess'
        result = had.isSuccess []
        assert.equal result, true


    describe 'isSuccess of non-empty array', ->

      it 'should return true', ->

        had = Had id:'isSuccess'
        result = had.isSuccess ['one']
        assert.equal result, true


    describe 'isSuccess of true', ->

      it 'should return true', ->

        had = Had id:'isSuccess'
        result = had.isSuccess true
        assert.equal result, true


    describe 'isSuccess of false', ->

      it 'should return false', ->

        had = Had id:'isSuccess'
        result = had.isSuccess false
        assert.equal result, false


    describe 'isSuccess of a had success result, single', ->

      it 'should return true', ->

        had = Had id:'isSuccess'
        successResult = had:'sample name', some:'test'
        result = had.isSuccess successResult
        assert.equal result, true


    describe 'isSuccess of a had success result, multiple', ->

      it 'should return true', ->

        successResult =
          had:'sample name'
          some:'test'
          previous: [ { had:'sample name', some:'test2' } ]

        had = Had id:'isSuccess'
        result = had.isSuccess successResult
        assert.equal result, true


    describe 'isSuccess of a had success+error result', ->

      it 'should return false', ->

        comboResult =
          had:'sample name'
          error: had:'sample name', message:'test', type:'test', some:'testy'
          previous: [ had:'sample name', success:true, some:'test' ]

        had = Had id:'isSuccess'
        result = had.isSuccess comboResult
        assert.equal result, false


    describe 'isSuccess of a had error result, single', ->

      it 'should return false', ->

        errorResult = had:'sample name', error:'sample error'

        had = Had id:'isSuccess'
        result = had.isSuccess errorResult
        assert.equal result, false


    describe 'isSuccess of a had error result, multiple', ->

      it 'should return false', ->

        errorResult =
          had:'sample name'
          error: had:'sample name', error:'test', some:'test'
          previous: [
            had:'sample name', error:'test', some:'test2'
          ]

        had = Had id:'isSuccess'
        result = had.isSuccess errorResult
        assert.equal result, false



  describe 'test nullArg', ->

    describe 'with undefined', ->

      it 'should fill error content and return true', ->

        error =
          had:'nullArg'
          error:
            message:'null'
            type:'arg'
            name:'test'
        had = Had id:'nullArg'
        result = had.nullArg 'test', undefined
        assert.equal result, true
        assert.deepEqual had.array[0], error



    describe 'with null', ->

      it 'should fill error content and return true', ->

        error =
          had:'nullArg'
          error:
            message:'null', type:'arg', name:'test'
        had = Had id:'nullArg'
        result = had.nullArg 'test', null
        assert.equal result, true
        assert.deepEqual had.array[0], error



    describe 'twice with undefined', ->

      it 'should fill error content and return true', ->

        first  =
          had:'nullArg'
          error:
            message:'null'
            type:'arg'
            name:'test1'

        second =
          had:'nullArg'
          error:
            message:'null'
            type:'arg'
            name:'test2'

        had = Had id:'nullArg'
        result1 = had.nullArg 'test1', undefined
        result2 = had.nullArg 'test2', undefined

        assert.equal result1, true
        assert.equal result2, true
        assert.deepEqual had.array.length, 2
        assert.deepEqual had.array[0], first
        assert.deepEqual had.array[1], second


    describe 'with empty string', ->

      it 'should return false', ->

        had = Had id:'nullArg'
        result = had.nullArg 'test', ''
        assert.equal result, false


    describe 'with non-empty string', ->

      it 'should return false', ->

        had = Had id:'nullArg'
        result = had.nullArg 'test', 'string'
        assert.equal result, false


    describe 'with 0', ->

      it 'should return false', ->

        had = Had id:'nullArg'
        result = had.nullArg 'test', 0
        assert.equal result, false


    describe 'with 1', ->

      it 'should return false', ->

        had = Had id:'nullArg'
        result = had.nullArg 'test', 1
        assert.equal result, false


    describe 'with -1', ->

      it 'should return false', ->

        had = Had id:'nullArg'
        result = had.nullArg 'test', -1
        assert.equal result, false


    describe 'with empty array', ->

      it 'should return false', ->

        had = Had id:'nullArg'
        result = had.nullArg 'test', []
        assert.equal result, false


    describe 'with non-empty array', ->

      it 'should return false', ->

        had = Had id:'nullArg'
        result = had.nullArg 'test', [ 'something' ]
        assert.equal result, false


    describe 'with empty object', ->

      it 'should return false', ->

        had = Had id:'nullArg'
        result = had.nullArg 'test', {}
        assert.equal result, false


    describe 'with non-empty object', ->

      it 'should return false', ->

        had = Had id:'nullArg'
        result = had.nullArg 'test', { some: 'thing' }
        assert.equal result, false


    describe 'with Date', ->

      it 'should return false', ->

        had = Had id:'nullArg'
        result = had.nullArg 'test', new Date()
        assert.equal result, false


    describe 'with Function', ->

      it 'should return false', ->

        had = Had id:'nullArg'
        result = had.nullArg 'test', ->
        assert.equal result, false



  describe 'test nullProp', ->


    describe 'with null object', ->

      it 'should fill error content and return true', ->

        error =
          had:'nullProp'
          error:
            message:'null'
            type:'prop'
            name:'test'
            object:true
        had = Had id:'nullProp'
        result = had.nullProp 'test', null
        assert.equal result, true
        assert.deepEqual had.array[0], error


    describe 'with undefined object', ->

      it 'should fill error content and return true', ->

        error =
          had:'nullProp'
          error:
            message:'null'
            type:'prop'
            name:'test'
            object:true
        had = Had id:'nullProp'
        result = had.nullProp 'test', undefined
        assert.equal result, true
        assert.deepEqual had.array[0], error


    describe 'without prop', ->

      it 'should fill error content and return true', ->

        error =
          had:'nullProp'
          error:
            message:'null'
            type:'prop'
            name:'test'
        had = Had id:'nullProp'
        result = had.nullProp 'test', {}
        assert.equal result, true
        assert.deepEqual had.array[0], error


    describe 'with null prop value', ->

      it 'should fill error content and return true', ->

        error =
          had:'nullProp'
          error:
            message:'null'
            type:'prop'
            name:'test'
        had = Had id:'nullProp'
        result = had.nullProp 'test', test:null
        assert.equal result, true
        assert.deepEqual had.array[0], error


    describe 'with undefined prop value', ->

      it 'should fill error content and return true', ->

        error =
          had:'nullProp'
          error:
            message:'null'
            type:'prop'
            name:'test'
        had = Had id:'nullProp'
        result = had.nullProp 'test', test:undefined
        assert.equal result?, true, 'result should exist'
        assert.equal result, true
        assert.deepEqual had.array[0], error


    describe 'with prop value', ->

      it 'should return false', ->

        had = Had id:'nullProp'
        result = had.nullProp 'test', test:'exists'
        assert.equal result, false



  describe 'test success', ->


    describe 'with no options', ->

      it 'should return success result', ->

        answer = had: 'success', previous:null
        had = Had id:'success'
        result = had.success()
        assert.deepEqual result, answer


    describe 'with one option', ->

      it 'should return success result with extra option', ->

        answer =
          had: 'success'
          value: test: 'option'
          previous: null
        had = Had id:'success'
        result = had.success test:'option'
        assert.deepEqual result, answer


    describe 'with an \'error\' property true', ->

      it 'returns the success result with an _error_ property', ->

        answer =
          had: 'success'
          value: error: 'test'
          previous: null

        had = Had id:'success'
        result = had.success error:'test'
        assert.deepEqual result, answer


    describe 'with previous error result to include', ->

      it 'should return both results', ->

        previousError =
          had: 'anotherHad'
          error:
            message:'previous issue'
            type:'something else'
            some:'thing'
          previous: null

        success =
          another:'thing'

        combinedResult =
          had: 'success'
          value: success
          previous: [ previousError ]

        had = Had id:'success'
        result = had.success previousError, success
        assert.deepEqual result, combinedResult


    describe 'with previous success result to include', ->

      it 'should return both successes', ->

        previousResult =
          had: 'anotherHad'
          value:
            some:'thing'
          previous: undefined

        # thisResult =
        #   had: 'success'
        #   value:
        #     something:'else'
        #   previous: undefined

        combinedResult =
          had: 'success'
          value:
            something:'else'
          previous: [ previousResult ]

        had = Had id:'success'
        result = had.success previousResult, something:'else'

        assert.equal result?, true, 'result should exist'
        assert.deepEqual result, combinedResult


    describe 'with previous true result to include', ->

      it 'should return the one success', ->

        thisResult =
          had: 'success'
          value:
            some:'thing'
          previous: null

        had = Had id:'success'
        result = had.success true, thisResult.value
        assert.deepEqual result, thisResult


    describe 'with previous false result to include', ->

      it 'should return the one success', ->

        thisResult =
          had: 'success'
          value:
            some:'thing'
          previous: null

        had = Had id:'success'
        result = had.success false, some:'thing'
        assert.deepEqual result, thisResult



  describe 'test error', ->


    describe 'with no options', ->


      it 'should return error result', ->

        answer =
          had:'error'
          error:'unknown'
          previous: null

        had = Had id:'error'
        result = had.error()
        assert.deepEqual result, answer


    describe 'with \'error\' option', ->

      it 'should return error result with error option', ->

        answer =
          had:'error'
          error: message:'test'
          previous: null

        had = Had id:'error'
        result = had.error message:'test'
        assert.deepEqual result, answer


    describe 'with \'type\' option', ->

      it 'should return error result with type option', ->

        answer =
          had:'error'
          error: type:'test'
          previous: null

        had = Had id:'error'
        result = had.error type:'test'
        assert.deepEqual result, answer


    describe 'with \'extra\' option', ->

      it 'should return error result with extra option', ->

        answer =
          had:'error'
          error: extra:'test'
          previous: null

        had = Had id:'error'
        result = had.error extra:'test'
        assert.deepEqual result, answer


    describe 'with \'success\' option', ->

      it 'should return error result with _success_ property', ->

        answer =
          had:'error'
          error: success:'test'
          previous: null

        had = Had id:'error'
        result = had.error success:'test'
        assert.deepEqual result, answer


    describe 'with previous error result to include', ->

      it 'should return both errors', ->

        previousError =
          had: 'anotherHad'
          error:
            message:'previous issue'
            type:'something else'
            some:'thing'
          previous: null

        thisError =
          message:'testing'
          type:'test'
          some:'thing'

        combinedError =
          had: 'error'
          error: thisError
          previous: [previousError]

        had = Had id:'error'
        result = had.error previousError, thisError
        assert.deepEqual result, combinedError


    describe 'with previous success result to include', ->

      it 'should return both errors', ->

        previousResult =
          had: 'anotherHad'
          value:
            some:'thing'
          previous: null

        thisError =
          message:'testing'
          type:'test'
          another:'thing'

        combinedResult =
          had: 'error'
          error: thisError
          previous: [previousResult]

        had = Had id:'error'
        result = had.error previousResult, thisError
        assert.deepEqual result, combinedResult


    describe 'with previous true result to include', ->

      it 'should return the one error', ->

        thisError =
          had: 'error'
          error:
            message:'testing'
            type:'test'
          previous: null

        had = Had id:'error'
        result = had.error true, message:'testing', type:'test'
        assert.deepEqual result, thisError


    describe 'with previous false result to include', ->

      it 'should return the one error', ->

        thisError =
          had: 'error'
          error:
            message:'testing'
            type:'test'
          previous: null

        had = Had id:'error'
        result = had.error false, message:'testing', type:'test'
        assert.deepEqual result, thisError



  describe 'test results', ->


    describe 'with no options', ->

      it 'should return basic result with only had ID', ->

        answer = had:'results'
        had = Had id:'results'
        result = had.results()
        assert.deepEqual result, answer


    describe 'with a single override value', ->

      it 'should return result with had+override', ->

        answer = had:'results', some:'thing'
        had = Had id:'results'
        result = had.results some:'thing'
        assert.deepEqual result, answer


    describe 'with error override values', ->

      it 'should return result with overridden values', ->

        answer =
          had:'results'
          error:'new'
          type:'values'

        had = Had id:'results'
        result = had.results error:'new', type:'values'
        assert.deepEqual result, answer

    describe 'with a result to use', ->

      it 'should return the result', ->

        answer =
          had:'results'
          error: some:'thing'
          previous: null

        had = Had id:'results'
        had.addError some:'thing'
        result = had.results()
        assert.deepEqual result, answer

    describe 'with two results to use', ->

      it 'should return the result', ->

        answer =
          had:'results'
          error: second:'thing'
          previous: [
            had:'results'
            error: first:'thing'
          ]

        had = Had id:'results'
        had.addError first:'thing'
        had.addError second:'thing'
        result = had.results()
        assert.deepEqual result, answer


  describe 'test addSuccess', ->

    it 'with a value', ->

      result = [
        {
          had:'addSuccess'
          value:
            some:'thing'
        }
      ]

      had = Had id:'addSuccess'
      had.addSuccess some:'thing'
      assert.deepEqual had.array, result

    it 'without a value', ->

      result = [ had:'addSuccess' ]
      had = Had id:'addSuccess'
      had.addSuccess()
      assert.deepEqual had.array, result
