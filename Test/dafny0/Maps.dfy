// RUN: %dafny /compile:0 /print:"%t.print" /dprint:"%t.dprint" "%s" > "%t"
// RUN: %diff "%s.expect" "%t"

// This method can be used to test compilation.
method Main()
{
   var m := map[2:=3];
   // test "in"
   if(2 in m)
   {
      print "m0\n";
   }
   else
   { assert false; }
   // test "!in"
   if(3 !in m)
   {
      print "m1\n";
   }
   else
   { assert false; }
   // dereference
   if(m[2] == 3)
   {
      print "m2\n";
   }
   else
   { assert false; }
   // test disjoint operator on .Keys sets
   if(m.Keys !! map[3 := 3].Keys)
   {
      print "m3\n";
   }
   else
   { assert false; }
   // updates should replace values that already exist
   if(m[2 := 4] == map[2 := 4])
   {
      print "m4\n";
   }
   else
   { assert false; }
   // add something to the map
   if(m[7 := 1] == map[2 := 3,7 := 1])
   {
      print "m5\n";
   }
   else
   { assert false; }
   // test applicative nature of Map<U, V> in C#
   if(m == map[2 := 3])
   {
      print "m6\n";
   }
   else
   { assert false; }
   // this should print all m1, m2, ... m6.
}

method m()
{
   var a := map[2:=3]; var b := map[3:=2];
   assert a[b[3]] == 3;
}
method m2(a: map<int, bool>, b: map<int, bool>)
   requires forall i | 0 <= i < 100 :: i in a && i in b && a[i] != b[i];
{
   assert forall i | 0 <= i < 100 :: a[i] || b[i];
}
method m3(a: map<int, int>)
   requires forall i | 0 <= i < 100 :: i in a && a[i] == i*i;
{
   assert a[20] == 400;
}
method m4()
{
   var a := map[3 := 9];
   if(a[4] == 4) // UNSAFE, 4 not in the domain
   {
      m();
   }
}

method m5(a: map<int, int>)
   requires 20 in a;
{
   assert a[20] <= 0 || 0 < a[20];
}
method m6()
{
   var a := map[3 := 9];
   assert a[3:=5] == map[3:=5];
   assert a[2:=5] == map[2:=5, 3:=9];
   assert a[2:=5] == map[2:=6, 3:=9, 2:=5]; // test the ordering of assignments in the map literal
}
method m7()
{
   var a := map[1:=1, 2:=4, 3:=9];
   assert forall i | i in a :: a[i] == i * i;
   assert 0 !in a;
   assert 1 in a;
   assert 2 in a;
   assert 3 in a;
   assert forall i | i < 1 || i > 3 :: i !in a;
}
method m8()
{
   var a: map<int,int> := map[];
   assert forall i :: i !in a; // check emptiness
   var i,n := 0, 100;
   while(i < n)
      invariant 0 <= i <= n;
      invariant forall i | i in a :: a[i] == i * i;
      invariant forall k :: 0 <= k < i <==> k in a;
   {
      a := a[i := i * i];
      i := i + 1;
   }
   assert a.Keys !! map[-1:=2].Keys;
   m3(a);
}
method m9()
{
   var a: map<int,int>, b := map[], map[];
   assert a.Keys !! b.Keys;
   b := map[2:=3,4:=2,5:=-6,6:=7];
   assert a.Keys !! b.Keys;
   assert b.Keys !! map[6:=3].Keys; // ERROR, both share 6 in the domain.
}
method m10()
{
   var a, b := map[], map[];
   assert a.Keys !! b.Keys;
   b := map[2:=3,4:=2,5:=-6,6:=7];
   assert a.Keys !! b.Keys;
   a := map[3:=3,1:=2,9:=-6,8:=7];
   assert a.Keys !! b.Keys;
}
method m11<U, V>(a: map<U, V>, b: map<U, V>)
   requires forall i :: !(i in a && i in b);
{
   assert a.Keys !! b.Keys;
}

method m12()
{
   var x := map i | 0 <= i < 10 :: i * 2;
   assert 0 in x;
   assert 1 in x;
   assert 10 !in x;
   assert x[0] == 0 && x[2] == 4;
}

function domain<U, V>(m: map<U,V>): set<U>
   ensures forall i :: i in domain(m) ==> i in m
   ensures forall i :: i in domain(m) <== i in m
{
   set s | s in m
}

method m13()
{
   var s := {0, 1, 3, 4};
   var x := map i | i in s :: i;
   assert forall i | i in x :: x[i] == i;
   assert domain(x) == s;
}

