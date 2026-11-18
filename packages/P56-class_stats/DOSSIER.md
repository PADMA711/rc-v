# P56 Instruction-mix counters - dossier

Answer in your own words; short answers are fine. Diagrams can be photos of
hand drawings (put them next to this file and link them).

## U1 Digital logic
Give the truth table (or state table) of one part of your circuit and the
simplified Boolean expression you used. Which gates or flip-flops did you need?
Ans1) AND,NOT,XOR 

## U2 Digital components
Which building blocks (adders, multiplexers, decoders, registers, memory)
does your Digital circuit use, and how are they connected?
Ans2) Not used: multiplexers, decoders and memory. The circuit has no address selection or storage beyond the counters
Registers: each counter is an 8-bit register made of 8 D flip-flops. All of them share the same clk, and each bit holds one bit of the count.
Clear: a gate in front of each flip-flop forces the bit to 0 when clear or rst is on.
Adder logic: I didn’t use a ready-made adder. Each bit has an XOR gate that flips the bit, and an AND gate that passes the carry to the next bit. Together these work like a chain of half adders that adds 1.
Enable: an AND gate combines commit with is_load (or is_branch), so a counter only counts when its instruction commits.
The enable signal goes into bit 0. The carry from each bit goes into the next one (bit 0’s carry into bit 1, and so on). Each flip-flop’s output Q goes back to its own XOR gate and to the AND gate for the next carry. At the end, the 8 Q outputs are joined into one 8-bit output.

## U3 Data representation
Pick three test vectors of your block and explain them in binary, hex and
decimal (signed where it matters). Where could overflow or sign extension go wrong?
Ans3) 0x00 + 1 = 0x01 (0 to 1), no problem.
0x7F + 1 = 0x80. Unsigned that is 128, but signed it is -128, so sign matters here.
0xFF + 1 = 0x00 (255 to 0). The counter wraps around, which is overflow.

## U4 Computer organisation
In which step of the instruction cycle (fetch, decode, execute, memory,
write-back, interrupt) does your block do its work? Which instructions need it?
Ans4) Decode tells my block what kind of instruction it is. My block does its work at commit, when the instruction has really finished. Reading a counter is an ordinary load from the block’s address.

## U5 Processors
How would a CISC processor, a stack machine or a GPU do the job of your
block differently? (Look at the RISC-V vs Mano comparison in docs/ARCHITECTURE.md.)
Ans5) In RISC-V each type of instruction has its own opcode, so it’s easy to tell loads, stores, branches and jumps apart. In a CISC or stack machine, one instruction can touch memory several times, so counting would be harder. A GPU runs many threads, so it would need counters for each thread.

## U6 Memory and I/O
How does your block take part in a memory access or an I/O transfer? If it
does not, explain which neighbouring block does and how data reaches it.
Ans6) Yes, my block is a memory-mapped I/O device at slot 14. The CPU reads or writes its address. sel and we/re say which one, ridx picks the counter, and the value comes back on rdata.

## E1 Instruction trace: SW
Trace one **SW** instruction through the whole RC-V processor,
block by block (use docs/ARCHITECTURE.md and the simulator's --trace output).
List the blocks it passes through and the value on the main signals.

## E2 Neighbour review
Review the pull requests of P55 (Stack guard) and P57 (Halt controller). Paste the links to your review
comments here.

## E3 Where my block sits
In two or three sentences: which layer of the computer is your block in
(gates / components / datapath / control / instruction set / memory / I/O),
which blocks feed it and which blocks use its output?
Ans3)It sits at the I/O layer, built from gates and flip-flops. The core feeds it commit and the is_* signals. The bus feeds it sel, we, re and ridx. Its output rdata goes back to the CPU.

## E4 Syllabus map
Tick every syllabus topic your work touched (main units: Unit 4, Unit 5).

- [ ] Logic gates, Boolean algebra, K-maps
- [ ] Combinational circuits (adders, decoders, encoders, multiplexers)
- [ ] Flip-flops, registers, counters
- [ ] Memory (RAM, ROM)
- [ ] Number systems, complements, signed arithmetic
- [ ] Bus organisation, instruction codes and formats
- [ ] Instruction cycle, hardwired vs microprogrammed control
- [ ] Interrupts and the interrupt cycle
- [ ] Pipelining
- [ ] Register organisation, stack, addressing modes
- [ ] RISC vs CISC, multicore, GPU
- [ ] Memory hierarchy, cache
- [ ] I/O interface, programmed / interrupt-driven I/O, DMA
