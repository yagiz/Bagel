!function($){

    'use strict';

    $.fn.jsonview = function(json, options) {
        return this.each( function() {
            var self = $(this);
            if (typeof json == 'string') {
                    self.data('json', json);
            }
            else if(typeof json == 'object') {
                    self.data('json', JSON.stringify(json))
            }
            else {
                    self.data('json', '');
            }
            new JsonViewer(self, options);
        });
    };

    function JsonViewer(self, options) {
        var json = $.parseJSON(self.data('json'));
        options = $.extend({}, this.defaults, options);
        var expanderClasses = getExpanderClasses(options.expanded);
        self.html('<ul class="json-container"></ul>');
        self.find('.json-container').append(json2html([json], expanderClasses));
    }

    function getExpanderClasses(expanded) {
        if(!expanded) return 'expanded collapsed hidden';
        return 'expanded';
    }

    function json2html(json, expanderClasses) {
        var html = '';
        for (var key in json) {
            if (!json.hasOwnProperty(key)) {
                continue;
            }

            var value = json[key],
                type = typeof json[key];

            html = html + createElement(key, value, type, expanderClasses);
        }
        return html;
    }

    function encode(value) {
        return $('<div/>').text(value).html();
    }

    function createElement(key, value, type, expanderClasses) {
        var klass = 'object',
            open = '{',
            close = '}';

        if ($.isArray(value)) {
            klass = 'array';
            open = '[';
            close = ']';
        }

        if (value === null) {
            return '<li><span class="key">"' + encode(key) + '": </span><span class="null">null</span></li>';
        }

        switch(type){
            case 'object':
                var object = '<li><span class="'+ expanderClasses +'"></span><span class="key">"' + encode(key) + '": </span> <span class="open">' + open + '</span> <ul class="' + klass + '">';
                object = object + json2html(value, expanderClasses);
                return object + '</ul><span class="close">' + close + '</span></li>';
                break;
            case 'number':
            case 'boolean':
                return '<li><span class="key">"' + encode(key) + '": </span><span class="'+ type + '">' + encode(value) + '</span></li>';
            default:
                return '<li><span class="key">"' + encode(key) + '": </span><span class="'+ type + '">"' + encode(value) + '"</span></li>';
                break;
        }
    }

    $(document).on('click', '.json-container .expanded', function(event) {
        event.preventDefault();
        event.stopPropagation();
        var $self = $(this);
        $self.parent().find('>ul').slideUp(100, function() {
            $self.addClass('collapsed');
        });
    });

    $(document).on('click', '.json-container .expanded.collapsed', function(event) {
        event.preventDefault();
        event.stopPropagation();
        var $self = $(this);
        $self.removeClass('collapsed').parent().find('>ul').slideDown(100, function() {
            $self.removeClass('collapsed').removeClass('hidden');
        });
    });

    JsonViewer.prototype.defaults = {
        expanded: true
    };

}(window.jQuery);