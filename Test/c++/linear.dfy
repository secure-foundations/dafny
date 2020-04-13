
include "LinearSequence.s.dfy"
import opened Types
import opened LinearMaybe
import opened LinearSequences
//linear datatype Node =
//  | Leaf(linear keys: seq<uint64>, linear values: seq<uint64>)
//  | Index(linear pivots: seq<uint64>, linear children: lseq<uint64>)

method Test(name:string, b:bool) 
  requires b;
{
  if b {
    print name, ": This is expected\n";
  } else {
    print name, ": This is *** UNEXPECTED *** !!!!\n";
  }
}


//newtype{:nativeType "ulong"} uint64 = i:int | 0 <= i < 0x10000000000000000
//
//function method {:extern "LinearExtern", "seq_alloc"} seq_alloc<A>(length:uint64):(linear s:seq<A>)
//function method {:extern "LinearExtern", "seq_free"} seq_free<A>(linear s:seq<A>):()
//

method TestLinearSequences() 
{
  linear var s0 := seq_alloc<uint64>(10);
  var x := seq_get(s0, 0);
  print x;
  print "\n";
  linear var s1 := seq_set(s0, 0, 42);
//  x := seq_get(s0, 0);   // Fails linearity check
//  print x;
  Test("Test result of set", seq_get(s1, 0) == 42);
  linear var s2 := seq_set(s1, 0, 24);
  Test("Test result of set again", seq_get(s2, 0) == 24);
//  Test("Test length", seq_length(s1) == 10);  // Fails linearity check
  Test("Test length", seq_length(s2) == 10);
  var s3 := seq_unleash(s2);
  Test("Normal seq", s3[0] == 24);

  linear var t0 := seq_alloc<uint64>(5);
  linear var t1 := seq_set(t0, 4, 732);
  var _ := seq_free(t1);
}

method TestPeek(shared u:maybe<uint64>)
  requires has(u)
{
  shared var val := peek(u);
}

method TestLinearMaybe(linear u:uint64) returns (linear x:uint64)
{
  linear var m := give(u);
  linear var e := empty<uint64>();

//  shared var m_val := peek(m);
//  shared var e_val := peek(e);
  TestPeek(m);
  //TestPeek(e);    // !has(e)

  linear var m_unwrapped := unwrap(m);
  //linear var e_unwrapped := unwrap(e);

  x := m_unwrapped;
  var _ := discard(e);
}

method {:extern "LinearExtern", "MakeLinearInt"} MakeLinearInt(u:uint64) returns (linear x:uint64)
method {:extern "LinearExtern", "DiscardLinearInt"} DiscardLinearInt(linear u:uint64) 

method Main()
{
  TestLinearSequences();
  linear var x := MakeLinearInt(42);
  linear var y := TestLinearMaybe(x);
  DiscardLinearInt(y);
}
