// RUN: %dafny /compile:0 /print:"%t.print" /dprint:"%t.dprint" /autoTriggers:0 "%s" > "%t"
// RUN: %diff "%s.expect" "%t"

module Ptrs {
  // Non-atomic memory

  datatype PointsTo<V> = PointsTo(ghost ptr: Ptr, ghost v: V)
  datatype PointsToArray<V> = PointsToArray(ghost ptr: Ptr, ghost s: seq<V>)

  type {:extern} Ptr(!new,==)

  method {:extern} write<V>(p: Ptr, linear inout d: PointsTo<V>, v: V)
  requires old_d.ptr == p
  ensures d.ptr == p
  ensures d.v == v

  method {:extern} read<V>(p: Ptr, shared d: PointsTo<V>)
  returns (v: V)
  requires d.ptr == p
  ensures v == d.v

  method {:extern} index_write<V>(p: Ptr, linear inout d: PointsToArray, i: int, v: V)
  requires old_d.ptr == p
  requires 0 <= i < |old_d.s|
  ensures d == old_d.(s := old_d.s[i := v])

  method {:extern} index_read<V>(p: Ptr, shared d: PointsToArray<V>, i: int)
  returns (v: V)
  requires d.ptr == p
  requires 0 <= i < |d.s|
  ensures v == d.s[i]

  const {:extern} nullptr : Ptr

  method test(p: Ptr, linear inout d: PointsToArray<int>)
  requires old_d.ptr == p
  requires old_d.s == [1, 2]
  {
    index_write(p, inout d, 0, 5);
    assert d.s == [5, 2];
    assert d.s == [4, 2]; // ERROR
  }

  method test2(p: Ptr, linear inout d: PointsToArray<int>)
  requires old_d.ptr == p
  requires old_d.s == [1, 2]
  {
    index_write(p, inout d, 6, 5); // ERROR (precondition)
  }

}
