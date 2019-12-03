
module {:extern "Extern"} Extern {
  newtype{:nativeType "ulong"} uint64 = i:int | 0 <= i < 0x10000000000000000

  method {:extern "Extern", "newArrayFill"} newArrayFill<T>(n: uint64, t: T) returns (ar: array<T>)

  type {:extern "struct"} state
  
  class {:extern} ExternClass {
    constructor {:extern "Extern", "ExternClass"}()
    method {:extern "Extern", "my_method0"} my_method0(a:uint64) returns (b:bool)
    method {:extern "Extern", "my_method1"} my_method1(c:uint64) returns (d:bool)
  }
}

module TestMod {
  import opened Extern
  class C {
    var s:state;
 
    constructor (i:state) {
      this.s := i;
    }
  }

  class D {
    var s:uint64;
 
    constructor (i:uint64) {
      this.s := i;
    }
  }

  method TestClass(e:ExternClass) {
    var x := e.my_method0(0);
    var y := e.my_method1(1);
  }

  method Main() {
    var a:array<uint64> := newArrayFill(5, 42);
    var d := new D(21);
    var b:array<D> := newArrayFill(3, d);

    var e:ExternClass := new ExternClass();
    TestClass(e);
  }
}
