extends Node
## Game State

## Space wagon states
enum {
	## Wide-eyed and bushy tailed
	Ready_To_Start,
	## At a waypoint, not moving
	Stopped_At_Waypoint,
	## In between waypoints, not moving
	Stopped_In_Space,
	## Moving between waypoints
	Traveling
}
