use MemoizedDOM::Element;

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

        #say "creating a new Tag";
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

