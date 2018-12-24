use Test;
use MemoizedDOM;
use lib <t/lib>;
use DomElementMock;

class Bla does Tag {
    has Str $.a is binded is rw = "bla";

    method render {
        h1 { $!a }
    }
}

my $a = Bla(:document(my $m1 = DomElementMock.new));
$a.mount-on: DomElementMock.new;
$a.a = "ble";

$m1.verify-create-element:   1;
$m1.verify-append-child:     0;
$m1.verify-create-text-node: 2, :signature[\("bla"), \("ble")];

$a.a = "bli";

$m1.verify-create-element:   0;
$m1.verify-append-child:     0;
$m1.verify-create-text-node: 1, :signature[\("bli")];

done-testing
