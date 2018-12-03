use MemoizedDOM;
use Todo;

class App does Tag {
    has @.todos;
    has Str $.new-title = "";

    method render {
        form(
            :event{
                :submit{
                    .preventDefault;
                    @!todos.push: {
                        :title($!new-title),
                        :!done
                    };
                    $!new-title = "";
                    self.call-render
                }
            },
            ul({ do for @!todos -> (Str :$title!, Bool :$done! is rw) {
                Todo(:$title, :$done, :toggle{ $done = !$done; self.call-render })
            }}),
            input(
                :type<text>,
                :event{
                    :keyup{ $!new-title = .<target><value> }
                },
                :value{ $!new-title }
            ),
            input(
                :type<submit>,
                :value<OK>,
            )
        )
    }
}
