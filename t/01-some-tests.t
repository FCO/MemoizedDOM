use Test;
use MemoizedDOM;
use lib <t/lib>;
use DomElementMock;

{
    class Bla does Tag {
        method render {
    	    h1
        }
    }

    my $m1 = DomElementMock.new;
    my $a = Bla(:document($m1));
    $a.mount-on: DomElementMock.new;
    $m1.verify-create-element:   1;
    $m1.verify-append-child:     0;
    $m1.verify-create-text-node: 0;

    $a.call-render;

    $m1.verify-create-element:   0;
    $m1.verify-append-child:     0;
    $m1.verify-create-text-node: 0;
}
{
    class Ble does Tag {
        method render {
    	    h1 "bla"
        }
    }

    my $m1 = DomElementMock.new;
    my $a = Ble(:document($m1));
    $a.mount-on: DomElementMock.new;
    $m1.verify-create-element:   1;
    $m1.verify-append-child:     0;
    $m1.verify-create-text-node: 1;

    $a.call-render;

    $m1.verify-create-element:   0;
    $m1.verify-append-child:     0;
    $m1.verify-create-text-node: 0;

}
{
    class Bli does Tag {
        method render {
            h1
                h1 "bla"
        }
    }

    my $m1 = DomElementMock.new;
    my $a = Bli(:document($m1));
    $a.mount-on: DomElementMock.new;
    $m1.verify-create-element:   2;
    $m1.verify-append-child:     1;
    $m1.verify-create-text-node: 1;

    $a.call-render;

    $m1.verify-create-element:   0;
    $m1.verify-append-child:     0;
    $m1.verify-create-text-node: 0;
}
{
    class Blo does Tag {
        method render {
            form(
                h1("bla"),
                h1("ble")
            ),
            input(:type<submit>)
        }
    }

    my $m1 = DomElementMock.new;
    my $a = Blo(:document($m1));
    $a.mount-on: DomElementMock.new;
    $m1.verify-create-element:   4;
    $m1.verify-append-child:     2;
    $m1.verify-create-text-node: 2;

    $a.call-render;

    $m1.verify-create-element:   0;
    $m1.verify-append-child:     0;
    $m1.verify-create-text-node: 0;
}

done-testing
