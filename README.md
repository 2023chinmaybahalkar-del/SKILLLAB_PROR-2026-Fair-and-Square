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
| Nimesh Prabhu         | Research of 2nd Solution      | Implementation of 2nd method | Unquestioning Disciplined Teamwork|

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

<img width="1548" height="746" alt="init" src="https://github.com/user-attachments/assets/4f9c307d-76e2-480a-9ac3-af396b56fdcb" />


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

`The Spartan-7 Boolean Board was selected because it provides a cost-effective yet powerful platform for entry-level hardware acceleration. It contains sufficient Block RAM (BRAM) to store a full 128 times 128 image frame (16,384 bytes), which is critical for our "Receive-Process-Transmit" workflow. Unlike a traditional microcontroller, the FPGA allows us to implement the "Max-Min" edge detection logic in a single clock cycle through spatial parallelism.`


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

Tasks are divided on the basis of skill, experience, and confidence.
- **How tasks are divided:**           
Our team of four will divide responsibilities across the main technical domains. The member most comfortable with digital logic and hardware description will own FPGA development and Verilog design. The member with the strongest software background will own Python scripting, image preprocessing, and serial communication. Protocol design — the UART handshake, command byte structure, and timing decisions — will be a shared responsibility between the hardware and software leads since it sits at the boundary of both domains. Documentation, testing logs, and presentation preparation will be distributed across all four members, with one person designated to consolidate and maintain the final written record.

- **How decisions are made:**                      
Decisions are made by the person who owns that layer. The rest of the team is consulted whenever a change affects more than one domain. No change that crosses a boundary is made unilaterally — both affected members must agree before implementation begins.

- **How progress will be checked:**                         
Progress will be checked against working milestones rather than calendar dates. Our agreed milestones are: UART loopback working, full image transfer and echo working, edge detection returning correct values on test images, and the complete end-to-end pipeline working on a real photograph. Each milestone has a concrete pass condition so there is no ambiguity about whether it has been reached.

- **What happens if a task is delayed:**                    
If one member is blocked, the rest of the team continues on independent layers rather than waiting. When a member is stuck for more than one session, we pair-debug rather than reassign the task — ownership stays with the original member, but the problem is shared.

- **How documentation will be maintained:**                      
One designated member is responsible for keeping the documentation current after every session. All members agree to report what they worked on, what broke, and what was fixed at the end of each meeting so the log stays accurate.


## 10.2 Task Breakdown

| Task ID | Task                    | Owner    | Estimated Hours | Deadline     | Dependency | Status |
| ------- | ----------------------- | -------- | ---------------:| ------------ | ---------- | ------ |
| T1      | Finalize concept    | All | 1.5            | 30th April | None    | Done |
| T2| Initialise RaspberryPi for live feed| Pratyush| 0.25| 30th April| None| Cancelled|
|T3| Learn complete theory| All| Throughout| 30th April| T1| Done|
|T4| Write preprocessing script| Kavish| 0.25|30th April|T3|Done|
|T5| Implement picture transfer over UART bw Laptop and FPGA| Kavish| 1|30th April|T1|Done|
|T6| Block Design method Implementation| Pratyush and Nimesh|2|30th April|T1|Ongoing|
|T7| Write and implement logic by RTL method| Kavish| 2|30th April|T5| Done|
|T8| Maintain Github Repository and manage between members|Chinmay|Throughout|1st May|All|Done|


## 10.3 Responsibility Split

| Area                 | Main Owner     | Support Owner |
| -------------------- | ----------     | ------------- |
| Concept              | `[Pratyush]`  | `[Chinmay & Nimesh]`     |
| Electronics          | `[Kavish]`           | `[Nimesh]`          |
| Coding               | `[Kavish]`           | `[-]`          |
| Alternative     | `[Pratyush]`           | `[Nimesh]`          |
| Testing              | `[Kavish]`           | `[Pratyush]`          |
| Documentation        | `[Chinmay]`           | `[Kavish]`          |

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
- [ ] Basic feasibility tested

### Bi Hour 2 — Build Subsystems

Expected outcomes:

- [ ] Electronics tests completed
- [ ] CAD / structure planning completed
- [x] App UI started if needed
- [ ] Mechanical concept tested
- [x] Main subsystems partially working

### Bi Hour 3 — Integrate

Expected outcomes:

- [x] Physical body built
- [x] Electronics integrated
- [x] Code connected to hardware
- [ ] App connected if required
- [ ] First playable version exists

### Bi Hour 4 — Refine and Finish

Expected outcomes:

- [x] Technical bugs reduced
- [x] Playtesting completed
- [x] Improvements made
- [ ] Documentation completed
- [x] Final build ready

## 12.2  Update Log

