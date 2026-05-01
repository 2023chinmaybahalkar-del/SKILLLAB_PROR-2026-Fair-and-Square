# SKILL LAB PRATICAL HACKATHON

## Final Project README

> **Project Weight:** 100%  
> **Team Size:** 4/3 students  
> **Project Duration:** 16 hours  
> **Total Time Available:** 32 effort-hours per team  
> **Project Type:** Playful, interactive, technology-based experience

---

# Before you begin

## Fork and rename this repository

After forking this repository, rename it using the format:

`SKILLLAB_PROR-2026-TeamName`

### Example

`SKILLLAB_PROR-2026-AuroWizards`

Do not keep the default repository name.

---

# How to use this README

This file is your team’s **working project document**.

You must keep updating it throughout the build period.  
By the final review, this README should clearly show:

- your idea,
- your planning,
- your design decisions,
- your technical process,
- your build progress,
- your testing,
- your failures and changes,
- your final outcome.

## Rules

- Fill every section.
- Do not delete headings.
- If something does not apply, write `Not applicable` and explain why.
- Add images, screenshots, sketches, links, and videos wherever useful.
- Update task status and weekly logs regularly.
- Use this file as evidence of process, not only as a final report.

---

# 1. Team Identity

## 1.1 Studio / Group Name

`Fair and Square`

## 1.2 Team Members

| Name                  | Primary Role                  | Secondary Role               | Strengths Brought to the Project |
| --------------        | ----------------------------- | --------------               | -------------------------------- |
| Kavish Chauhan        | Implementation of 1st method  | Documentation                | Technical Finesse                |
| Chinmay Bahalkar      | Github Updation               | Overall Research             | Critical Idea Thinker            |
| Pratyush Tripthi      | Research of 1st solution      | Implementation of 2nd method | Surgical Curiosity               |
| Nimesh Prabhu         | Research of 2nd Solution      | Implementation of 2nd method | Unquestiong Dicsiplined Teamwork |

## 1.3 Project Title

Real Time edge detection using FPGA

<img width="1600" height="1131" alt="image" src="https://github.com/user-attachments/assets/c64bfbd4-b3b7-43d9-83ad-c203a5aa11bc" />

## 1.4 One-Line Pitch

An FPGA based hardware accelerator that implements a custom pixel processing pipeline to detect edges in images using min-max thresholding logic.

## 1.5 Expanded Project Idea

This project is a hardware-based image processing system designed to perform edge detection using a Spartan-7 FPGA. The system uses custom Verilog logic to identify boundaries within an image. The implementation uses a "max-min" thresholding algorithm, which analyzes 1 x 4 pixel blocks to determine if a significant brightness transition exists. By offloading these calculations to the FPGA, the project demonstrates how dedicated hardware can be used to accelerate specific data-processing tasks.

The system operates as an interactive peripheral controlled by a host PC. Using a Python interface, the user selects an image and defines a sensitivity threshold. This data is transmitted to the FPGA via a UART interface, triggering the hardware's processing cycle. Once the FPGA identifies the edges, it transmits the resulting binary map back to the PC for visualization. This workflow creates a practical example of hardware-software co-design, where the FPGA acts as a specialized co-processor for the high-level Python application.   

OpenCV & NumPy is used for preprocessing the image, Python is the host side language, Communication protocol is UART, Verilog on Vivado used for designing, synthesising and implementing the solution on FPGA

---

# 2. Inspiration

## 2.1 References

List what inspired the project.

| Source Type | Title / Link                                                        | What Inspired You                                                                         |
| ----------- | ------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| `[Video]`   | `https://youtu.be/BndWx6UUtMQ?si=wZRYt1RuIHBTUKzz` | `How high-speed edge detection can enable real-time projection mapping that seamlessly interacts with dynamic, moving surfaces.` |

## 2.2 Original Twist

