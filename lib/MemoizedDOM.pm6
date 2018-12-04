my $document;
EVAL :lang<JavaScript>, 'HTMLElement.prototype.defined = function() { return true }';

sub h1(*@inner, *%pars) is export {
    $*parent.element("h1", @inner, |%pars)
}

sub p(*@inner, *%pars) is export {
    $*parent.element("p", @inner, |%pars)
}

sub ul(*@inner, *%pars) is export {
    $*parent.element("ul", @inner, |%pars)
}

sub li(*@inner, *%pars) is export {
    $*parent.element("li", @inner, |%pars)
}

sub form(*@inner, *%pars) is export {
    $*parent.element("form", @inner, |%pars)
}

sub input(*@inner, *%pars) is export {
    $*parent.element("input", @inner, |%pars)
}

role Tag { ... }

class Element {
    has $.document = $document //= EVAL :lang<JavaScript>, 'return document';
    has @.cache;
    has Tag $.owner is required;
    has $.tag;
    has $.dom-element = $!document.createElement($!tag);

    method TWEAK(|) {
        say "creating DOM element: { $!tag // "???" }";
    }

    multi method add-event-listener(Str $event, &handler) {
        $!dom-element.addEventListener: $event, &handler
    }

    multi method add-event-listener(Str $event, Str $handler) {
        nextwith $event, $!owner.^lookup($handler).assuming: $!owner
    }

    method class-name is rw {
        $!dom-element<class>
    }

    method input-value($val) {
        $!dom-element<value> = $val
    }

    method set-type(Str $type) {
        $!dom-element<type> = $type
    }

    method style(*%styles) {
        for %styles.kv -> $name, $value {
            $!dom-element<style>{$name} = $value
        }
    }

    method set-content(*@content) {
        while $!dom-element<firstChild> {
            $!dom-element.removeChild: $!dom-element<firstChild>;
        }

        $!dom-element.appendChild: $_
        for @content.map({ .?get-tag-data // $_ }).map({ .?dom-element // $!document.createTextNode: .Str })
    }

    method checked(Bool $checked) {
        $!dom-element<checked> = $checked ?? "checked" !! ""
    }
}

role Tag does Callable {
    has         $.document;
    has         @!cache;
    has Element $.root;

    method CALL-ME(|c) {
        if @*cache.defined and $*counter.defined and @*cache[$*counter++]:exists {
            my $cached = @*cache[$*counter-1];
            for c.hash.kv -> $attr, $value {
                try $cached."$attr"() = $value
            }
            return $cached
        }

        say "creating a new Tag";
        my $tag = ::?CLASS.new: |c;
        @*cache.push: $tag with @*cache;
        $tag
    }

    method mount-on($root) {
        $!root = Element.new: :dom-element($root), :owner(self), |(:$!document with $!document);
        self.call-render
    }

    method create-element(Str $tag) {
        Element.new: :$tag, :owner(self), |(:$!document with $!document)
    }

    multi method element(
        $tag,
        $inner? is copy,
        :$class is copy,
        :$style is copy,
        :%event,
        :$type,
        :$value is copy,
        :$checked is copy
    ) {
        my &inner;
        my @inner;
        my @dyn-inner;
        my &set-value;
        my &class;
        my &style;
        my @styles;
        my @callable;
        my &checked;

        given $inner {
            when Callable {
                &inner = $inner;
                $inner = Nil;
            }
            when Positional {
                @inner = @$inner;
            }
            default {
                @inner = $inner
            }
        }

        if @inner.any ~~ Callable {
            @dyn-inner = @inner;
            @inner = ()
        }

        if $value ~~ Callable {
            &set-value = $value;
            $value = Nil
        }

        if $class ~~ Callable {
            &class = $class;
            $class = Nil;
        }
        with $style {
            when Callable {
                &style = $style;
                $style = Nil;
            }
            when Associative {
                (.value ~~ Callable ?? @callable !! @styles).push: $_ for .pairs
            }
        }

        if $checked ~~ Callable {
            &checked = $checked;
            $checked = Nil
        }

        my $el;

        if @*cache[$*counter++]:exists {
            $el = @*cache[$*counter - 1]
        } else {
            given $el = self.create-element: $tag {
                $el.class-name = $_                  with $class;
                $el.set-content: @inner              if @inner;
                $el.input-value: $_                  with $value;
                $el.set-type: $_                     with $type;
                $el.style: |$_                       for @styles;
                $el.add-event-listener: .key, .value for %event;
                $el.checked: $_                      with $checked;
            }
            @*cache.push: $el;
        }

        {
            my @*cache := $el.cache;
            my $*counter = 0;

            $el.set-content: .() with &inner;
            $el.set-content: @dyn-inner.map: { $_ ~~ Callable ?? .() !! $_ } if @dyn-inner;
            with &class {
                $el.class-name = $_ with .() 
            }

            $el.input-value: .() with &set-value;

            $el.style: |.() with &style;
            $el.style: |$_ for @callable.map: { .key => .value.() };

            $el.checked: .() with &checked;
        }
        $el
    }

    method get-tag-data {
        my $*counter   = 0;
        my @*cache := @!cache;
        my $*parent = self;
        self.render;
    }

    method call-render {
        $!root.set-content: self.get-tag-data
    }

    method render { ... }
}
