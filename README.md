# ElectronicEngineerr-UART-Communication-Protocol-with-FPGA-VHDL
ElectronicEngineerr/UART-Communication-Protocol-with-FPGA-VHDL


## Overview

This project is a VHDL-based UART (Universal Asynchronous Receiver-Transmitter) transmitter designed to send serial data at a specific baud rate. The design includes both the implementation of the UART transmitter and a corresponding test bench for functional verification. 

![UART TX SIMULATION](images/UART_TX_protocol.png)

The transmitter follows the UART protocol, which includes:
- **1 Start Bit**: Marks the beginning of data transmission.
- **8 Data Bits**: The actual payload data.
- **1 Optional Parity Bit**: (Currently not implemented but can be extended).
- **2 Stop Bits**: Marks the end of the transmission.

---

## Features

- **Customizable Baud Rate**: Configure the transmitter for various baud rates.
- **Stop Bits**: The design uses 2 stop bits for synchronization.
- **Generic Clock Support**: Configurable for different FPGA clock frequencies.
- **Test Bench Included**: A detailed test bench validates the transmitter.

---

## Configuration Parameters

The `TX_UART` module is configurable via generic parameters:

| Parameter       | Description                          | Default Value       |
|------------------|--------------------------------------|---------------------|
| `CLOCK_FREQ`     | Clock frequency of the FPGA         | `100_000_000` (100 MHz) |
| `BAUD_RATE`      | Transmission baud rate              | `115_200` (115200 bps)   |
| `Stop_bit_time`  | Stop bit duration (number of bits)  | `2`                 |

---

## How It Works

### 1. Finite State Machine (FSM)
The UART transmitter is implemented using a state machine with the following states:
- **`TX_IDLE`**: Waits for a `tx_start_in` signal to begin transmission.
- **`TX_START`**: Sends the start bit (`0`).
- **`TX_DATA`**: Serially shifts and transmits 8 data bits.
- **`TX_STOP`**: Sends the stop bits (`1`).

### 2. Shift Register Operation
During the `TX_DATA` state:
- Data bits are shifted out one by one, starting from the least significant bit (LSB).
- The process is synchronized to the clock and baud rate.

---

## Simulation and Testing

### Running the Simulation
1. Open the project in Vivado or your preferred VHDL simulator.
2. Compile both `TX_UART` and `tb_TX_UART`.
3. Run the test bench (`tb_TX_UART`) to verify the transmitter functionality.
4. Observe the waveforms in the simulator.

!!! THE BAUD RATE OF 5,000,000 HAS BEEN USED FOR EASIER VISUALIZATION DURING SIMULATION.


![UART TX SIMULATION](images/simulation_data_in_A8_F2.png)
![UART TX SIMULATION](images/simulation_data_in_AA.png)
![UART TX SUMILATION](images/simulation_data_in_CB.png)


### Expected Output
The test bench sends a sequence of bytes (`0xA8`, `0xF2`, `0xAA`, `0xCB`) through the UART transmitter. The simulation should match the expected UART protocol waveform:

---

## Future Improvements


- **Parity Bit**: Add support for parity bit generation.
- **Full UART Support**: Include a UART receiver module.
- **FIFO Integration**: Buffer incoming data for continuous transmission.

---

## Contributors

This project was developed as a demonstration of UART transmitter design in VHDL. Contributions and improvements are welcome!

---

## License

This project is licensed under the MIT License. See the LICENSE file for details.

Configuration Parameters
## Configuration Parameters

The `TX_UART` module is configurable via generic parameters:

| Parameter       | Description                          | Default Value       |
|------------------|--------------------------------------|---------------------|
| `CLOCK_FREQ`     | Clock frequency of the FPGA         | `100_000_000` (100 MHz) |
| `BAUD_RATE`      | Transmission baud rate              | `115_200` (115200 bps)   |
| `Stop_bit_time`  | Stop bit duration (number of bits)  | `2`                 |

1. Include in Your Project
Add the TX_UART module to your VHDL project.
Connect the input signals:
clk: System clock.
tx_start_in: Signal to start data transmission.
tx_data_in: 8-bit data to be transmitted.
2. Simulation
Use the test bench (tb_TX_UART) to verify functionality.
Modify tx_data_in and observe the tx_output waveform.
