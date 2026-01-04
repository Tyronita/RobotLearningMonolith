
git submodule update --init --recursive
cd lerobot

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

@REM Find ports
lerobot-find-port

@REM Run Callibration Script -- run twice for leader and follower and replace port name
@REM https://huggingface.co/docs/lerobot/en/cameras#setup-cameras
lerobot-find-cameras opencv
python calibrate-so-101s.py

@REM COM5 -- follower
C:\Users\evano\.cache\huggingface\lerobot\calibration\robots\so101_follower\my_awesome_follower_arm.json

@REM COM6 -- leader
C:\Users\evano\.cache\huggingface\lerobot\calibration\robots\so101_follower\my_awesome_leader_arm.json

@REM Record Dataset
python record_dataset.py

@REM Train Policy

@REM Inference on Policy