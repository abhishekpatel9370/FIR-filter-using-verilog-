# FIR Filter Project

## 📌 Overview
This project implements a **Finite Impulse Response (FIR) Filter** using **Verilog HDL**, with a **Python-based data flow** for input and output handling.  

### 🔄 Workflow
1. Generate a signal using **Python** and save it to `input.txt`.  
2. Pass the signal data into the **Verilog FIR Filter** (simulated in Vivado/ModelSim).  
3. The FIR filter processes the input and writes the **filtered output** to `output.txt`.  
4. Read the filtered output back in **Python** and plot the **original vs. filtered signal**.  

This demonstrates how **software (Python)** and **hardware description (Verilog)** can work together for **digital signal processing (DSP)**.  

## ⚡ Features
- Signal generation with Python  
- Text-based I/O (`.txt`) for smooth integration between Python and Verilog  
- FIR filter implemented in **Verilog HDL** (synthesizable design)  
- Testbench included for simulation and validation  
- Python visualization of results (input vs. filtered output)  

## 🛠️ Tools & Technologies
- **Python** – Signal generation, data handling, plotting (Matplotlib)  
- **Verilog HDL** – FIR filter implementation and testbench  
- **Vivado / ModelSim** – Simulation environment  
- **File I/O** – `.txt` input/output exchange between Python and Verilog  
