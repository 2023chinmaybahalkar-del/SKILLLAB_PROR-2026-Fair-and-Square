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
| `[Video]`   | `https://www.instagram.com/reel/DW4CT7WCDry/?igsh=cXg3dzAxYmdncDBo` | `How projection mapping can be used to create interactive digital + physical experiences` |
|             |                                                                     |                                                                                           |
|             |                                                                     |                                                                                           |

## 2.2 Original Twist

The originality of this project lies in the move away from traditional software-based image filters toward a custom-tailored hardware pipeline. While most edge detection is performed using high-level software libraries (like OpenCV) on a CPU, this project recreates that functionality at the gate level.The key original aspects include:
- Custom "Max-Min" Hardware Logic: Instead of using resource-heavy Sobel or Canny kernels that require complex multiplication and large memory buffers, this project uses a streamlined range-based algorithm. By calculating the difference between the maximum and minimum intensity in a $1 \times 4$ pixel block, the system achieves edge detection using only comparators and subtractors, significantly reducing the FPGA resource footprint.
- Hardware-Software Handshaking: The project implements a unique UART-coupled FSM (Finite State Machine). The FPGA doesn't just run a loop; it remains in a reactive state, waiting for a specific command byte ($0xFF$) and a dynamic threshold value from the host. This allows the user to tune the hardware's sensitivity in real-time from the Python interface without needing to re-synthesize the Verilog code.

---

# 3. Project Intent

## 3.1 User Journey 

Priya is a third-year ECE student who has heard about FPGAs but never seen one do anything visual. She plugs the Boolean Board into her laptop via USB, opens a terminal, and runs a single Python script. The script asks for nothing — it preprocesses a photo of a spinning top, waits three seconds for the board to boot, then starts streaming pixel data over the serial port. She watches the progress counter tick upward: 4096, 8192, 12288, 16384 pixels sent. A second later, a window pops up. On the left is the original grayscale photo. On the right is a clean black-and-white edge map — the outline of the top, its stem, its shadow — all detected not by any software algorithm but by logic gates running at 100 million cycles per second inside the chip on the board in front of her. She changes the threshold from 30 to 15 and runs it again. More edges appear. She changes the image to a photo of her face. The FPGA doesn't know or care — it just processes pixels.

---

# 4. Definition of Success

## 4.1 Definition of “Usable”

The project is considered "usable" when it achieves a reliable end-to-end data cycle between the host PC and the FPGA hardware.
- Successful Handshaking: The FPGA must correctly identify the $0xFF$ start command and update its internal threshold register based on the user's input from the Python script.
- Data Integrity: The system must transmit, process, and return a full $128 \times 128$ image frame without dropping pixels or stalling during the UART transfer.
- Visual Accuracy: The resulting binary map must clearly represent the high-contrast boundaries of the original image, confirming that the "max-min" logic is functioning as intended.
- Repeatability: The user must be able to run the process multiple times with different threshold values without needing to reset the FPGA hardware manually.


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
- [x] Installation
- [ ] Other:

## 5.2 High-Level System Description

Explain how the system works in simple terms.

## 5.2 High-Level System Description

Explain how the system works in simple terms.

- **Input:** The input process begins on a host PC. A Python script takes a standard digital image (e.g., JPEG or PNG) and performs two main tasks
  - **Preprocessing:** It converts the image to grayscale and resizes it to a $128 \times 128$ resolution to fit within the FPGA's memory constraints.
  - **Transmission:** The PC sends a "start" command ($0xFF$) followed by a user-defined sensitivity threshold and the raw pixel data via a USB-to-UART serial interface.
- **Processing:** Once the data enters the Spartan-7 FPGA, the internal logic takes over
  - **Storage:** The incoming pixels are stored in a Frame Buffer (BRAM).Buffering: A "Pixel Buffer" module groups the raw data into blocks of four pixels.
  - **Edge Detection Logic:** The system calculates the difference between the brightest and darkest pixel in each block. If this difference is greater than the user's threshold, the block is flagged as an "edge."
  - **Control:** A Finite State Machine (FSM) coordinates the timing to ensure pixels are processed only after they have been fully received.
- **Output:** After processing, the FPGA generates a binary edge map.Serialization: The FSM sends the results (1 for an edge, 0 for flat ground) back through the UART TX module.
  - **Reconstruction:** The Python script receives these bytes and reconstructs them into a $128 \times 128$ image.
  - **Display:** The final output is a side-by-side visual comparison on the PC screen showing the original image and the detected hardware-generated edges.
