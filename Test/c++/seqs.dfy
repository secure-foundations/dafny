newtype{:uint32iveType "uint"} uint32 = i:int | 0 <= i < 0x100000000

method Test(name:string, b:bool) 
  requires b;
{
  if b {
    print name, ": This is expected\n";
  } else {
    print name, ": This is *** UNEXPECTED *** !!!!\n";
  }
}

method Print(s:string) {
   print s, "\n";
}

method PrintTest() {
  Print("Hello world!");
}

method Basic() {
  var s:seq<uint32> := [1, 2, 3, 4];
  print "Head second:", s[1], "\n";
  var end := s[1..];
  print "Trunc first:", end[0], "\n";

  Test("Head trunc", end != s);
  var start := s[..1];
  var combine := start + end;

  Test("Combine", combine == s);

  var s' := s[0 := 330];
  Test("Replace1", s[0] != 330);
  Test("Replace2", s[0] == 1);

  var a := new uint32[3][12, 13, 14];
  var a_seq := a[..];
  a[0] := 42;
  var a_seq' := a[..];

  Test("Immutability", a_seq != a_seq');
}

method ValueEquality() {
    var m0:seq<uint32> := [1, 2, 3];
    var m1:seq<uint32> := m0[1..];
    var m2:seq<uint32> := [2, 3];
    Test("ValueEquality", m1 == m2);
}

method Contains() {
    var m1:seq<uint32> := [1];
    var m2:seq<uint32> := [1, 2];
    var m3:seq<uint32> := [1, 2, 3];
    var m3identical:seq<uint32> := [1, 2, 3];
    var mm := [m1, m3, m1];

    Test("Membership 1", m1 in mm);
    Test("Membership 2", !(m2 in mm));
    Test("Membership 3", m3 in mm);
    Test("Membership 3 value equality", m3identical in mm);
}

method Main() {
    Basic();
    ValueEquality();
    Contains();
    PrintTest();
}

