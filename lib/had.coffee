
module.exports = (hadOptions) ->

  hadId = hadOptions?.id ? 'unknown had'

  had =
    id: hadId

    nullArg: (argName, arg) ->
      unless arg?
        had.addError error:'null', type:'arg', name:argName
        return true

      return false

    isSuccess: (thing) ->
      if thing?.had?
        if thing?.error? then return false

        if thing?.success? then return true

        return true #? an empty result?
      else
        if thing? and thing then true else false

    results: (options) ->
      result = had.current ? {had:had.id}
      had.current = null

      # treat options as overrides for current values
      result[key] = value for own key,value of options

      return result

    success: (options={}, extra) ->

      if extra?
        if options?.had
          if options?.error then had.addError options
          else if options?.success then had.addSuccess options
        options = extra
        extra = undefined

      options?.success ?= true
      options?.had     ?= hadId

      if options?.error?
        options._error_ = options.error
        delete options.error

      unless had?.current?
        result = options

      else

        if had.current?.successes
          result = had.current
          result.successes.push options

        else if had.current?.errors?
          result = had.current
          result.success = true
          result.successes = [options]

        else if had.current?.success
          result =
            had    : had.id
            success: true
            successes: [had.current, options]

        else if had.current?.error?
          result =
            had    : had.id
            success: true
            error  : 'multiple'
            successes: [options]
            errors   : [had.current]

        had.current = null

      return result

    error: (options={}, extra) ->

      if extra?
        if options?.had
          if options?.error then had.addError options
          else if options?.success then had.addSuccess options
        options = extra
        extra = undefined

      options?.error ?= 'error'
      options?.type  ?= 'unknown'
      options?.had   ?= hadId

      if options?.success?
        options._success_ = options.success
        delete options.success

      unless had?.current?
        result = options

      else

        if had.current?.errors?
          result = had.current
          result.errors.push options

        else if had.current?.successes
          result = had.current
          result.error = 'multiple'
          result.errors = [options]

        else if had.current?.error?
          result =
            had    : had.id
            error  : 'multiple'
            errors   : [had.current, options]

        else if had.current?.success
          result =
            had    : had.id
            success: true
            error  : 'multiple'
            successes: [had.current]
            errors   : [options]

        had.current = null

      return result

    addSuccess: (options) ->
      had.current = had.success options
      return true

    addError: (options) ->
      had.current = had.error options
      return true
