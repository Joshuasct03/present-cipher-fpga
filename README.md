# 🔐 Self-Tested Dual-Mode PRESENT Cipher (FPGA Implementation)

## 📌 Overview

This project presents the design and implementation of the **PRESENT lightweight block cipher (PRESENT-80)** using Verilog HDL. The system integrates a **Built-In Self-Test (BIST)** mechanism and a **dual-mode architecture** to balance performance and energy efficiency, targeting secure and resource-constrained IoT applications.

The design follows a **"Trust Before Performance"** approach, ensuring hardware correctness before enabling encryption.

---

## 🚀 Key Features

* PRESENT-80 encryption (64-bit block, 31 rounds)
* Dual-mode architecture:

  * ⚡ **Parallel Mode** → High-speed encryption (32 cycles)
  * 🔋 **Serial-mode-inspired Mode** → Delay-based low-power behavior (234 cycles)
* Integrated **Built-In Self-Test (BIST)** for hardware validation
* FSM-based control for sequencing and mode selection
* Full RTL design with FPGA implementation

---

## 🧠 Architecture Highlights

* Iterative encryption core for area-efficient design
* Standard PRESENT S-box and permutation (P-layer) implementation
* 80-bit key scheduling mechanism
* Cross-layer control using FSM (BIST + Mode selection)
* Hardware-safe startup using self-test validation

---

## 🧪 Verification

Simulation performed using ModelSim with standard test vector:

| Parameter  | Value                  |
| ---------- | ---------------------- |
| Plaintext  | 0x0000000000000000     |
| Key        | 0x00000000000000000000 |
| Ciphertext | 0x267E4D76D77C94F4     |

✔ Verified correct encryption output
✔ Both modes produce identical ciphertext

---

## ⚙️ FPGA Implementation

* Board: Spartan-6 FPGA Trainer Kit (VPTB-20)
* Device: XC6SLX16-FTG256
* Tool: Xilinx ISE 14.7
* Clock: 20 MHz
* LUT Utilization: ~10%

### Hardware Validation

* LED7 → BIST PASS indicator
* LED6 → Encryption DONE signal
* LED[5:0] → Ciphertext output bits

✔ Successful bitstream generation and FPGA programming
✔ Real-time hardware validation using LEDs

---

## 📊 Performance Comparison

| Mode     | Cycles | Latency |
| -------- | ------ | ------- |
| Parallel | 32     | 320 ns  |
| Serial   | 234    | 2340 ns |

---

## 📂 Project Structure

```
rtl/         → Core Verilog modules  
testbench/   → Simulation testbench  
fpga/        → FPGA wrapper + constraints  
docs/        → Report, FPGA images, simulation outputs  
```

---

## 🛠 Tools Used

* Verilog HDL
* ModelSim (Simulation)
* Xilinx ISE 14.7 (Synthesis & FPGA Implementation)

---

## 🎯 Applications

* IoT security systems
* Embedded hardware encryption
* Low-power cryptographic devices

---

## 📚 References

* PRESENT Cipher Specification
* NIST AES (FIPS 197)

---

## 👨‍💻 Author

**Joshua Felix**
**Muneera S**
**Sooraj Subhash**
B.Tech Electronics and Communication Engineering
SCT College of Engineering

---
