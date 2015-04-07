
# TODO: review all this for sanity...

# add verification functions like checking for nulls in an array?
# arrayHasNull ?

module.exports = had = (name) ->

  return {
    id: name
    content: {}

    # return the info we have as an object. don't care if it's success/error
    results: (options) ->
      result = this.content    # ref current content

      if options?.noReturn
        delete options.noReturn
      else
        this.content = id:name # replace current content with new one
        # TODO: push current here instead of in others?

      result[key] = value for own key,value of options

      # ensure this doesn't exist
      delete result.noReturn

      return result       # return ref'd content as result

    # return a 'success' object.
    # include info we have already, if any
    # include info in options, if any
    # expects to return the object unless overriden in options
    success: (options) ->

      # TODO: move pushCurrent check to results
      #       do results second
      #       ensure content.success is set last

      # ensure it's seen as a 'success' (no error property)
      # if there's an error property, push that down a level
      if this.content?.error?
        this._pushCurrent()

      this.content.success = true

      result = this.results options # get current result (and replace it)

      return result

    # return an 'error' object.
    # include info we have already, if any
    # include info in options, if any
    # expects to return the object unless overriden in options
    error: (options) ->

      # TODO: move pushCurrent check to results
      #       do results second
      #       ensure content.error is set last

      # if there's already an error, push that down a level
      if this.content?.error?
        this._pushCurrent()

      this.content.error = options?.error ? 'error'

      result = this.results options

      return result

    isSuccess: (thing) ->
      if thing?.id?
        if thing?.success? then return true

        if thing?.error? then return false
      else
        return thing? and thing

    isNullParam: (paramName, param, options={}) ->
      if not param?
        options.noReturn = true
        options.error ?= 'null'
        options.type  ?= 'param'
        options.name  ?= paramName
        this.error options
        return true

      return false

    _pushCurrent: ->
      result = this.content  # ref current content, what we're pushing down
      this.content = id:name # create new current content with id/name
      if not result?.history? # if no history yet
        this.content.history = [result]
      else # there is history in result
        this.content.history = result.history # move it to current
        delete result.history            # delete it in result
        this.content.history.push result      # add result to current
  }