- **Physical Structure:** The physical setup consists of:
  - **Boolean Board:** A Spartan-7 FPGA board which houses the programmable logic, memory, and clock source.
  - **Communication Link:** A Micro-USB cable connecting the board to the PC, serving as the UART serial bridge.
  - **PC:** Preprocessing and Host side control.
- **App Interaction:** Interaction occurs through the Python Terminal and GUI. The user interacts with the system by modifying the THRESHOLD variable in the script. The Python application manages the "handshake," informing the user when the board has finished booting, showing the progress of pixel transmission, and finally launching a window to display the processed result.

## 5.3 Input / Output Map

| System Part                              | Type            | What It Does                                                               |


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

Add a sketch with labels showing:

- structure,
- electronics placement,
- user touch points,
- moving parts,
- output elements.

**Insert image below:**  
`[Upload image and link here]`
<img width="1600" height="1200" alt="image" src="https://github.com/user-attachments/assets/95637f31-b4e7-4427-a9e1-4b63fbeb0ac5" />

## 6.3 Approximate Dimensions

| Dimension        | Value   |
| ---------------- | ------- |
| Length           | `16 cm` |
| Width            | `16 cm` |
| Height           | `8 cm`  |
| Estimated weight | `400 g` |

---

# 7. Electronics Planning

## 7.1 Electronics Used

| Component                 | Quantity | Purpose                               |
| ------------------------- | --------:| ------------------------------------- |
| `FPGA`                  | `1`      | `Main logic`                   |
| `Laptop`                | `1`      | `Controller`                        |


## 7.2 Wiring Plan

`The FPGA is connected to Laptop via the UART/PWR Port, which is micro-USB type connection on FPGA end and USB-A type connection on Laptop end.

## 7.3 Circuit Diagram/architecture diagram

Insert a hand-drawn or software-made circuit diagram.

**Insert image below:**  
`[Upload image and link here]`
<img width="867" height="1156" alt="" src="" />


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

Describe what the code must do.

Include:

- startup behavior,
- input handling,
- sensor reading,
- decision logic,
- output behavior,
- communication logic,
- reset behavior.

**Response:**  
`

- **Sample Startup behavior:**  
  The Raspi/FPGA initializes motor pins, PWM control, and starts a WiFi access point with a web server. The laptop initializes camera input, tracking system, and projection mapping.
- **Input handling:**  
  Movement commands are received from the laptop (pygame sends http requests)
- **Sensor reading:**  
  The camera continuously captures frames, and OpenCV detects ArUco markers to determine the car’s position and orientation.
- **Decision logic:**  
  The system maps the car’s position into a virtual coordinate system and checks for nearby obstacles or collisions. If movement is valid, the command is allowed; if not, it is blocked or replaced with a feedback action (like a slight shake).
- **Output behavior:**  
  The ESP32 drives the motors using PWM signals to control speed and direction. The projector displays the updated game environment, including obstacles, targets, and feedback visuals.
- **Communication logic:**  
  The laptop sends HTTP requests (e.g., `/forward`, `/left`) to the ESP32 over WiFi. The ESP32 parses these commands and executes motor actions.
