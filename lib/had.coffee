
module.exports = (hadOptions) ->

  hadId = hadOptions?.id ? 'unknown had'

  return had =
    id: hadId
    current: had:hadId
    history: []

    pushCurrent: () ->
      this.content.push this.current
      return this.current = had:hadId

    popCurrent: () ->
      result = this.current
      result.history = this.history
      this.current = had:hadId
      this.history = []
      return result

    isNullParam: (paramName, param, options) ->
      if not param?
        unless options?
          options =
            noReturn: true
            error: null
            type: 'param'
            name: paramName
        else
          options.noReturn ?= true
          options.error ?= 'null'
          options.type  ?= 'param'
          options.name  ?= paramName
        return this.error options

      return false


    isSuccess: (thing) ->
      if thing?.had?
        if thing?.success? then return true

        if thing?.error? then return false
      else
        return thing? and thing


    results: (options) ->

      result = this.current

      if result?.error? or result?.success?
        result = this.pushCurrent()

      # if exists, store value in this scope, then delete from options
      if options?.noReturn?
        noReturn = options.noReturn
        delete options.noReturn
      else
        noReturn = false

      unless noReturn
        result = this.popCurrent()

      result[key] = value for own key,value of options

      return if noReturn? and noReturn then true else result

    success: (options={}) ->
      options.success ?= true
      delete options.error if options?.error?

      result = this.results options

      return result

    error: (options={}) ->
      options.error ?= 'error'
      options.type  ?= 'unspecified'
      delete options.success if options?.success?
      result = this.results options

      return result
