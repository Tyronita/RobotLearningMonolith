import cv2
import time

cap = cv2.VideoCapture(1)

frame_count = 0
start_time = time.time()

while True:
    ret, frame = cap.read()
    if not ret:
        print("Failed to grab frame")
        break

    frame_count += 1
    elapsed_time = time.time() - start_time

    if elapsed_time >= 1.0:
        fps = frame_count / elapsed_time
        print(f"FPS: {fps:.2f}")
        frame_count = 0
        start_time = time.time()

cap.release()
