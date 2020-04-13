include "LinearMaybe.s.dfy"

newtype{:nativeType "ulong"} uint64 = i:int | 0 <= i < 0x10000000000000000

function method seq_get<A>(shared s:seq<A>, i:uint64):(a:A)
    requires i as int < |s|
    ensures a == s[i]

function method seq_set<A>(linear s1:seq<A>, i:uint64, a:A):(linear s2:seq<A>) // can be implemented as in-place update
    requires i as nat < |s1|
    ensures s2 == s1[i as nat := a]

function method seq_length<A>(shared s:seq<A>):(n:nat)
    ensures n == |s|

function method seq_alloc<A>(length:uint64):(linear s:seq<A>)
    ensures |s| == length as int

function method seq_free<A>(linear s:seq<A>):()

function method seq_unleash<A>(linear s1:seq<A>):(s2:seq<A>)
    ensures s1 == s2

type lseq<A>

function lseqs_raw<A>(l:lseq<A>):(s:seq<maybe<A>>) // contents of an lseq, as ghost seq
  ensures rank_is_less_than(s, l)

lemma axiom_lseqs_rank<A>(l:lseq<A>, s:seq<A>)
  requires |lseqs_raw(l)| == |s|
  requires forall i :: 0 <= i < |s| ==> s[i] == read(lseqs_raw(l)[i])
  ensures rank_is_less_than(s, l)

// it's okay to synthesize all the lseqs you want if they're ghosty
function imagine_lseq_raw<A>(s:seq<A>):(l:lseq<A>)
  ensures lseq_length_raw(l) == |s|
  ensures forall i :: 0 <= i < |s| ==> s[i] == read(lseqs_raw(l)[i])

function method lseq_length_raw<A>(shared s:lseq<A>):(n:nat)
    ensures n == |lseqs_raw(s)|

function method lseq_alloc_raw<A>(length:uint64):(linear s:lseq<A>)
    ensures |lseqs_raw(s)| == length as nat
    ensures forall i:nat | i < length as nat :: !has(lseqs_raw(s)[i])

function method lseq_free_raw<A>(linear s:lseq<A>):()
    requires forall i:nat | i < |lseqs_raw(s)| :: !has(lseqs_raw(s)[i])

// can be implemented as in-place swap
method lseq_swap_raw<A>(linear s1:lseq<A>, i:uint64, linear a1:maybe<A>) returns(linear s2:lseq<A>, linear a2:maybe<A>)
    requires i as nat < |lseqs_raw(s1)|
    ensures a2 == lseqs_raw(s1)[i as nat]
    ensures lseqs_raw(s2) == lseqs_raw(s1)[i as nat := a1]

// can be implemented as in-place swap
function method lseq_swap_raw_fun<A>(linear s1:lseq<A>, i:nat, linear a1:maybe<A>):(linear p:(linear lseq<A>, linear maybe<A>))
    requires i < |lseqs_raw(s1)|
    ensures p.1 == lseqs_raw(s1)[i]
    ensures lseqs_raw(p.0) == lseqs_raw(s1)[i := a1]

function method lseq_share_raw<A>(shared s:lseq<A>, i:uint64):(shared a:maybe<A>)
    requires i as int < |lseqs_raw(s)|
    ensures a == lseqs_raw(s)[i]

