// Generated by CoffeeScript 1.4.0
(function() {

  (function($) {
    var CHMap, NAMESPACE;
    NAMESPACE = 'chmap_objects';
    CHMap = (function() {

      function CHMap(element, options) {
        var callback, callbacks, type, _i, _len, _ref;
        this.element = element;
        this.options = $.extend({
          value: 0,
          autoload: false,
          extend_SVGElement: true,
          aspect_ratio: 0.62,
          callbacks: {
            click: [],
            mouseenter: [],
            mouseleave: [],
            element_loaded: []
          },
          toggleable_elements: function(element) {
            return [$(element).find("#cantons>path").get(), $(element).find("#canton_names text").get()];
          }
        }, options);
        this.callbacks = {
          click: $.Callbacks(),
          mouseenter: $.Callbacks(),
          mouseleave: $.Callbacks()
        };
        _ref = this.options.callbacks;
        for (type in _ref) {
          callbacks = _ref[type];
          if (!$.isArray(callbacks)) {
            callbacks = [callbacks];
          }
          for (_i = 0, _len = callbacks.length; _i < _len; _i++) {
            callback = callbacks[_i];
            this.callbacks[type].add(callback);
          }
        }
        if (this.options.extend_SVGElement === true) {
          this.extend_SVGElement();
        }
        if (this.options.autoload === true) {
          this.load();
        }
      }

      CHMap.prototype._initialize_aspect_ratio_enforcement = function() {
        var _this = this;
        this.enforce_aspect_ratio();
        return $(window).resize(function() {
          return _this.enforce_aspect_ratio();
        });
      };

      CHMap.prototype._initialize_callbacks = function() {
        var callback, element, type, _fn, _i, _len, _ref, _ref1, _results;
        _ref = this._toggleable_elements();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          element = _ref[_i];
          _ref1 = this.callbacks;
          _fn = function(type, callback) {
            return $(element).on(type, function() {
              return callback.fire(this);
            });
          };
          for (type in _ref1) {
            callback = _ref1[type];
            if (type === 'element_loaded') {
              continue;
            }
            if (callback.length === 0) {
              continue;
            }
            _fn(type, callback);
          }
          if (this.callbacks['element_loaded'] != null) {
            _results.push(this.callbacks['element_loaded'].fire(element));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      };

      CHMap.prototype._toggleable_elements = function() {
        var e, elements, te;
        te = this.options.toggleable_elements;
        if ($.isFunction(te)) {
          elements = te(this.element);
        }
        if ($.isArray(te)) {
          elements = te;
        }
        return (function() {
          var _i, _len, _ref, _results;
          _ref = [].concat.apply([], elements);
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            e = _ref[_i];
            if (e != null) {
              _results.push(e);
            }
          }
          return _results;
        })();
      };

      CHMap.prototype.extend_SVGElement = function() {
        if (SVGElement.hasClass !== 'function') {
          SVGElement.prototype.hasClass = function(className) {
            return new RegExp('(\\s|^)' + className + '(\\s|$)').test(this.getAttribute('class'));
          };
        }
        if (SVGElement.addClass !== 'function') {
          SVGElement.prototype.addClass = function(className) {
            if (!this.hasClass(className)) {
              return this.setAttribute('class', this.getAttribute('class') + ' ' + className);
            }
          };
        }
        if (SVGElement.removeClass !== 'function') {
          SVGElement.prototype.removeClass = function(className) {
            var c, removedClass;
            c = this.getAttribute('class');
            c || (c = " ");
            removedClass = c.replace(new RegExp('(\\s|^)' + className + '(\\s|$)', 'g'), '$2');
            if (this.hasClass(className)) {
              return this.setAttribute('class', removedClass);
            }
          };
        }
        if (SVGElement.toggleClass !== 'function') {
          return SVGElement.prototype.toggleClass = function(className) {
            if (this.hasClass(className)) {
              return this.removeClass(className);
            } else {
              return this.addClass(className);
            }
          };
        }
      };

      CHMap.prototype.enforce_aspect_ratio = function() {
        return $(this.element).css('height', $(this.element).width() * this.options.aspect_ratio);
      };

      CHMap.prototype.load = function() {
        var _this = this;
        $(this.element).addClass('loading');
        $(this.element).load('images/ch_map.svg', function() {
          $(_this.element).addClass('loaded');
          _this._initialize_aspect_ratio_enforcement();
          return _this._initialize_callbacks();
        });
        return $(this.element).removeClass('loading');
      };

      CHMap.prototype.loaded = function() {
        return $(this.element).hasClass('loaded');
      };

      CHMap.prototype.loading = function() {
        return $(this.element).hasClass('loading');
      };

      return CHMap;

    })();
    return $.fn.chmap = function(param) {
      var methods;
      window[NAMESPACE] || (window[NAMESPACE] = {});
      methods = {
        initialize: function() {
          window[NAMESPACE][this.selector] = new CHMap(this, param);
          return this;
        },
        loaded: function() {
          return window[NAMESPACE][this.selector].loaded();
        },
        loading: function() {
          return window[NAMESPACE][this.selector].loading();
        },
        load: function() {
          window[NAMESPACE][this.selector].load();
          return window[NAMESPACE][this.selector].loaded();
        },
        enforce_aspect_ratio: function() {
          window[NAMESPACE][this.selector].enforce_aspect_ratio();
          return window[NAMESPACE][this.selector]['options']['aspect_ratio'];
        }
      };
      if (methods[param]) {
        return methods[param].apply(this, Array.prototype.slice.call(arguments, 1));
      } else if (typeof param === "object" || !param) {
        return methods.initialize.apply(this, arguments);
      } else {
        return $.error("Method " + param + " does not exist on chmap");
      }
    };
  })(jQuery);

}).call(this);
