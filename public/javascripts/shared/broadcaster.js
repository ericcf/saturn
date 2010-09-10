var Broadcaster = function(element) {
  var obj = this;

  this.addListener = function(eventName, callback) {
    element.bind(eventName, callback);
    return obj;
  };

  this.removeListener = function(eventName, callback) {
    element.unbind(eventName, callback);
    return obj;
  };

  this.removeListeners = function(eventName) {
    element.unbind(eventName);
    element.trigger("onRemoveListeners-" + eventName);
    return obj;
  };

  this.broadcast = function(eventName, args) {
    element.trigger(eventName, args);
    return obj;
  };
};
