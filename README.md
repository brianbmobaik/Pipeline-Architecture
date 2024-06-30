# Pipeline Architecture Simulation (VHDL)

## Basic Pipeline Architecture Diagram
![alt text](./Visuals/Pipeline%20Architecture%20RISC%20Diagram.png)

> Aside from the basic pipeline architecture components, additional components are added in to help handle various hazards:

### Forwarding Unit
> Handles data hazards by forwarding the data from the ALU to the pipeline register without going through the register file.

![alt text](./Visuals/Sample%20Output%20-%20Forwarding%20Unit.png)

### Hazard Detection Unit
> Detects stalls to send nop instruction to the pipeline to help reduce the amount of stalls.

![alt text](./Visuals/Hazard%20Detection%20Unit%20Sample.png)
![alt text](./Visuals/Sample%20Output%20-%20Hazard%20Detection%20Unit.png)

## Final Product

### RTL Schematic

![alt text](./Visuals/RTL%20Schematic.png)

### Timing Diagram

![alt text](./Visuals/Timing%20Diagram.png)