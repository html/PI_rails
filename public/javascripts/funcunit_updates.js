
var funcs = []
namedFunction = function(name, func){
  funcs[name] = func;
};

callNamedFunction = function(name, callback){
  console && console.log(name);
  if(typeof funcs[name] == 'function'){
    return funcs[name](callback);
  }else{
    console && console.log("No named function " + name);
    throw "No named function " + name;
  }
};

(function(window){
  QUnit.namedTest = function(testName, expected, callback, async){
    namedFunction(testName, expected);
    QUnit.test.apply(this, arguments);
  }
})(this);
