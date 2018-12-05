use Test;
use MemoizedDOM;

class Mock does Associative {
    has Int $!create-text-node = 0;
    has Int $!create-element   = 0;
    has Int $!append-child     = 0;

    method AT-KEY(|) is rw { $ = Any }

    method createTextNode($text) {
        $!create-text-node++;
        note "createTextNode($text)";
    }
    method createElement($tag) {
        $!create-element++;
        note "createElement($tag)";
        self
    }
    method appendChild($node) {
        note "appendChild($node)";
        $!append-child++;
    }

    method verify-create-element(Int $times = 1) {
        is $!create-element, $times, "expected to create-element be called $times times";
        $!create-element = 0
    }

    method verify-append-child(Int $times = 1) {
        is $!append-child, $times, "expected to append-child be called $times times";
        $!append-child = 0
    }

    method verify-create-text-node(Int $times = 1) {
        is $!create-text-node, $times, "expected to create-text-node be called $times times";
        $!create-text-node = 0
    }
}
class Bla does Tag {
    has Str $.a is binded is rw = "bla";

    method render {
        h1 { $!a }
    }
}

my $a = Bla(:document(Mock.new));
$a.mount-on: Mock.new;
note "------------------------";
$a.a = "ble";

done-testing