The originality of this project lies in the move away from traditional software-based image filters toward a custom-tailored hardware pipeline. While most edge detection is performed using high-level software libraries (like OpenCV) on a CPU, this project recreates that functionality at the gate level.The key original aspects include:
- **Custom "Max-Min" Hardware Logic:** Instead of using resource-heavy Sobel or Canny kernels that require complex multiplication and large memory buffers, this project uses a streamlined range-based algorithm. By calculating the difference between the maximum and minimum intensity in a $1 \times 4$ pixel block, the system achieves edge detection using only comparators and subtractors, significantly reducing the FPGA resource footprint.
- **Hardware-Software Handshaking:** The project implements a unique UART-coupled FSM (Finite State Machine). The FPGA doesn't just run a loop; it remains in a reactive state, waiting for a specific command byte ($0xFF$) and a dynamic threshold value from the host. This allows the user to tune the hardware's sensitivity in real-time from the Python interface without needing to re-synthesize the Verilog code.

---

# 3. Project Intent

## 3.1 User Journey 

Priya is a third-year ECE student who has heard about FPGAs but never seen one do anything visual. She plugs the Boolean Board into her laptop via USB, opens a terminal, and runs a single Python script. The script asks for nothing — it preprocesses a photo of a spinning top, waits three seconds for the board to boot, then starts streaming pixel data over the serial port. She watches the progress counter tick upward: 4096, 8192, 12288, 16384 pixels sent. A second later, a window pops up. On the left is the original grayscale photo. On the right is a clean black-and-white edge map — the outline of the top, its stem, its shadow — all detected not by any software algorithm but by logic gates running at 100 million cycles per second inside the chip on the board in front of her. She changes the threshold from 30 to 15 and runs it again. More edges appear. She changes the image to a photo of her face. The FPGA doesn't know or care — it just processes pixels.

---

# 4. Definition of Success

## 4.1 Definition of “Usable”

The project is considered "usable" when it achieves a reliable end-to-end data cycle between the host PC and the FPGA hardware.
- **Successful Handshaking:** The FPGA must correctly identify the $0xFF$ start command and update its internal threshold register based on the user's input from the Python script.
- **Data Integrity:** The system must transmit, process, and return a full $128 \times 128$ image frame without dropping pixels or stalling during the UART transfer.
- **Visual Accuracy:** The resulting binary map must clearly represent the high-contrast boundaries of the original image, confirming that the "max-min" logic is functioning as intended.
- **Repeatability:** The user must be able to run the process multiple times with different threshold values without needing to reset the FPGA hardware manually.


## 4.2 Minimum Usable Version

A single Python script that sends a hardcoded test image to the FPGA over UART and displays the edge map returned. The FPGA correctly identifies edge vs. flat blocks using the min-max threshold algorithm and transmits the result back. No GUI, no camera, no real-time feed — just one image in, one edge map out, working reliably.

## 4.3 Stretch Features

- Live webcam feed processed frame by frame
- Adjustable threshold via keyboard input without restarting the script
- Overlay mode showing edges drawn on top of the original image in color
- Support for larger image sizes (256×256)
- Display edge map directly on HDMI output from the FPGA without sending back to laptop

---

# 5. System Overview

## 5.1 Project Type

Check all that apply.

- [x] Electronics-based
- [ ] Mechanical
- [ ] Sensor-based
- [x] App-connected
- [ ] Motorized
- [ ] Sound-based
- [x] Light-based
- [x] Screen/UI-based
- [ ] Fabricated structure
- [ ] Game logic based
- [ ] Installation
- [ ] Other:

## 5.2 High-Level System Description

- **Input:**   
The input process begins on a host PC. A Python script takes a standard digital image (e.g., JPEG or PNG) and performs two main tasks
  - **Preprocessing:** It converts the image to grayscale and resizes it to a $128 \times 128$ resolution to fit within the FPGA's memory constraints.
  - **Transmission:** The PC sends a "start" command ($0xFF$) followed by a user-defined sensitivity threshold and the raw pixel data via a USB-to-UART serial interface.
- **Processing:**   
Once the data enters the Spartan-7 FPGA, the internal logic takes over
  - **Storage:** The incoming pixels are stored in a Frame Buffer (BRAM).Buffering: A "Pixel Buffer" module groups the raw data into blocks of four pixels.
  - **Edge Detection Logic:** The system calculates the difference between the brightest and darkest pixel in each block. If this difference is greater than the user's threshold, the block is flagged as an "edge."
  - **Control:** A Finite State Machine (FSM) coordinates the timing to ensure pixels are processed only after they have been fully received.
