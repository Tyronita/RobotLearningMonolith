from lerobot.robots.so101_follower import SO101FollowerConfig, SO101Follower
from lerobot.teleoperators.so101_leader import SO101LeaderConfig, SO101Leader

config = SO101FollowerConfig(
    port="COM6", # COM6 (on windows) 
    id="gertrude",
)

follower = SO101Follower(config)
follower.connect(calibrate=False)
follower.calibrate()
follower.disconnect()

so101_leader_config = SO101LeaderConfig(
    port="COM5", # COM5
    id="jensen",
)
leader = SO101Leader(so101_leader_config)
leader.connect(calibrate=False)
leader.calibrate()
leader.disconnect()