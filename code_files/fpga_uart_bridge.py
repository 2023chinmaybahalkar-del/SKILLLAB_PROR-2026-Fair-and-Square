import serial
import cv2
import numpy as np
import time

PORT     = 'COM9'
BAUD     = 115200
IMG_SIZE = 128
N_BYTES  = IMG_SIZE * IMG_SIZE   # 16384

def preprocess(path):
    img     = cv2.imread(path)
    gray    = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    resized = cv2.resize(gray, (IMG_SIZE, IMG_SIZE), interpolation=cv2.INTER_AREA)
    return np.clip(resized, 0, 254).astype(np.uint8)

def send_and_receive(flat: np.ndarray) -> np.ndarray:
    with serial.Serial(PORT, BAUD, timeout=30) as ser:
        ser.reset_input_buffer()
        ser.reset_output_buffer()

        # ── Send all bytes ────────────────────────────────
        # At 115200 baud, 1 byte = ~86.8us
        # Send in 128-byte rows with a small gap between rows
        print(f"Sending {N_BYTES} bytes...")
        t0 = time.time()

        CHUNK = 128   # one image row at a time
        for i in range(0, N_BYTES, CHUNK):
            ser.write(flat[i : i + CHUNK].tobytes())
            # Wait for this chunk to fully clock out before sending next
            # 128 bytes × 10 bits × (1/115200) = 11.1ms, use 15ms
            time.sleep(0.015)
            if i % 2048 == 0:
                print(f"  Sent {i}/{N_BYTES}")

        print(f"Send done in {time.time()-t0:.2f}s")
        print("Waiting for FPGA to finish receiving & start TX...")

        # Give FPGA a moment to finish writing last byte and enter TX
        time.sleep(0.5)

        # ── Receive all bytes ─────────────────────────────
        received = bytearray()
        stall_t  = time.time()
        deadline = time.time() + 30

        while len(received) < N_BYTES:
            w = ser.in_waiting
            if w:
                received += ser.read(w)
                stall_t   = time.time()
                print(f"\r  Received {len(received)}/{N_BYTES}", end='', flush=True)
            else:
                if time.time() - stall_t > 4.0:
                    print(f"\nStalled at {len(received)} bytes.")
                    break
                if time.time() > deadline:
                    print(f"\nTimeout at {len(received)} bytes.")
                    break
                time.sleep(0.001)

        print(f"\nTotal: {len(received)}/{N_BYTES} bytes")
        return np.frombuffer(bytes(received[:N_BYTES]), dtype=np.uint8)

if __name__ == "__main__":
    flat   = preprocess(r"C:\Users\Kavish\Downloads\bull.jpeg").flatten()
    result = send_and_receive(flat)

    if len(result) == N_BYTES:
        img_out  = result.reshape((IMG_SIZE, IMG_SIZE))
        out_path = r"C:\Users\Kavish\Downloads\debug_result.png"
        cv2.imwrite(out_path, img_out)

        diff = flat.astype(int) - result.astype(int)
        print(f"Max diff : {np.abs(diff).max()}")
        print(f"Mean diff: {np.abs(diff).mean():.4f}")
        if np.abs(diff).max() == 0:
            print("PERFECT MATCH — BRAM loopback working.")

        cv2.imshow("FPGA Echo", img_out)
        cv2.waitKey(0)
        cv2.destroyAllWindows()
    else:
        print("Transfer incomplete.")
