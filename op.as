import libc from "../arrow/lib/libc";
import state_ from "./state";
import stack from "./stack";

export let table = [
  op_0___,  // 0x0
  op_1nnn,  // 0x1
  op_unkn,  // 0x2
  op_unkn,  // 0x3
  op_unkn,  // 0x4
  op_unkn,  // 0x5
  op_unkn,  // 0x6
  op_unkn,  // 0x7
  op_unkn,  // 0x8
  op_unkn,  // 0x9
  op_unkn,  // 0xA
  op_unkn,  // 0xB
  op_unkn,  // 0xC
  op_unkn,  // 0xD
  op_unkn,  // 0xE
  op_unkn,  // 0xF

  // op_0___, // 0x0
  // op_1nnn, // 0x1
  // op_2nnn, // 0x2
  // op_3xkk, // 0x3
  // op_4xkk, // 0x4
  // op_5xy0, // 0x5
  // op_6xkk, // 0x6
  // op_7xkk, // 0x7
  // op_8___, // 0x8
  // op_9xy0, // 0x9
  // op_Annn, // 0xA
  // op_Bnnn, // 0xB
  // op_Cxkk, // 0xC
  // op_Dxyn, // 0xD
  // op_E___, // 0xE
  // op_F___, // 0xF
];

// TODO(arrow): Much nicer with a bit shift
def get_address(opcode: *byte) -> uint16 {
  // (*opcode & 0x0F) << 8
  return ((*opcode & 0x0F) * 256) | *(opcode + 1);
}

// TODO(arrow): Some way to indicate divergence
def op_unkn(mutable state: state_.State, opcode: *byte) {
  // Report unknown opcode and abort
  libc.puts("unknown opcode");
  // TODO: libc.printf("unknown opcode: 0x%02x0x%02x\n",
  //   *opcode, *(opcode + 1));

  libc.abort();
}

// TODO(arrow): Pattern matching / switch
def op_0___(mutable state: state_.State, opcode: *byte) {
  // TODO: Possible example
  // match get_address(opcode) {
  //   case 0x0E0 => op_00E0();
  //   case 0x0EE => op_00EE();
  //   case 0x230 => op_0230();
  //   case _     => op_unkn();
  // }

  let address = get_address(opcode);
  if (address == 0x0E0) { return op_00E0(state); }
  if (address == 0x0EE) { return op_00EE(state); }
  if (address == 0x230) { return op_0230(state); }
  return op_unkn(state, opcode);
}

/// CLS [00E0]
def op_00E0(mutable state: state_.State) {
  // Clear the Chip-8 64x32 display.
  // NOTE: Still clear this size screen, even when in High-Res mode.
  // TODO
}

/// HRCLS [0230]
def op_0230(mutable state: state_.State) {
  // Really clear the Chip-8 display. In normal Chip-8 mode this would
  // double-clear the Chip-8 display.
  // TODO
}

/// RET [00EE]
def op_00EE(mutable state: state_.State) {
  // Return from a subroutine.
  // The interpreter sets the program counter to the address at the top
  // of the stack, then subtracts 1 from the stack pointer.
  // NOTE: The stack is only 16 "slots".

  state.sp = 0xF if (state.sp == 0) else (state.sp - 1);
  // TODO: state.pc = stack.at(state.stack, state.sp);
}

/// JP addr [1nnn]
def op_1nnn(mutable state: state_.State, opcode: *byte) {
  // Jump to location nnn.
  // The interpreter sets the program counter to nnn.
  state.pc = get_address(opcode);
}