- **Output:**   
After processing, the FPGA generates a binary edge map.
  - **Serialization:** The FSM sends the results (1 for an edge, 0 for flat ground) back through the UART TX module.
  - **Reconstruction:** The Python script receives these bytes and reconstructs them into a $128 \times 128$ image.
  - **Display:** The final output is a side-by-side visual comparison on the PC screen showing the original image and the detected hardware-generated edges.
- **Physical Structure:**
  - **Boolean Board:** A Spartan-7 FPGA board which houses the programmable logic, memory, and clock source.
  - **Communication Link:** A Micro-USB cable connecting the board to the PC, serving as the UART serial bridge.
  - **PC:** Preprocessing and Host side control.
- **App Interaction:**   
Interaction occurs through the Python Terminal and GUI. The user interacts with the system by modifying the THRESHOLD variable in the script. The Python application manages the "handshake," informing the user when the board has finished booting, showing the progress of pixel transmission, and finally launching a window to display the processed result.

## 5.3 Input / Output Map

| System Part                              | Type            | What It Does                                                               |
|----------    |----------      |------------     |
| OpenCV & Numpy | Processing (SOFTWARE) | Preprocesses input images |
| Python Script | Control & Communication | Allows user to control threshold for quality and transmits data to FPGA |
| UART Module FPGA | Communication | Recieves data from laptop and sends processed data back |
| BRAM | Storage | Stores data on FPGA for processing |
| Pixel Buffer | Storage | Accumulates 4 pixels into a 32 bit block|
| Split Logic Module | Processing (HARDWARE) | Computes min/max, compares to threshold |
| Result Buffer | Storage | Stores processed pixel data|
| Python Visualise | Output | Reconstructs and displays output recieved from FPGA alongside input |
| LEDs| Output (DEBUG) | Shows current FSM state|

---

# 6. System Design, Sketches and Visual Planning 

## 6.1 Concept Architecture/sketch/schematic

Add an early sketch of the full idea.

**Insert image below:**  
`[Upload image and link here]`

Example:

```md

```



## 6.2 Labeled Build Sketch/architecture/flow diagram/algorithm

<img width="738" height="701" alt="image" src="https://github.com/user-attachments/assets/c821b10a-3194-4545-a521-51381790b2cd" />

## 6.3 Approximate Dimensions

`-`

---

# 7. Electronics Planning

## 7.1 Electronics Used

| Component                 | Quantity | Purpose                               |
| ------------------------- | --------:| ------------------------------------- |
| `FPGA`                  | `1`      | `Main logic`                   |
| `Laptop`                | `1`      | `Controller`                        |


## 7.2 Wiring Plan

The FPGA is connected to Laptop via the UART/PWR Port, which is micro-USB type connection on FPGA end and USB-A type connection on Laptop end.

## 7.3 Circuit Diagram/architecture diagram

`-`

# 7.4. Power Plan

| Question         | Response                                                                                                                                          |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| Power source     | `Laptop Battery`                                                                                                                           |
| Voltage required | `5VDC for Boolean Board`                                                                  |
| Current concerns | `-`                                       |
| Safety concerns  | `-` |

---

# 8. Software Planning/

## 8.1 Software Tools

| Tool / Platform                | Purpose                                        |
| ------------------------------ | ---------------------------------------------- |
| `Vivado`                       | `Write logic & Design System`                  |
| `Python`                       | `Host-Side Control Logic`                      |
| `OpenCV & NumPy`                       | `Preprocessing image`                          |
| `PySerial`                     | `Managing the UART interface with FPGA`        |

## 8.2 Software Logic/Algorithm

- **Startup behavior:**  
  The Spartan-7 FPGA initializes the internal Finite State Machine (FSM), clears the Block RAM (BRAM) address pointers, and enters a low-power wait state (S_WAIT_FF). Simultaneously, the Python script on the laptop initializes the serial COM port.
- **Input handling:**  
  The Python interface captures the user's desired sensitivity threshold. It then imports preprocessed data—a flattened 1D array of 8-bit grayscale pixels—generated by a separate script. These inputs are serialized and queued for transmission over the UART link.
- **Sensor reading:**  
  The system "reads" digital image data as its primary input. The UART RX module continuously monitors the incoming bitstream to reconstruct 8-bit pixel values, triggering the rx_ready flag whenever a new byte is captured.
