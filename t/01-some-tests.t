use Test;
use MemoizedDOM;

class Mock {
    has Int $!create-text-node = 0;
    has Int $!create-element   = 0;
    has Int $!append-child     = 0;

    method createTextNode($text) {
        $!create-text-node++;
    }
    method createElement($tag) {
        $!create-element++;
        self
    }
    method appendChild($node) {
        $!append-child++;
    }

    method verify-create-element(Int $times) {
        is $!create-element, $times, "expected to create-element be called $times times"
    }

    method verify-append-child(Int $times) {
        is $!append-child, $times, "expected to append-child be called $times times"
    }

    method verify-create-text-node(Int $times) {
        is $!create-text-node, $times, "expected to create-text-node be called $times times"
    }
}


{
    class Bla does Tag {
        method render {
    	    h1
        }
    }

    my $m1 = Mock.new;
    my $a = Bla(:document($m1)).mount-on: Mock.new;
    $m1.verify-create-element:   1;
    $m1.verify-append-child:     0;
    $m1.verify-create-text-node: 0;

}
{
    class Ble does Tag {
        method render {
    	    h1 "bla"
        }
    }

    my $m1 = Mock.new;
    my $a = Ble(:document($m1)).mount-on: Mock.new;
    $m1.verify-create-element:   1;
    $m1.verify-append-child:     1;
    $m1.verify-create-text-node: 1;

}
{
    class Bli does Tag {
        method render {
            h1
                h1 "bla"
        }
    }

    my $m1 = Mock.new;
    my $a = Bli(:document($m1)).mount-on: Mock.new;
    $m1.verify-create-element:   2;
    $m1.verify-append-child:     2;
    $m1.verify-create-text-node: 1;
}

done-testing
