import libc from "../arrow/lib/libc";
import op from "./op";
import state_ from "./state";

// TODO(arrow): It'd be nice to have default init
let mutable g_state = state_.State(
  0,
  0,
  0 as *mutable byte,
  0,
  0,
  0,
  0 as *mutable byte,
  0 as *mutable uint16
);

def reset(mutable state: state_.State) {
  // Initialize registers to values that match the specifications
  // of the original interpreter.
  state.pc = 0x200;
  state.i = 0;
  state.st = state.dt = state.sp = 0;
  libc.memset(state.v, 0, 0x10);
}

def cleanup() {
  // Release
  libc.free(g_state.v);
  libc.free(g_state.ram);
}

def main(argc: int, argv: *str) -> int {
  // Ensure that we received a filename to open
  if argc < 2 {
    libc.puts("error: no input file");
    return 1;
  }

  // Open the file
  let file = libc.fopen(*(argv + 1), "rb");

  // Determine the total size of the file; we need to ensure that the
  // total size is less than 3.5 KiB.
  libc.fseek(file, 0, libc.SEEK_END as int64);
  let size = libc.ftell(file);
  if size > (0x1000 - 0x200) {
    // File is too large to be a CHIP-8 game
    libc.puts("error: input file too large");
    return 1;
  }

  // Allocate
  g_state.v = libc.malloc(0x10);
  g_state.ram = libc.malloc(0x1000);

  // Read the program ROM into RAM
  libc.fseek(file, 0, libc.SEEK_SET as int64);
  libc.fread((g_state.ram + 0x200), 1, 0x1000, file);

  // TODO: Check for HRINIT (for "high-res" mode)

  // Initialize
  reset(g_state);

  // Run (a single cycle)
  run(g_state);

  // Cleanup
  cleanup();

  return 0;
}

def run(mutable state: state_.State) {
  // NOTE: The memory space of the Chip-8 is only 0x000 - 0xFFF.
  //  An attempt to execute after 0xFFF should wrap around to 0x000.
  state.pc &= 0x0FFF;

  // Fetch the opcode from RAM.
  let opcode = state.ram + state.pc;

  // Increment the program counter.
  state.pc += 2;

  // Retreive the method to execute from the optable and run it.
  // TODO(arrow): Bit-shift
  op.table[*opcode / 16](state, opcode);
}
