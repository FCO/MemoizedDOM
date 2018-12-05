use MemoizedDOM::Traits;
use MemoizedDOM::Subs;
use MemoizedDOM::Tag;


sub EXPORT {
    %(
        MemoizedDOM::Traits::EXPORT::ALL::,
        MemoizedDOM::Subs::EXPORT::ALL::,
        Tag => Tag,
    )
}