- **Decision logic:**  
  The core logic utilizes a "Max-Min" comparison within the split_logic module. The FSM buffers four pixels into a 32-bit register and calculates the intensity range ($\Delta P = \max - \min$). If this difference exceeds the user-defined threshold stored in the threshold_reg, the logic assigns a binary "1" (edge) to that block; otherwise, it is assigned a "0".
- **Output behavior:**  
  The FPGA generates a binary edge map and stores it in the output buffer. This data is then shifted out through the UART TX module to the laptop, where the Python script reconstructs the bits into a $128 \times 128$ image for visual display. On-board LEDs provide physical feedback on the current FSM state.
- **Communication logic:**  
  The system is "UART-coupled," with the execution flow governed by the host. The laptop sends a command byte ($0xFF$) to trigger the FPGA, followed by the threshold value and the pixel stream. The FPGA responds by sending back processed results once the computation for a block is complete.
- **Reset behavior:**  
  The system returns to the S_WAIT_FF state after an image transmission is finished, clearing temporary registers while retaining the threshold value. If communication is interrupted, re-sending the $0xFF$ command from the host resets the FPGA's address pointers for a fresh transmission.

## 8.3 Code Flowchart

<img width="902" height="770" alt="EMBFLO" src="https://github.com/user-attachments/assets/90e767a4-2814-4ede-b1ed-6f99b6bd0150" />

# 9. Bill of Materials

## 9.1 Full BOM

| Item                             | Quantity | In Kit? | Need to Buy? | Estimated Cost | Material / Spec               | Why This Choice?          |
| -------------------------------- | --------:| ------- | ------------ | --------------:| ----------------------------- | ------------------------- |
| `Spartan-7 Boolean Board`        | `1`      | `Yes`   | `No`         | `9000`       | `xc7s50csga324-1`        | `Provides the necessary FPGA fabric and integrated UART-to-USB bridge.` |
| `Micro-USB Cable`                 | `1`    | `Yes` | `No`       | `250`            | `Standard USB 2.0`                     | `Easy UART using Laptop`  |
| `Laptop`          | `1`    | `yes`  | `No`      | `-`        | `Windows/Linux with Python 3.x` | `Friendly host side control, preprocessing, visualisation`    |


## 9.2 Material Justification

`The Spartan-7 Boolean Board was selected because it provides a cost-effective yet powerful platform for entry-level hardware acceleration. It contains sufficient Block RAM (BRAM) to store a full $128 \times 128$ image frame ($16,384$ bytes), which is critical for our "Receive-Process-Transmit" workflow. Unlike a traditional microcontroller, the FPGA allows us to implement the "Max-Min" edge detection logic in a single clock cycle through spatial parallelism.`


## 9.3 Items You chose

| Item                 | Why Needed               | Purchase Link | Latest Safe Date to Procure | Status       |
| -------------------- | ------------------------ | ------------- | --------------------------- | ------------ |
| `Spartan-7 Boolean Board` | `Main Logic, parallel performance`   | `-`     | `-`                | `Received` |
| `Micro-USB Cable`     | `Data Transmission` | `-` | `-`            | `Received` |
| `Laptop`   | `Preprocessing and Host Control`         | `-` | `-`            | `Recieved`   |

## 9.4 Budget Summary

| Budget Item           | Estimated Cost              |
| --------------------- | ---------------------------:|
| Electronics           | `9000`                     |
| Mechanical parts      | `-`                     |
| Fabrication materials | `-` |
| Purchased extras      | `0`                       |
| Contingency           | `0`                     |
| **Total**             | `9000`                     |

## 9.5 Budget Reflection

Can acquire better board and achieve real time + better results.

# 10. Planning the Work

## 10.1 Team Working Agreement

Write how your team will work together.

Include:

- how tasks are divided,
- how decisions are made,
- how progress will be checked,
- what happens if a task is delayed,
- how documentation will be maintained.

**Response:**  


## 10.2 Task Breakdown

| Task ID | Task                    | Owner    | Estimated Hours | Deadline     | Dependency | Status |
| ------- | ----------------------- | -------- | ---------------:| ------------ | ---------- | ------ |
| T1      | `[Finalize concept]`    | `[Both]` | `2`             | `1st April`  | `None`     | `Done` |


## 10.3 Responsibility Split

