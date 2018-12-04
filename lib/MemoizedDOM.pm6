use MemoizedDOM::Subs;
use MemoizedDOM::Tag;


sub EXPORT {
    %(
        MemoizedDOM::Subs::EXPORT::ALL::,
        Tag => Tag,
    )
}