- **Reset behavior:**  
  If no command is received within a short timeout, the ESP32 stops the motors. The game resets when a level is completed or restarted.`

## 8.3 Code Flowchart

Insert a flowchart showing your code logic.

Suggested sequence:

- start,
- initialize,
- wait for input,
- read input,
- decision,
- trigger output,
- repeat or reset,
- error handling.

**Insert image below:**  
<img width="1600" height="1200" alt="image" src="" />
<img width="1600" height="1200" alt="image" src="" />




# 9. Bill of Materials

## 9.1 Full BOM

| Item                             | Quantity | In Kit? | Need to Buy? | Estimated Cost | Material / Spec               | Why This Choice?          |
| -------------------------------- | --------:| ------- | ------------ | --------------:| ----------------------------- | ------------------------- |
| `[RASPI]`                        | `1`      | `Yes`   | `No`         | `0`            | `38 Pin ESP32`                | `[To control components]` |
| `[Motor Driver]`                 | `[1]`    | `[Yes]` | `[No]`       | `0`            | `[LN296]`                     | `[To drive both motors]`  |
| `[DC Motors and wheel]`          | `[2]`    | `[No]`  | `[Yes]`      | `[150]`        | `[BO Motors and 6 cm wheels]` | `[high torque motors]`    |
| `[Buck Converter]`               | `[1]`    | `[No]`  | `[Yes]`      | `[75]`         |                               |                           |
| `[Li-ion batteries with holder]` | `[1]`    | `[No]`  | `[Yes]`      | `[200]`        |                               |                           |

## 9.2 Material Justification

Explain why you selected your main materials and components.

**Response:**  
`DC motors (BO motors) were chosen instead of servos or steppers because the system requires continuous rotation for movement rather than precise angular control (Previously, we were considering using steppers as we were planning on tracking movement on the ESP using its relative position from an origin, but since we're using a camera now, this is not required). A motor driver (L298N) was used to allow bidirectional control and speed variation using PWM.`


## 9.3 Items You chose

| Item                 | Why Needed               | Purchase Link | Latest Safe Date to Procure | Status       |
| -------------------- | ------------------------ | ------------- | --------------------------- | ------------ |
| `BO Motors + Wheels` | `Drive system for car`   | `robu.in`     | `15th April`                | `[Received]` |
| `Buck Converter`     | `Stable power for ESP32` | `local store` | `before testing`            | `[Received]` |
| `Li-ion Batteries`   | `Portable power`         | `local store` | `before testing`            | `Recieved`   |

## 9.4 Budget Summary

| Budget Item           | Estimated Cost              |
| --------------------- | ---------------------------:|
| Electronics           | `[400]`                     |
| Mechanical parts      | `[200]`                     |
| Fabrication materials | `[0 (Available on campus)]` |
| Purchased extras      | `[0]`                       |
| Contingency           | `[300]`                     |
| **Total**             | `[900]`                     |

## 9.5 Budget Reflection

If your cost is too high, what can be simplified, removed, substituted, or shared?

**Response:**  

---

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

| Tester      | What They Did                        | What Confused Them                    | What They Enjoyed                         | What You Will Change                          |
| ----------- | ------------------------------------ | ------------------------------------- | ----------------------------------------- | --------------------------------------------- |
| `Gopal` | `Tried navigating through obstacles` | `Some obstacles ewren't clear enough` | `Liked projection + real car interaction` | `Add a slight red highlight around obstacles` |


---

# 15. Build Documentation

## 15.1 Fabrication Process(if any)

Describe how the project was physically made.

Include:

- cutting,
- 3D printing,
- assembly,
- fastening,
- wiring,
- finishing,
- revisions.

**Response:**  
`The fabrication process involved designing, manufacturing, assembling, and refining both the physical structure and electronic integration of the system.`

`Design (CAD Modeling):
The initial model was created using CAD software, where components were designed based on the actual dimensions of the electronic parts. This ensured accurate fitting and minimized errors during assembly.
Cutting (Laser Cutting):
The designed parts were fabricated using laser cutting techniques. Sheets were cut precisely according to the CAD model to create the structural base and mounts for components.`

`Components were fixed using adhesives and mechanical supports. Certain parts were intentionally kept modular (not permanently fixed) to allow easy replacement and modification of electronics.
Surface Finishing:
Some parts were sanded to smooth rough edges after cutting. Sawdust mixed with adhesive was used to fill gaps and uneven edges, improving structural finish. The final structure was then painted for better aesthetics and durability.`

`Environment Setup (Dark Room Fabrication):
To enhance projection visibility, a controlled dark environment was created using Z-boards, paper sheets, and bedsheets. This minimized external light interference and improved projection clarity.
Revisions and Iterations:
Multiple adjustments were made throughout the process, including refining alignment, improving structural stability, repositioning components, and optimizing the interaction between the physical car and projected environment.`

## 16 Build Photos

Add photos throughout the project.

Suggested images:

- early sketch,
- prototype,
- electronics testing,
- mechanism test,
- app screenshot,
- final build.
- <img width="960" height="1280" alt="WhatsApp Image 2026-04-24 at 9 46 02 AM (1)" src="https://github.com/user-attachments/assets/74baa570-5770-483e-be6d-d2f03386e37c" />





# 17. Final Outcome

## 17.1 Final Description

Describe the final version of your project.

**Response:**  


## 17.2 What Works Well



## 17.3 What Still Needs Improvement


## 17.4 What Changed From the Original Plan

How did the project change from the initial idea?

**Response:**  


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

What would you improve next?

**Response:**  

` `

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


