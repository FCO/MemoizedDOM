unit module MemoizedDOM::Traits;

multi trait_mod:<is>(Attribute $attr, Bool :$binded where * === True) is export {
    $attr.package.^add_attribute: my $clone = Attribute.new: :type($attr.type), :package($attr.package), :name($attr.name ~ "-value");
    my &tweak := method (\SELF: |) {
        $clone.set_value: SELF, $_ ~~ Callable ?? .() !! $_ with $attr.?build;
        use nqp;
        nqp::bindattr(nqp::decont(SELF), $attr.package, $attr.name, Proxy.new:
            FETCH => method () {
                $clone.get_value: SELF
            },
            STORE => method ($value) {
                $clone.set_value: SELF, $value;
                SELF.call-render
            }
        );
    }

    if $attr.package.^lookup("TWEAK") -> &t {
        &t.wrap: -> | { tweak; nextsame }
    } else {
        $attr.package.^add_method: "TWEAK", &tweak
    }
}