| Days   | Planned Goal   | What Actually Happened | What Changed   | Next Steps     |
| ------ | -------------- | ---------------------- | -------------- | -------------- |
| 30th April | Learn the method | Partially started implementation         | Divided team into 2 | Parallel working |
| 30th April | Initialise webcam feed | Returned RaspberryPi         | No Real time implementation | Change protocol from SPI to UART |
| 30th April | Send, Store and Recieve image on FPGA | Took a lot of time and faced lot of issues         | Looking for alternatives | Alternative Implementation|
| 30th April| Complete Primary Implementation | Done         | Confidence boosted | Improve Results |

---

# 13. Risks and Unknowns

## 13.1 Risk Register

| Risk                                                            | Type         | Likelihood | Impact   | Mitigation Plan                                                                       | Owner                |
| --------------------------------------------------------------- | ------------ | ---------- | -------- | ------------------------------------------------------------------------------------- | -------------------- |
| UART byte drop during image transmission       | Technical  | Medium   | High   | Send in 128-byte chunks with 15ms inter-chunk delay; FPGA stores all bytes before processing begins | Kavish           |
| Board boot messages corrupting RX buffer|Technical|High|High|Python waits 3s on startup and flushes buffer before sending any data; FPGA ignores first 500ms via boot delay counter|Kavish|
|Spartan-7 BRAM insufficient for dual buffer|Technical|Low|Medium|XC7S50 has 2700Kb BRAM; frame buffer (128KB) + result buffer (4KB) uses well under 10% of available BRAM|Pratyush|



## 13.2 Biggest Unknown Right Now

The single biggest uncertainty is spatial resolution versus detection accuracy. The current 1×4 horizontal block architecture means the system is blind to vertical edges — a sharp transition between a dark pixel and a bright pixel in the same column across two rows produces no response at all. It is unclear whether shrinking the block further (to 1×2 or even per-pixel comparison) would produce cleaner edges or just amplify noise from UART transmission errors and JPEG compression artifacts. The threshold is a single global value applied uniformly across the entire image, so a low threshold that catches faint edges in dark regions simultaneously floods bright textured regions with false positives. Whether a more spatially aware algorithm can be implemented within the BRAM and logic constraints of the Spartan-7 without fundamentally redesigning the pipeline remains an open question.

---

# 14. Testing 

## 14.1 Technical Testing Plan

| What Needs Testing     | How You Will Test It                                                                 | Success Condition                                                                                    |
| ---------------------- | ------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------- |
|UART RX TX - single byte| Send 0xAB from Python, read response back using simple echo design|Received byte matches sent byte exactly|
|UART RX TX — full image transfer|Send 16384 bytes, echo entire buffer back, compare with original in Python| Perfect match|
|Boot garbage isolation| Open serial port, wait 3s, read and print all bytes before flushing| Discarded bytes are non-zero ASCII text; port is clean after flush|
|FSM state progression|Watch LED display while Python runs full pipeline|LEDs advance through states 0→1→2→3→4→5→6→7→8 and return to 1 without freezing|
## 14.2 Testing and Debugging Log

| Date          | Problem Found                         | Type         | What You Tried                                | Result               | Next Action                                    |
| ------------- | ------------------------------------- | ------------ | --------------------------------------------- | -------------------- | ---------------------------------------------- |
|30th April|FPGA echoed wrong bytes |Logic bug|Inspected top_level.v — TX was reading addr_ptr after it had already been incremented by RX|Identified race condition: TX was sending the next address not the current one|Redesign as two-phase FSM: receive all bytes first, then transmit all bytes|
|30th April|Transfer stalled at 8192 bytes|Timing bug|Added progress prints to Python; checked addr_ptr bit width in Verilog|TX firing simultaneously with RX was corrupting flow; Python sending too fast for UART to handle|Reduce chunk size to 64 bytes; add inter-chunk delay; separate RX and TX phases|
|30th April|debug_result.png was completely black|Logic bug|Printed np.unique(results) — all values were ASCII text characters not 0 or 1|Board boot messages flooding serial buffer before Python could flush them|Add 3s sleep on Python startup before flushing; add 500ms boot delay counter in FPGA|
|30th April|Received 3927 bytes instead of 1024 |Protocol bug|Decoded raw bytes — saw [CMD] and [INFO] strings — recognised as board bootloader output|Serial port was receiving board debug messages, not FPGA results|Implement boot delay in FPGA; flush serial buffer in Python after 3s wait|
|30th April|Edge map showed recognisable edges on test image|—|Ran full pipeline with threshold = 30 on bull.jpeg|4096 bytes received; unique values [0, 1]; edge map displayed correct outlines|Tune threshold; test with additional images|
|30th April|Wanted finer edge resolution|Algorithm limitation|Reduced block size from 16 to 4 pixels — updated pixel_buffer, split_logic and top_level|Spatial resolution improved from 16×1 to 4×1 pixel blocks; edge map noticeably sharper|Accept as current resolution limit; note vertical edge blindness as known limitation|


## 14.3 Playtesting Notes

