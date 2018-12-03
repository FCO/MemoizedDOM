use App;

my $app = App(:todos[
    {:title<bla>, :!done},
    {:title<ble>, :done },
    {:title<bli>, :!done},
]);

$app.mount-on: document.getElementById: 'todoapp';

