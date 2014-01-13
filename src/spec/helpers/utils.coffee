((jasmine) ->
  root.mockCb = (Model, method, err, result) ->
    if typeof Model[method] != "function"
      throw new Error("mockModelCb: the #{Model}.#{method} given is not a function.")

    spyOn(Model, method).andCallFake( ->
      cb = arguments[arguments.length-1]

      if typeof cb != "function"
        throw new Error("mockModelCb: the cb called is not a function.")

      setImmediate(cb, err, result)
    )

) jasmine
