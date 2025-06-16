# Am2910 Microprogram Controller

**Verilog implementation and simulation of the Am2910 Microprogram Controller**

---

## Description

This project implements the internal logic of the **Am2910 Microprogram Controller** using **Verilog HDL**, and verifies its functionality using a comprehensive testbench.

The **Am2910** is a classic microprogram sequencer used to control the execution flow of microinstructions stored in a microprogram memory. It supports complex branching, microsubroutine nesting, and loop count control — making it ideal for microcoded control units.

---
![image](https://github.com/user-attachments/assets/6a2c6248-8a7b-45e2-a96e-49380fb6b40f)

## Core Features

- **4096-microword address range** for sequencing microinstructions
- **Conditional and unconditional branching** within microprogram memory
- **Microsubroutine support** via a **5-level LIFO stack**
- **Loop counter** with a count capacity of 4096
- Fully synthesizable Verilog design
- **Testbench** included to simulate all control paths and edge cases

---

## Testbench & Verification

The design is validated using a **Verilog testbench**, which simulates typical usage scenarios such as:
- Sequential execution
- Branch operations
- Stack-based microsubroutine calls and returns
- Loop control and overflow detection

Waveforms and simulation results can be viewed using **Vivado**.

---

## Tools & Requirements

- Verilog HDL
- Simulation environment: Vivado

---

## Notes

This project demonstrates proficiency in:
- Digital design with Verilog
- Sequential control logic
- Stack implementation in hardware
- Microprogramming principles

It also reflects understanding of computer architecture fundamentals and hardware-level control mechanisms.

---

## Author

Justinian Pin
