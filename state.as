export struct State {
  /// Program counter (PC); used to store the currently executing
  /// address.
  pc: uint16,

  /// Stack pointer (SP); used to point to the topmost level of
  /// the stack.
  sp: byte,

  /// 16 general purpose 8-bit registers.
  v: *mutable uint8,

  /// Memory index (I); used to store memory addresses.
  i: uint16,

  /// Sound timer. Automatically decrements at a rate of 60hz. While
  /// non-zero the sound beep is played.
  st: byte,

  /// Delay timer. Automatically decrements at a rate of 60hz.
  dt: byte,

  /// General purpose memory; RAM.
  /// The CHIP-8 contains 0x1000 bytes of RAM with the first 4KiB
  /// reserved for the interpreter.
  ram: *mutable byte,

  /// Execution stack; used to store the address that the interpreter
  /// shoud return to when finished with a subroutine. The CHIP-8 only
  /// allows up to 16 levels of nested subroutines.
  stack: *mutable uint16,
}