function union<U, V>(m: map<U,V>, m': map<U,V>): map<U,V>
   requires m.Keys !! m'.Keys
   // ensures forall i :: i in union(m, m') <==> i in m || i in m'
   ensures forall i :: i in union(m, m') ==> i in m.Keys + m'.Keys
   ensures forall i :: i in union(m, m') <== i in m.Keys + m'.Keys
   ensures forall i :: i in m ==> union(m, m')[i] == m[i];
   ensures forall i :: i in m' ==> union(m, m')[i] == m'[i];
{
   map i | i in (domain(m) + domain(m')) :: if i in m then m[i] else m'[i]
}

method m14()
{
   var s, t := {0, 1}, {3, 4};
   var x,y := map i | i in s :: i, map i | i in t :: 1+i;
   ghost var u := union(x,y);
   assert u[1] == 1 && u[3] == 4;
   assert domain(u) == {0, 1, 3, 4};
}

class A { var x: int; }

method m15(b: set<A>)
{
  var m := map a | a in b :: a.x;
  var aa := new A;
  assert aa !in m;
}

function method Plus(x: int, y: int): int { x + y }  // a symbol to appear in trigger
method GeneralMaps0() {
  var m := map x | 2 <= x < 6 :: x+1;
  assert 5 in m.Keys;
  assert 6 !in m.Keys;
  assert m[5] == 6;
  assert 6 in m.Values;
  assert (5,6) in m.Items;
  m := map y | 2 <= y < 6 :: Plus(y, 1) := y + 3;
  assert Plus(5, 1) in m.Keys;
  assert 7 !in m.Keys;
  assert m[6] == 8;
  assert 8 in m.Values;
  assert (6,8) in m.Items;
}

function method f(x: int): int  // uninterpreted function
  requires 0 <= x
function method g(x: int): int  // uninterpreted function

method GeneralMaps1() {
  if * {
    var m := map z | 2 <= z < 6 :: z/2 := z;  // error: LHSs not unique
  } else if * {
    var m := map z | 2 <= z < 6 :: z/2 := z/2 + 3;  // fine, since corresponding RHSs are the same
  } else if * {
    var m := map z | 2 <= z < 6 :: f(z) := 20;  // fine, since corresponding RHSs are the same
  } else if * {
    var m := map z | 2 <= z < 6 :: f(z) := z;  // error: LHSs not (known to be) unique
  }
}

ghost method GeneralMaps2() {
  if * {
    var m := imap z | 2 <= z < 6 :: g(z) := z;  // error: LHSs not (known to be) unique
  } else {
    var m := imap z :: g(z) := z;  // error: LHSs not (known to be) unique
  }
}

method GeneralMaps3() {
  // well-formedness
  if * {
    var m := map u | -2 <= u < 6 :: u := f(u);  // error: RHS may not be defined
  } else if * {
    var m := map u | -2 <= u < 6 :: f(u) := u;  // error: LHS may not be defined (also, LHS non-unique)
  }
}

function UnboxTest(s: seq<seq<int>>) : map<seq<int>, seq<int>>
{
  map i: int | 0 <= i < |s| :: s[i] := s[i] // fine, make sure unboxing doesn't unwrap the int from the nested seq<int> on the LHS
}

// ---------- test that general maps can be used in proofs ----------

method GeneralMaps4(s: set<real>, twelve: real) {
  var c0 := map n,p | n in s && p in s :: n := twelve;
  assert 2.0 in s ==> c0[2.0] == twelve;
}

method GeneralMaps5(u: seq<int>) {
  var c1 := map i: int | 0 <= i < |u| :: u[i] := u[i] + 100;
  if * {
    assert 7 < |u| && 101 < u[7] < 103 ==> c1[102] == 202;
  } else {
    assert 7 < |u| && 2101 < u[7] < 2103 ==> c1[2102] == 2200;  // error
  }
}

predicate method Thirteen(x: int) { x == 13 }
predicate method Odd(y: int) { y % 2 == 1 }

method GeneralMaps6() {
  var c2 := map x,y | 12 <= x < y < 17 && Thirteen(x) && Odd(y) :: x := y;
  assert Thirteen(13) && Odd(15);
  assert c2[13] == 15;
}

method GeneralMaps7() {
  var c3 := map i: int | 0 <= i < 100 && Thirteen(i) :: 5 := i;
  assert Thirteen(13);
  assert c3[5] == 13;
}

predicate method P8(x: int) { true }

method GeneralMaps8() {
  ghost var c4 := map x: int | true :: P8(x) := 6;
  assert P8(177);
  assert c4[true] == 6;
  assert false !in c4.Keys;
}

method GeneralMaps8'() {
  ghost var c4 := map x: int | P8(x) :: true := 6;
  assert P8(177);
  assert c4[true] == 6;
  assert false !in c4.Keys;
}

method GeneralMaps8''() {
  ghost var c4 := map x: int | 0 <= x < 10 && Thirteen(x) :: true := 6;
  assert c4 == map[];
}

// ---------- update tests for seq, multiset, map ----------

method UpdateValiditySeq() {
  var s: seq<nat> := [4, 4, 4, 4, 4];
  if * {
    s := s[10 := 4];  // error: index out of range
  } else {
    s := s[1 := -5];  // error: given value is not a nat
  }
}
method UpdateValidityMultiset() {
  var s: multiset<nat>;
  if * {
    s := s[-2 := 5];  // error: element value is not a nat
  } else {
    s := s[2 := -5];  // error: new number of occurrences is negative
  }
}
method UpdateValidityMap(mm: map<int, int>)
  requires forall k :: k in mm.Keys ==> 0 <= k
  requires forall k :: k in mm.Keys ==> 0 <= mm[k]
{
  var m: map<nat, nat> := mm;  // conversion justified by precondition
  if * {
    m := m[-2 := 10];  // error: key is not a nat
  } else {
    m := m[10 := -2];  // error: value is not a nat
  }
}

class Elem { }

method UpdateValiditySeqNull(d: Elem?, e: Elem) {
  var s: seq<Elem> := [e, e, e, e, e];
  if * {
    s := s[10 := e];  // error: index out of range
  } else {
    s := s[1 := d];  // error: given value is not a Elem
  }
}
method UpdateValidityMultisetNull(d: Elem?, e: Elem) {
  var s: multiset<Elem>;
  if * {
    s := s[d := 5];  // error: element value is not a Elem
  } else {
    s := s[e := -5];  // error: new number of occurrences is negative
  }
}
method UpdateValidityMapNull(mm: map<Elem?, Elem?>, d: Elem?, e: Elem)
  requires forall k :: k in mm.Keys ==> k != null
  requires forall k :: k in mm.Keys ==> mm[k] != null
{
  var m: map<Elem, Elem> := mm;  // conversion justified by precondition
  if * {
    m := m[d := e];  // error: key is not a Elem
  } else {
    m := m[e := d];  // error: value is not a Elem
  }
}
