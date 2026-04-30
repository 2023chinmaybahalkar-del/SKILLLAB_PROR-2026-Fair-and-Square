import serial
import cv2
import numpy as np
import time

PORT       = 'COM9'
BAUD       = 115200
IMG_SIZE   = 128
N_PIXELS   = IMG_SIZE * IMG_SIZE   # 16384
N_BLOCKS   = N_PIXELS // 4         # 4096
THRESHOLD  = 30
IMAGE_PATH = r"C:\Users\Kavish\Downloads\bull.jpeg"
OUT_PATH   = r"C:\Users\Kavish\Downloads\edge_result.png"

# ── Preprocess ────────────────────────────────────────────
def preprocess(path):
    img     = cv2.imread(path)
    gray    = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    resized = cv2.resize(gray, (IMG_SIZE, IMG_SIZE), interpolation=cv2.INTER_AREA)
    return np.clip(resized, 0, 254).astype(np.uint8)

# ── Send to FPGA, receive results ─────────────────────────
def run_on_fpga(flat, threshold):
    with serial.Serial(PORT, BAUD, timeout=30) as ser:

        # Flush board boot messages
        print("Waiting for boot messages to clear (3s)...")
        time.sleep(3.0)
        discarded = ser.read(ser.in_waiting)
        if discarded:
            print(f"Discarded {len(discarded)} boot bytes.")
        ser.reset_input_buffer()
        ser.reset_output_buffer()
        print("Port clean.\n")

        # Send 0xFF command + threshold
        print(f"[1/4] Sending command + threshold ({threshold})...")
        ser.write(bytes([0xFF, threshold]))
        time.sleep(0.1)

        # Send image row by row
        print(f"[2/4] Sending {N_PIXELS} pixels...")
        CHUNK = 128
        for i in range(0, N_PIXELS, CHUNK):
            ser.write(flat[i : i + CHUNK].tobytes())
            time.sleep(0.015)
            if i % 4096 == 0:
                print(f"      {i}/{N_PIXELS}")
        print(f"      {N_PIXELS}/{N_PIXELS} — done.")

        # Wait for FPGA to process and begin TX
        print("[3/4] Waiting for FPGA processing...")
        time.sleep(1.5)

        # Receive 4096 result bytes
        print(f"[4/4] Receiving {N_BLOCKS} result bytes...")
        received = bytearray()
        stall_t  = time.time()

        while len(received) < N_BLOCKS:
            w = ser.in_waiting
            if w:
                received += ser.read(w)
                stall_t   = time.time()
                print(f"\r      {len(received)}/{N_BLOCKS}", end='', flush=True)
            else:
                if time.time() - stall_t > 5.0:
                    print(f"\n      Stalled at {len(received)} bytes.")
                    break
                time.sleep(0.001)

        print(f"\n      Received {len(received)}/{N_BLOCKS} bytes.")
        return np.frombuffer(bytes(received[:N_BLOCKS]), dtype=np.uint8)

# ── Visualize ─────────────────────────────────────────────
def visualize(flat, results):
    # 128px wide / 4px per block = 32 blocks per row
    # 4096 blocks / 32 = 128 rows — matches image height exactly
    edge_map = np.zeros((IMG_SIZE, IMG_SIZE), dtype=np.uint8)
    for blk in range(len(results)):
        row       = blk // 32
        col_start = (blk %  32) * 4
        if results[blk] == 1:
            edge_map[row, col_start : col_start + 4] = 255

    original = flat.reshape((IMG_SIZE, IMG_SIZE))

    cv2.imwrite(OUT_PATH, edge_map)
    print(f"\nSaved → {OUT_PATH}")
    print(f"Edge blocks  : {np.sum(results == 1)}/{N_BLOCKS} ({100*np.mean(results==1):.1f}%)")
    print(f"Flat blocks  : {np.sum(results == 0)}/{N_BLOCKS}")
    print(f"Unique values: {np.unique(results)}")
    print(f"First 20     : {list(results[:20])}")

    combined = np.hstack([original, edge_map])
    cv2.imshow(f"Original | Edge Map  [threshold={THRESHOLD}]", combined)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

# ── Main ──────────────────────────────────────────────────
if __name__ == "__main__":
    print("=== FPGA Edge Detection ===\n")
    flat    = preprocess(IMAGE_PATH).flatten()
    print(f"Image preprocessed: {flat.shape[0]} bytes\n")

    results = run_on_fpga(flat, THRESHOLD)

    if len(results) == N_BLOCKS:
        visualize(flat, results)
    else:
        print(f"Incomplete — got {len(results)}/{N_BLOCKS}.")
        print(f"Unique values: {np.unique(results)}")