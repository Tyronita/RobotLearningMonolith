
@REM Optional - so-101: URDF for simulation and STL for 3D printed parts
git clone https://github.com/TheRobotStudio/SO-ARM100/tree/main/Simulation/SO101

@REM Install Lerobot Enhttps://huggingface.co/docs/lerobot/en/installation
git clone https://github.com/huggingface/lerobot.git
cd lerobot

@REM Install mini-forge
$arch = if ([Environment]::Is64BitOperatingSystem) { "x86_64" } else { "x86" }

Invoke-WebRequest `
  -Uri "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Windows-$arch.exe" `
  -OutFile "Miniforge3-Windows.exe"

Start-Process -FilePath ".\Miniforge3-Windows.exe"


@REM Install conda environment
conda create -y -n lerobot python=3.10

@REM Activate Lerobot
conda activate lerobot

@REM Install ffmpeg and conda forge
conda install ffmpeg -c conda-forge

@REM Install lerobot dependencies
pip install -e .

@REM Install Callibration software
pip install -e ".[feetech]"

@REM Access our Scripts
cd ..

@REM Find ports
lerobot-find-port

@REM https://huggingface.co/docs/lerobot/en/cameras#setup-cameras

@REM Outputs connected camera ids
lerobot-find-cameras opencv

@REM Take photos from all connected cameras -> outputs/captured_images/opencv_{id}.png
python output_camera_connections.py

@REM Callibration: https://huggingface.co/docs/lerobot/en/so101
@REM Run Callibrate Bots Propricoeptive Sensors -- such as position sensors and motion sensors, monitor how the car moves over time. T
python calibrate_so_101s.py 
@REM Outputs Port Names

@REM COM5 -- follower
C:\Users\evano\.cache\huggingface\lerobot\calibration\robots\so101_follower\my_awesome_follower_arm.json

@REM COM6 -- leader
C:\Users\evano\.cache\huggingface\lerobot\calibration\robots\so101_follower\my_awesome_leader_arm.json

@REM Record Dataset
python record_teleoperated_dataset.py

@REM Train Policy
@REM TODO

@REM Inference on Policy
@REM TODO