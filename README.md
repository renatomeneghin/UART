# UART IP Core

Custom and configurable UART IP Core developed in VHDL, with a modular architecture based on **Control Unit (CU)** and **Datapath (DP)**.

The project is being developed as a reusable digital IP for FPGA-based systems, with particular interest in applications involving **embedded systems, SoCs, and reconfigurable computing architectures**.

## Features

* Configurable UART transmitter and receiver
* Separate Control Unit (CU) and Datapath (DP)
* Configurable number of data bits
* Configurable parity
* Configurable number of stop bits
* Dedicated baud-rate generation
* Reusable RTL building blocks
* Synchronous digital design
* Designed for FPGA implementation
* Target platform: **Microchip PolarFire SoC MPFS025T**
* Developed using VHDL

## Architecture

The UART is divided into independent functional blocks.

```text
                         UART IP Core
                              │
              ┌───────────────┴───────────────┐
              │                               │
        ┌─────▼─────┐                   ┌─────▼─────┐
        │ UART TX   │                   │ UART RX   │
        └─────┬─────┘                   └─────┬─────┘
              │                               │
       ┌──────┴──────┐                 ┌──────┴──────┐
       │             │                 │             │
   ┌───▼───┐     ┌───▼───┐         ┌───▼───┐     ┌───▼───┐
   │  CU   │     │  DP   │         │  CU   │     │  DP   │
   └───────┘     └───────┘         └───────┘     └───────┘
                                      │
                              ┌───────┴────────┐
                              │ Synchronizer   │
                              │ Counter        │
                              │ Shift Register │
                              │ Parity         │
                              └────────────────┘
```

### Transmitter

The transmitter uses a finite-state control unit with the following protocol phases:

```text
        ┌──────┐
        │ IDLE │
        └──┬───┘
           │ go
           ▼
        ┌──────┐
        │ DATA │
        └──┬───┘
           │
           ▼
       ┌────────┐
       │ PARITY │
       └───┬────┘
           │
           ▼
        ┌──────┐
        │ STOP │
        └──┬───┘
           │
           └──────────► IDLE
```

The TX datapath contains the shift register, parity generation, timing counter, comparator, zero detector, and output multiplexer.

### Receiver

The receiver is organized into five protocol states:

```text
IDLE → START → DATA → PARITY → STOP
  ▲                         │
  └─────────────────────────┘
```

The receiver datapath is responsible for synchronization, timing, data shifting, parity processing, and sampling of the serial input.

The timing of the individual samples is handled by the datapath and counters, while the Control Unit remains responsible for the protocol phase.

## Reusable RTL Components

The UART makes use of several reusable digital building blocks:

* Flip-Flop D
* T Flip-Flop
* Shift Register
* Counters
* Enable/Resettable Counters
* Arithmetic/Logic Unit (UAL)
* Zero Detector
* Registers
* Majority/TMR voter
* Baud-Rate Generator

These components are intended to form a small reusable RTL library that can also be applied to future IP cores.

## Repository Structure

```text
UART/
│
├── hdl/
│   ├── UART_Tx_CU.vhd
│   ├── UART_Tx_DP.vhd
│   ├── UART_Rx_CU.vhd
│   ├── UART_Rx_DP.vhd
│   ├── BaudRate_Generator.vhd
│   │
│   └── reusable/
│       ├── counter.vhd
│       ├── contador_ud_en.vhd
│       ├── Flip_Flop_D.vhd
│       ├── TFF.vhd
│       ├── shift_reg.vhd
│       ├── UAL.vhd
│       ├── Zero_detector.vhd
│       └── ...
│
├── simulation/
│   ├── tb_UART_Tx.vhd
│   ├── tb_UART_Rx.vhd
│   ├── tb_UART.vhd
│   │
│   ├── scripts/
│   │   ├── compile.do
│   │   ├── sim_tx.do
│   │   ├── sim_rx.do
│   │   └── sim_uart.do
│   │
│   └── vectors/
│
└── README.md
```

> The repository structure may evolve as the IP and verification environment are developed.

## Configuration

The UART is designed to support configurable serial communication parameters, including:

| Parameter   | Description                                  |
| ----------- | -------------------------------------------- |
| Data length | Number of data bits                          |
| Parity      | Disabled / even / odd                        |
| Stop bits   | 1 / 1.5 / 2                                  |
| Baud rate   | Configurable through the baud-rate generator |

The exact supported configurations depend on the current implementation of the TX and RX modules.

## Baud-Rate Generation

The `BaudRate_Generator` provides the timing used by the UART.

The generator is based on a programmable frequency divider and can provide different baud-rate configurations according to `BAUD_SEL`.

The generated timing is synchronous with the main input clock.

## Simulation and Verification

Simulation is performed using HDL simulation tools and `.do` scripts.

The verification strategy is being developed progressively, starting with individual blocks and moving toward complete UART communication.

Planned verification levels:

```text
Reusable RTL blocks
        │
        ▼
   TX simulation
        │
        ▼
   RX simulation
        │
        ▼
 TX → RX loopback
        │
        ▼
 Error injection
        │
        ▼
 Parameter sweep
```

The planned test cases include:

* Transmission of valid UART frames
* Reception of valid UART frames
* TX/RX loopback
* Different data widths
* Different parity configurations
* Different stop-bit configurations
* Different baud-rate configurations
* Reset during communication
* Parity-error detection
* Framing-error detection
* Timing and sampling verification

## Target Hardware

The current development target is the:

**Microchip PolarFire SoC MPFS025T**

The architecture is being developed with FPGA implementation in mind and is intended to serve as a basis for future integration with processor-based systems and custom SoC architectures.

## Development Status

| Component                         | Status                         |
| --------------------------------- | ------------------------------ |
| UART TX architecture              | 🟢 In development / functional |
| UART RX architecture              | 🟡 In development              |
| Baud-rate generator               | 🟢 Implemented                 |
| Reusable RTL blocks               | 🟢 In development              |
| TX simulation                     | 🟡 In development              |
| RX simulation                     | 🟡 In development              |
| TX/RX loopback                    | ⚪ Planned                      |
| Error injection                   | ⚪ Planned                      |
| Complete verification environment | ⚪ Planned                      |
| FPGA hardware validation          | ⚪ Planned                      |

The project is under active development. Interfaces and internal architectures may change as verification progresses.

## Future Development

Planned extensions include:

* Complete RX implementation and verification
* Automated simulation scripts
* Self-checking testbenches
* TX/RX loopback verification
* Error detection and injection
* FIFO integration
* Register bank
* Interrupt generation
* Processor interface
* Integration with standard SoC buses
* Reuse of the UART as a peripheral in a future RISC-V-based system

## Motivation

This project is part of a broader effort to develop reusable and configurable digital IP blocks for FPGA-based embedded systems.

The UART serves as a practical starting point for studying:

* RTL design
* Control/datapath architectures
* Parameterized digital hardware
* FPGA implementation
* IP reuse
* Verification methodologies
* Processor-peripheral interfaces
* Fault-tolerant digital architectures

The long-term goal is to use these building blocks as part of larger **reconfigurable computing and SoC architectures for embedded and small-satellite applications**.

## License

License information will be added as the project reaches a stable release.

