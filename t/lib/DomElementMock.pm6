use Test;

class DomElementMock does Associative {
has Int $.create-text-node = 0;
has Int $.create-element   = 0;
has Int $.append-child     = 0;

has Capture @.captures-create-text-node;
has Capture @.captures-create-element;
has Capture @.captures-append-child;

method AT-KEY(|) is rw { $ = Any }

method createTextNode(|c) {
    $!create-text-node++;
    @!captures-create-text-node.push: c;
    note "createTextNode({ c.array.join: ", " })" if $*DOMELEMENTMOCK;
}
method createElement(|c) {
    $!create-element++;
    @!captures-create-element.push: c;
    note "createElement({ c.array.join: ", " })" if $*DOMELEMENTMOCK;
    self
}
method appendChild(|c) {
    $!append-child++;
    @!captures-append-child.push: c;
    note "appendChild({ c.array.join: ", " })" if $*DOMELEMENTMOCK;
}

method verify-create-element(Int $times = 1, :@signature) {
    subtest {
        is $!create-element, $times, "expected to create-element be called $times times";
        @signature Z[&is] @!captures-create-element
    }
    self.clear-create-element
}

method verify-append-child(Int $times = 1, :@signature) {
    subtest {
        is $!append-child, $times, "expected to append-child be called $times times";
        @signature Z[&is] @!captures-append-child
    }
    self.clear-append-child
}

method verify-create-text-node(Int $times = 1, :@signature) {
    subtest {
        is $!create-text-node, $times, "expected to create-text-node be called $times times";
        @signature Z[&is] @!captures-create-text-node
    }
    self.clear-create-text-node
}

method clear-create-element {
    $!create-element = 0;
    @!captures-create-element = ()
}

method clear-append-child {
    $!append-child = 0;
    @!captures-append-child = ()
}

method clear-create-text-node {
    $!create-text-node = 0;
    @!captures-create-text-node = ()
}
}
