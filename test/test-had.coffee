assert = require 'assert'
Had = require '../index'

describe 'test had\'s functions', ->

  describe 'test isSuccess', ->
    #before ->
    beforeEach 'create new had(\'isSuccess\')', ->
      this.had = Had 'isSuccess'

    describe 'isSuccess of true', ->

      it 'should return true', ->

        result = this.had.isSuccess true
        assert.equal result, true

    describe 'isSuccess of false', ->

      it 'should return false', ->

        result = this.had.isSuccess false
        assert.equal result, false

    describe 'isSuccess of a had success result', ->

      it 'should return true', ->

        successResult = had:'sample name', success:true
        result = this.had.isSuccess successResult
        assert.equal result?, true, 'result should exist'
        assert.equal result, true

    describe 'isSuccess of a had error result', ->

      it 'should return false', ->

        errorResult = had:'sample name', error:'sample error'
        result = this.had.isSuccess errorResult
        assert.equal result?, true, 'result should exist'
        assert.equal result, false

  describe 'test isNullParam', ->

    beforeEach 'create new had(\'isNullParam\')', ->
      this.had = Had 'isNullParam'

    describe 'with undefined and noReturn', ->

      it 'should fill error content and return true', ->

        result = this.had.isNullParam 'test', undefined, noReturn:true
        assert.equal result?, true, 'result should exist'
        assert.equal result, true
        assert.equal this.had.current.had, 'isNullParam'
        assert.equal this.had.current.error, 'null'
        assert.equal this.had.current.type,  'param'
        assert.equal this.had.current.name,  'test'

    describe 'with null and noReturn', ->

      it 'should fill error content and return true', ->

        result = this.had.isNullParam 'test', null, noReturn:true
        assert.equal result?, true, 'result should exist'
        assert.equal result, true
        assert.equal this.had.current.had, 'isNullParam'
        assert.equal this.had.current.error, 'null'
        assert.equal this.had.current.type,  'param'
        assert.equal this.had.current.name,  'test'

    describe 'with undefined', ->

      it 'should fill error content and return it', ->

        errorResult =
          had: 'isNullParam'
          error: 'null'
          type: 'param'
          name: 'test'
          history: []

        result = this.had.isNullParam 'test', undefined, noReturn:false
        assert.equal result?, true, 'result should exist'
        assert.deepEqual result, errorResult
        assert.equal this.had.history.length, 0
        assert.deepEqual this.had.current, had:'isNullParam'

    describe 'with null', ->

      it 'should fill error content and return it', ->

        errorResult =
          had: 'isNullParam'
          error: 'null'
          type: 'param'
          name: 'test'
          history: []

        result = this.had.isNullParam 'test', null, noReturn:false
        assert.equal result?, true, 'result should exist'
        assert.deepEqual result, errorResult
        assert.equal this.had.history.length, 0
        assert.deepEqual this.had.current, had:'isNullParam'

    describe 'with empty string', ->

      it 'should return false', ->

        result = this.had.isNullParam 'test', ''
        assert.equal result, false

    describe 'with non-empty string', ->

      it 'should return false', ->

        result = this.had.isNullParam 'test', 'string'
        assert.equal result, false

    describe 'with 0', ->

      it 'should return false', ->

        result = this.had.isNullParam 'test', 0
        assert.equal result, false

    describe 'with 1', ->

      it 'should return false', ->

        result = this.had.isNullParam 'test', 1
        assert.equal result, false

    describe 'with -1', ->

      it 'should return false', ->

        result = this.had.isNullParam 'test', -1
        assert.equal result, false

    describe 'with empty array', ->

      it 'should return false', ->

        result = this.had.isNullParam 'test', []
        assert.equal result, false

    describe 'with non-empty array', ->

      it 'should return false', ->

        result = this.had.isNullParam 'test', [ 'something' ]
        assert.equal result, false

    describe 'with empty object', ->

      it 'should return false', ->

        result = this.had.isNullParam 'test', {}
        assert.equal result, false

    describe 'with non-empty object', ->

      it 'should return false', ->

        result = this.had.isNullParam 'test', { some: 'thing' }
        assert.equal result, false

    describe 'with Date', ->

      it 'should return false', ->

        result = this.had.isNullParam 'test', new Date()
        assert.equal result, false

    describe 'with Function', ->

      it 'should return false', ->

        result = this.had.isNullParam 'test', ->
        assert.equal result, false

  describe 'test success', ->

    beforeEach 'create new had(\'success\')', ->
      this.had = Had 'success'

    describe 'with no options', ->

      it 'should return success result', ->

        result = this.had.success()
        assert.equal result?, true, 'result should exist'
        assert.equal result.success, true, 'result.success should be true'

    describe 'with one option', ->

      it 'should return success result with extra option', ->

        result = this.had.success test:'option'
        assert.equal result?, true, 'result should exist'
        assert.equal result.success, true, 'result.success should be true'
        assert.equal result.test?, true, 'result.test should exist'
        assert.equal result.test, 'option'

    describe 'with \'no return\' true', ->

      it 'returns true, *not* the success result', ->

        result = this.had.success noReturn:true
        assert.equal result?, true, 'result should exist'
        assert.equal result, true, 'result.success should be true'

  describe 'test error', ->

    beforeEach 'create new had(\'error\')', ->
      this.had = Had 'error'

    describe 'with no options', ->

      it 'should return error result', ->

        result = this.had.error()
        assert.equal result?, true, 'result should exist'
        assert.equal result.error?, true, 'result.error should exist'
        assert.equal result.error, 'error'

    describe 'with \'error\' option', ->

      it 'should return error result with error option', ->

        result = this.had.error error:'test'
        assert.equal result?, true, 'result should exist'
        assert.equal result.error?, true, 'result.error should exist'
        assert.equal result.error, 'test'
