import logging
import time
from dataclasses import asdict
from pprint import pformat

import rerun as rr

from lerobot.cameras.opencv.configuration_opencv import OpenCVCameraConfig, ColorMode, Cv2Rotation
from lerobot.configs import parser
from lerobot.processor import make_default_processors
from lerobot.robots import make_robot_from_config, so101_follower
from lerobot.robots.so101_follower import SO101FollowerConfig
from lerobot.teleoperators import make_teleoperator_from_config, so101_leader
from lerobot.teleoperators.so101_leader import SO101LeaderConfig
from lerobot.utils.import_utils import register_third_party_plugins
from lerobot.utils.utils import init_logging
from lerobot.utils.visualization_utils import init_rerun

# Import the teleop_loop function from the original script
from lerobot.scripts.lerobot_teleoperate import teleop_loop


def main():
    # Initialize logging
    init_logging()
    
    # Configure camera
    camera_config = {
        "gripper_cam": OpenCVCameraConfig(
            index_or_path=0, 
            width=640,
            height=480,
            fps=26.000026000026,
            color_mode=ColorMode.RGB,
            rotation=Cv2Rotation.NO_ROTATION,
            fourcc="YUY2"
        ),
        "exocentrc_cam": OpenCVCameraConfig(
            index_or_path=1, 
            width=640,
            height=480,
            fps=30.00003000003,
            color_mode=ColorMode.RGB,
            rotation=Cv2Rotation.NO_ROTATION,
            fourcc="YUY2"
        )
    }
    
    # Configure follower robot
    follower_cfg = SO101FollowerConfig(
        port="COM5",
        id="my_awesome_follower_arm",
        cameras=camera_config
    )
    
    # Configure leader teleoperator
    leader_cfg = SO101LeaderConfig(
        port="COM6",
        id="my_awesome_leader_arm"
    )
    
    # Display configuration
    logging.info("Follower Configuration:")
    logging.info(pformat(asdict(follower_cfg)))
    logging.info("Leader Configuration:")
    logging.info(pformat(asdict(leader_cfg)))
    
    # Initialize Rerun for visualization
    display_data = True
    if display_data:
        init_rerun(session_name="teleoperation")
    
    # Create robot and teleoperator instances
    teleop = make_teleoperator_from_config(leader_cfg)
    robot = make_robot_from_config(follower_cfg)
    
    # Create default processors
    teleop_action_processor, robot_action_processor, robot_observation_processor = make_default_processors()
    
    # Connect to devices
    teleop.connect()
    robot.connect()
    
    try:
        # Run teleoperation loop
        teleop_loop(
            teleop=teleop,
            robot=robot,
            fps=60,  # Control frequency
            display_data=display_data,
            duration=None,  # Run indefinitely until interrupted
            teleop_action_processor=teleop_action_processor,
            robot_action_processor=robot_action_processor,
            robot_observation_processor=robot_observation_processor,
        )
    except KeyboardInterrupt:
        logging.info("Teleoperation interrupted by user")
    finally:
        # Clean up
        if display_data:
            rr.rerun_shutdown()
        teleop.disconnect()
        robot.disconnect()
        logging.info("Teleoperation ended")


if __name__ == "__main__":
    register_third_party_plugins()
    main()