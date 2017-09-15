# Elixir based WebRTC Peer-to-peer signaling server #
> Using Phoenix Channels

## Progress ##
The project is in progress. 

## Currently working: ##
* Single room live WebRTC P2P negotiation with 2 peers
* Message broadcasting between clients without using WebRTC data channels _(using Phoenix Channels instead)_
* Handling entrance and closing diffs via Phoenix Presence module

In progress:
* Maintaining peer negotiation state at GenServer and/or Phoenix Presence module
* Creating proper fallback methods for 
* Expanding channels and routes to a multi-channel infrastructure with automatic redirecting
* Optimizing supervisor tree for more robust deployment
* Writing proper documentation and tests
* Redundant code cleanup & codebase improved structuring
* _(Adding Ecto models for PostgreSQL to maintain permanent nicknames and avatars)_