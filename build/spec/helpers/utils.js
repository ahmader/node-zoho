(function() {
  (function(jasmine) {
    return root.mockCb = function(Model, method, err, result) {
      if (typeof Model[method] !== "function") {
        throw new Error("mockModelCb: the " + Model + "." + method + " given is not a function.");
      }
      return spyOn(Model, method).andCallFake(function() {
        var cb;
        cb = arguments[arguments.length - 1];
        if (typeof cb !== "function") {
          throw new Error("mockModelCb: the cb called is not a function.");
        }
        return setImmediate(cb, err, result);
      });
    };
  })(jasmine);

}).call(this);