`-`

# 15. Build Documentation

## 15.1 Fabrication Process(if any)
 
`-`

# 16 Build Photos

Final Output

<img width="325" height="192" alt="op" src="https://github.com/user-attachments/assets/b6721b45-7428-465d-b188-69ccdca735de" />

<img width="334" height="213" alt="output" src="https://github.com/user-attachments/assets/82722fbf-79a2-4e2a-8070-9f2bcc6c5792" />


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

The team really had the will to work and make it work. Upon failure during implementation, two members of the team started from scratch a different implementation method while the first member was troubleshooting the primary method.       
We could have been faster, but nothing was slowing us down.       
Task division started to take shape with passing time. Members took responsibilities for the tasks assigned to them without any excuses or arguements.


## 18.2 Technical Reflection

**Electronics:**       
The most important lesson was that digital signals have timing, not just values. A wire carrying a 1 means nothing without knowing when that 1 is valid relative to a clock edge. The entire debugging journey — dropped bytes, black images, stalled transfers — traced back to assuming signals were stable when they were still in transition. The CDC synchronizer in split_logic exists precisely because crossing clock domains without synchronization produces failures that look random but are deterministic.         

**Coding:**          
Hardware description is not software. Writing Verilog looks like writing code but the mental model has to be completely different — every always block runs simultaneously, every assignment has a propagation delay, and a bug does not throw an exception, it silently corrupts data across thousands of cycles. The discipline of defaulting every register at the top of an always block (setting tx_start <= 0 and pixel_valid <= 0 before the case statement) eliminated an entire class of latching bugs that were previously invisible.         

**Mechanisms:**          
The UART protocol itself is a mechanism — a carefully timed sequence of high and low voltages that only means anything if both ends agree on the bit period. Implementing it from scratch in Verilog rather than using an IP core made that visible. The 868-cycle bit period at 100MHz for 115200 baud is not a magic number — it is a physical timing relationship between the oscillator on the board and the baud rate generator in the laptop's USB chip.        

**Fabrication:** -    

**Integration:**          
The hardest integration problem was not connecting modules together — it was making them agree on timing. The pixel buffer fires block_ready for exactly one clock cycle. The split logic needs that signal to have crossed three synchronizer flip-flops before it acts on it. The FSM needs to wait long enough after feeding the last pixel before reading the result. Getting all three layers to agree required understanding each module's timing independently before connecting them.


## 18.3 Design Reflection

**Designing:**         
The most durable design decision was keeping the FSM strictly sequential — receive everything, then process everything, then transmit everything. Every attempt to overlap these phases to save time introduced race conditions that were harder to debug than the time saved was worth. Good hardware design, like good system design generally, benefits from clear phase boundaries even at the cost of throughput.      

**Delight:**        
The first time a recognisable shape appeared in the edge map — even the coarse blocky version — was disproportionately satisfying relative to what the algorithm actually does. A few comparators and a subtractor, run 4096 times, produced something that looked like vision. That gap between the simplicity of the mechanism and the meaningfulness of the output is where the delight lives.         

**Clarity:**           
Every time something broke, the fix required making something more explicit — adding a dedicated state instead of relying on implicit timing, adding an LED display instead of guessing FSM position, adding a stall detector instead of waiting indefinitely. Clarity in hardware is not a style preference, it is a functional requirement. Ambiguous timing causes ambiguous behavior.         

**Physical interaction:**        
The USB cable is invisible as an interaction but it is doing significant work — carrying a custom protocol with a sentinel byte, a configuration byte, 16384 data bytes, and 4096 result bytes, all correctly sequenced and timed. Designing that protocol carefully (reserving 0xFF, chunking sends to respect baud rate, flushing boot garbage before communicating) made the physical layer reliable. The interaction the user sees — run script, image appears — is clean precisely because the physical layer underneath it is explicit.         

**Understanding:**         
Understanding came from failure, not from reading. The UART dropping bytes was not understood until the timing math was done by hand. The black edge map was not understood until the raw byte values were printed. The stall at 1024 bytes was not understood until the Vivado caching behavior was identified. Every real understanding in this project was earned by a specific failure that forced a closer look at something previously assumed to be working.           

**Iteration:**              
The project went through approximately six distinct FSM architectures. The early ones were more ambitious — overlapping receive and transmit, ACK handshaking, dynamic threshold updates mid-stream. The final one is the simplest of all of them and the only one that works reliably. Iteration did not add complexity, it removed it. Each cycle of breaking and fixing converged toward a design with fewer states, fewer assumptions, and fewer things that could go wrong.


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
- [x] App planning is documented if applicable
- [x] Code flowchart is added
- [x] Task breakdown is complete
- [x] Weekly logs are updated
- [x] Risk register is complete
- [x] Testing log is updated
- [x] Playtesting notes are included
- [x] Build photos are included
- [x] Final reflection is written

---


---


