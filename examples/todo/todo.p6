use App;

EVAL :lang<JavaScript>, 'HTMLElement.prototype.defined = function() { return true }';
EVAL :lang<JavaScript>, 'document.defined = function() { return true }';

my \document = EVAL :lang<JavaScript>, 'return document';

my $app = App(:todos[
    {:title<bla>, :!done},
    {:title<ble>, :done },
    {:title<bli>, :!done},
]);

$app.mount-on: document.getElementById: 'todoapp';

