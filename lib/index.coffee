# TODO: support array checks
class Had

  constructor: (options) ->

    @id = options?.id ? 'unknown'


  nullArg: (argName, arg) ->

    unless arg?
      @addError message:'null', type:'arg', name:argName
      return true

    return false


  nullProp: (propName, object) ->

    unless object?
      @addError message:'null', type:'prop', name:propName, object:true
      return true

    unless object?[propName]?
      @addError message:'null', type:'prop', name:propName
      return true

    return false


  isSuccess: (thing) ->

    # if it's a had object, check for `error`
    if thing?.had? then not thing.error?

    # if it exists and is truthy then return true
    else if thing? and thing then true else false


  results: (options) -> # no use for `options` yet

    # if there's some results in there to use
    if @array?.length > 0

      # get the most recent one
      result = @array.pop()

      # set previous to the array (if it has more)
      # NOTE: adding a property to the object causes slo-mo mode.
      result.previous = if @array.length > 0 then @array else null

    # default empty result
    else result = had:@id

    @array = null

    # use options as an override
    result[key] = value for own key, value of options

    return result


  _store: (object) ->
    # NOTE: pushing newer results on the end of the array
    if @array? then @array.push object
    else @array = [ object ]
    return


  addSuccess: (value) ->
    # conditionally set a `value` property when there's a value.
    @_store if value? then had:@id, value:value else had:@id

  # always set an `error` property cuz it marks it as an error
  addError: (value) -> @_store had: @id, error: value ? 'unknown'


  success: (first, second) ->

    if second? and first?.had? then @_store first

    value = second ? first

    # conditionally set a `success` property when there's a value.
    success =
      if value? then had:@id, value:value, previous: @array
      else had:@id, previous: @array

    @array = null

    return success


  error: (first, second) ->

    if second? and first?.had? then @_store first

    error =
      had: @id
      error: second ? first ? 'unknown'
      previous: @array

    @array = null

    return error


module.exports = (options) -> new Had options
module.exports.Had = Had
