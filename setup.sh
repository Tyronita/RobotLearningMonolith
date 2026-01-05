
# Optional - so-101: URDF for simulation and STL for 3D printed parts
git clone https://github.com/TheRobotStudio/SO-ARM100/tree/main/Simulation/SO101

# Install Lerobot Enhttps://huggingface.co/docs/lerobot/en/installation
git clone https://github.com/huggingface/lerobot.git
cd lerobot

# Install mini-forge
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh

# Install conda environment
conda create -y -n lerobot python=3.10

# Activate Lerobot
conda activate lerobot

# Install ffmpeg and conda forge
conda install ffmpeg -c conda-forge

# Install lerobot dependencies
pip install -e .

# Install Callibration software
pip install -e ".[feetech]"

#Access our Scripts
cd ..

#Find ports
lerobot-find-port

# Setup camera connections: https://huggingface.co/docs/lerobot/en/cameras#setup-cameras

# Outputs connected camera ids
lerobot-find-cameras opencv # [realsense if depth cams]

#Take photos from all connected cameras -> outputs/captured_images/opencv_{id}.png
python output_camera_connections.py

# Callibration: https://huggingface.co/docs/lerobot/en/so101
# Run Callibrate Bots Propricoeptive Sensors -- such as position sensors and motion sensors, monitor how the car moves over time. T
python calibrate_so_101s.py 
# Outputs Port Names

# COM5 -- follower
C:\Users\evano\.cache\huggingface\lerobot\calibration\robots\so101_follower\my_awesome_follower_arm.json

# COM6 -- leader
C:\Users\evano\.cache\huggingface\lerobot\calibration\robots\so101_follower\my_awesome_leader_arm.json

# Record Dataset
python record_teleoperated_dataset.py

# Train Policy
#TODO

# Inference on Policy
#TODO