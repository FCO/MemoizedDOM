unit module MemoizedDOM::Subs;

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