| Area                 | Main Owner     | Support Owner |
| -------------------- | ----------     | ------------- |
| Concept              | `[Mrugendra]`  | `[Jyoti]`     |
| Electronics          | `[]`           | `[]`          |
| Coding               | `[]`           | `[]`          |
| Mechanical build     | `[]`           | `[]`          |
| Testing              | `[]`           | `[]`          |
| Documentation        | `[]`           | `[]`          |

---

# 11 hour Milestones

## 11.1 8-hour Plan(tentetively you may set)

### Bi Hour 1 — Plan and De-risk

Expected outcomes:

- [x] Idea finalized
- [x] Core interaction decided
- [x] Sketches made
- [x] BOM completed
- [x] Purchase needs identified
- [ ] Key uncertainty identified
- [x] Basic feasibility tested

### Bi Hour 2 — Build Subsystems

Expected outcomes:

- [x] Electronics tests completed
- [ ] CAD / structure planning completed
- [ ] App UI started if needed
- [x] Mechanical concept tested
- [x] Main subsystems partially working

### Bi Hour 3 — Integrate

Expected outcomes:

- [x] Physical body built
- [x] Electronics integrated
- [x] Code connected to hardware
- [ ] App connected if required
- [x] First playable version exists

### Bi Hour 4 — Refine and Finish

Expected outcomes:

- [x] Technical bugs reduced
- [x] Playtesting completed
- [x] Improvements made
- [x] Documentation completed
- [x] Final build ready

## 12.2  Update Log

| Days   | Planned Goal   | What Actually Happened | What Changed   | Next Steps     |
| ------ | -------------- | ---------------------- | -------------- | -------------- |
| Day 1 | `[Write here]` | `[Write here]`         | `[Write here]` | `[Write here]` |
| Day 2 | `[Write here]` | `[Write here]`         | `[Write here]` | `[Write here]` |
| Day 3 | `[Write here]` | `[Write here]`         | `[Write here]` | `[Write here]` |
| Day 4 | `[Write here]` | `[Write here]`         | `[Write here]` | `[Write here]` |

---

# 13. Risks and Unknowns

## 13.1 Risk Register

| Risk                                                            | Type         | Likelihood | Impact   | Mitigation Plan                                                                       | Owner                |
| --------------------------------------------------------------- | ------------ | ---------- | -------- | ------------------------------------------------------------------------------------- | -------------------- |
| WiFi connection between laptop and ESP32 becomes unstable       | `Technical`  | `Medium`   | `High`   | Keep ESP32 close, ensure stable power supply, reduce network load, add fail-safe stop | `[Gopal]`           |


## 13.2 Biggest Unknown Right Now

What is the single biggest uncertainty in your project at this stage?

**Response:**  


---

# 14. Testing 

## 14.1 Technical Testing Plan

| What Needs Testing     | How You Will Test It                                                                 | Success Condition                                                                                    |
| ---------------------- | ------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------- |
| `[Wifi connection]`    | `[Check if motor spins via app button]`                                              | `[Both motors accurately respond to wifi signals]`                                                   |
                       |
## 14.2 Testing and Debugging Log

| Date          | Problem Found                         | Type         | What You Tried                                | Result               | Next Action                                    |
| ------------- | ------------------------------------- | ------------ | --------------------------------------------- | -------------------- | ---------------------------------------------- |
| `18th April`  | `Car not balancing properly`          | `Mechanical` | `Add low-friction caster support to one side` | `Worked`             | `improve caster structure`                     |


## 14.3 Playtesting Notes

`-`

# 15. Build Documentation

## 15.1 Fabrication Process(if any)
 
`-`

## 16 Build Photos

Final Output

<img width="325" height="192" alt="op" src="https://github.com/user-attachments/assets/b6721b45-7428-465d-b188-69ccdca735de" />


# 17. Final Outcome

## 17.1 Final Description

The final system is a working UART-based FPGA image edge detection pipeline. A Python script on a Windows laptop sends any 128×128 grayscale image to a Xilinx Spartan-7 FPGA (Boolean Board) over USB serial at 115200 baud. The FPGA stores the image in block RAM, processes all 16,384 pixels in 4-pixel blocks using a hardware min-max edge detector, stores 4,096 binary results, and transmits them back. The Python script reconstructs and displays a binary edge map alongside the original image. The system completes a full round-trip in approximately 8 seconds and resets automatically for the next frame.

