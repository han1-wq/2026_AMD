from launch import LaunchDescription
from launch.substitutions import EnvironmentVariable
from ament_index_python.packages import get_package_share_directory
import launch.actions
import launch_ros.actions
from launch_ros.actions import Node
from launch.actions import RegisterEventHandler
from launch.event_handlers import OnProcessExit
from launch.events import Shutdown
import os


def generate_launch_description():
    rviz_config = os.path.join(
        get_package_share_directory('slam_gmapping'),
        'rviz',
        'slam.rviz'
    )

    use_sim_time = launch.substitutions.LaunchConfiguration('use_sim_time', default='false')

    rviz_node = Node(
        package='rviz2',
        executable='rviz2',
        name='rviz2',
        arguments=['-d', rviz_config]
    )

    slam_node = launch_ros.actions.Node(
        package='slam_gmapping', executable='slam_gmapping', output='screen', parameters=[{'use_sim_time':use_sim_time}])

    # rviz关闭时，触发整个launch退出，slam也会随之关闭
    rviz_exit_handler = RegisterEventHandler(
        event_handler=OnProcessExit(
            target_action=rviz_node,
            on_exit=[launch.actions.EmitEvent(event=Shutdown())]
        )
    )

    return LaunchDescription([
        rviz_node,
        slam_node,
        rviz_exit_handler,
    ])
