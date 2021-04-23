// RUN: %dafny /compile:3 /spillTargetCode:2 /compileTarget:cpp ExternDefs.h "%s" > "%t"
// RUN: %diff "%s.expect" "%t"

newtype uint32 = i:int | 0 <= i < 0x100000000

method ReturnTuple() returns (x:(uint32,uint32))
{
  return (1, 2);
}

function method {:extern "Extern", "NoReturn"} NoReturn(b:bool) : ()

function method NoReturnCaller() : () {
  NoReturn(true)
}

function method Test() : (bool, bool) {
  (false, true)
}

method Main() {
  var x := ReturnTuple();
  var y := x.0;
  print y;
}