## 17.2 What Works Well

- The UART RX/TX pipeline is robust with no dropped bytes at 115200 baud
- The two-phase FSM (receive all then transmit all) eliminates race conditions completely
- The boot delay cleanly handles the board's startup serial garbage
- The 4-pixel block size gives reasonable spatial resolution while keeping result bandwidth low
- LEDs accurately reflect FSM state, making debugging straightforward
- The Python script handles stalls and incomplete transfers gracefully without crashing

## 17.3 What Still Needs Improvement

- Edge resolution is still coarse — 4×1 pixel horizontal blocks miss vertical edges entirely
- No real-time processing; each image takes ~8 seconds end to end
- Threshold is set at script launch, not adjustable live
- Image size is fixed at 128×128; larger images would need protocol changes
- Communication Bottleneck:   
  Bandwidth mismatch where the slow, bit-by-bit UART serial protocol (115,200 baud) starves the high-speed FPGA logic (100 MHz) of data, forcing the "Ferrari" engine to wait 1.4 seconds just to receive a single frame. Migrating to a high-speed interface like SPI would be necessary for true real-time video performance.
    
## 17.4 What Changed From the Original Plan

The project evolved from a high-speed embedded system into a specialized hardware-accelerated image processing unit. The primary changes include:
- **Platform Pivot:**    
The initial concept relied on a PYNQ-Z2 or Raspberry Pi to handle live video streaming. Due to hardware constraints, the design was adapted to the Spartan-7 (Boolean Board), focusing on standalone RTL logic.
- **Communication Interface:**     
The plan for real-time video via AXI-Stream or SPI was replaced with a stable UART link at 115,200 baud. This shifted the focus from "60 FPS video" to "frame-by-frame hardware acceleration" via the Micro-USB bridge.
- **Task Partitioning:**     
Instead of using an onboard ARM processor for image capture, a Host PC (Python/OpenCV) was used to resize ($128 \times 128$) and grayscale images before feeding them to the FPGA for the mathematical "heavy lifting."

---

# 18. Reflection

## 18.1 Team Reflection

What did your team do well?  
What slowed you down?  
How well did you manage time, tasks, and responsibilities?

**Response:**  


## 18.2 Technical Reflection

What did you learn about:

- electronics,
- coding,
- mechanisms,
- fabrication,
- integration?

**Response:**  


## 18.3 Design Reflection

What did you learn about:

- designing ,
- delight,
- clarity,
- physical interaction,
- understanding,
- iteration?

**Response:**  


## 18.4 If You Had One More hour

If granted an additional hour to enhance the system, I would execute the following improvements in serial order to systematically break the current performance bottlenecks:

- **Acquire PYNQ-Z2 or Raspberry Pi for Real-Time Acquisition:**        
   The first priority would be to integrate a dedicated embedded controller to replace the laptop-based UART feed. This would unlock the use of high-speed SPI or AXI-Stream interfaces, eliminating the 1.4-second serial delay and allowing for a live, low-latency video feed.

- **Scale Hardware Parallelism:**       
   With a faster data stream established, I would then refactor the split_logic module into a Wide-Bus Architecture. By expanding the BRAM data width to 128 bits, the FPGA could process 16 pixels in a single clock cycle, fully utilizing the Spartan-7's parallel processing power to match the high-speed input.

- **Implement Live Threshold Tuning:**        
  Finally, I would map the threshold_reg to the on-board slide switches. This would provide a tactile "User Interface" to calibrate the edge-detection sensitivity in real-time, ensuring the hardware remains robust and adaptable to the specific lighting conditions of the demo environment.

---

# 19. Final Submission Checklist

Before submission, confirm that:

- [x] Team details are complete
- [x] Project description is complete
- [x] Inspiration sources are included
- [x] Sketches are added
- [x] BOM is complete
- [x] Purchase list is complete
- [x] Budget summary is complete
- [x] Mechanical planning is documented if applicable
- [ ] App planning is documented if applicable
- [x] Code flowchart is added
- [x] Task breakdown is complete
- [x] Weekly logs are updated
- [x] Risk register is complete
- [x] Testing log is updated
- [x] Playtesting notes are included
- [x] Build photos are included
- [x] Final reflection is written
<img width="1131" height="1600" alt="image" src="" />

---


---


