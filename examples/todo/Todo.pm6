use MemoizedDOM;

class Todo does Tag {
    has Str  $.title;
    has Bool $.done is rw;
    has      &.toggle is required;

    method render {
        li(
            :style{
                $!done
                ?? { :textDecoration<line-through>, :opacity<0.3> }
                !! { :textDecoration<none>        , :opacity<1>   }
            },
            :event{
                :click( &!toggle )
            },
            input(
                :type<checkbox>,
                :checked{ $!done },
            ),
            $!title
        )
    }
}

