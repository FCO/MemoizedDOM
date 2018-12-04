my $document;

class Element {
    has $.document = $document //= EVAL :lang<JavaScript>, 'return document';
    has @.cache;
    has $.owner is required;
    has $.tag;
    has $.dom-element = $!document.createElement($!tag);

    #method TWEAK(|) {
    #    say "creating DOM element: { $!tag // "???" }";
    #}

    multi method add-event-listener(Str $event, &handler) {
        $!dom-element.addEventListener: $event, &handler;
    }

    multi method add-event-listener(Str $event, Str $handler) {
        nextwith $event, $!owner.^lookup($handler).assuming: $!owner
    }

    method class-name is rw {
        $!dom-element<class>;
    }

    method input-value($val) {
        $!dom-element<value> = $val;
    }

    method set-type(Str $type) {
        $!dom-element<type> = $type;
    }

    method style(*%styles) {
        for %styles.kv -> $name, $value {
            $!dom-element<style>{$name} = $value;
        }
    }

    method set-content(*@content) {
        while $!dom-element<firstChild> {
            $!dom-element.removeChild: $!dom-element<firstChild>;
        }

        $!dom-element.appendChild: $_
            for @content.map({ .?get-tag-data // $_ }).map({ .?dom-element // $!document.createTextNode: .Str });
    }

    method checked(Bool $checked) {
        $!dom-element<checked> = $checked ?? "checked" !! "";
    }
}


