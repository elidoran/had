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

        successResult = id:'sample name', success:true
        result = this.had.isSuccess successResult
        assert.equal result, true

    describe 'isSuccess of a had error result', ->

      it 'should return false', ->

        errorResult = id:'sample name', error:'sample error'
        result = this.had.isSuccess errorResult
        assert.equal result, false

  describe 'test isNullParam', ->

    beforeEach 'create new had(\'isNullParam\')', ->
      this.had = Had 'isNullParam'

    describe 'with undefined', ->

      it 'should fill error content and return true', ->

        result = this.had.isNullParam 'test', undefined
        assert.equal result, true
        assert.equal this.had.content.error, 'null'
        assert.equal this.had.content.type,  'param'
        assert.equal this.had.content.name,  'test'

    describe 'with null', ->

      it 'should fill error content and return true', ->

        result = this.had.isNullParam 'test', null
        assert.equal result, true
        assert.equal this.had.content.error, 'null'
        assert.equal this.had.content.type,  'param'
        assert.equal this.had.content.name,  'test'

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
