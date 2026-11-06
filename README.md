# Roblox Flight Script

Skybound Flight is a Roblox flight script that lets a player toggle camera-relative flight, steer with the keyboard, move vertically, and boost while holding Shift. It runs as a client-side LocalScript in Roblox Studio.

## Install

1. Open your experience in Roblox Studio.
2. In Explorer, open StarterPlayer, then StarterPlayerScripts.
3. Insert a LocalScript.
4. Copy the contents of `FlightController.client.lua` into the LocalScript.
5. Start a play test.

## Use

- Press F to toggle flight on or off.
- Use W and S to move forward or backward relative to the camera.
- Use A and D to move left or right relative to the camera.
- Hold Space to move upward and LeftControl to move downward.
- Hold LeftShift or RightShift to boost while flying.
- To adjust the controls or movement, change `TOGGLE_KEY`, `NORMAL_SPEED`, `BOOST_SPEED`, or `ACCELERATION` near the top of the script.

This is a client-side controller for use in your own Roblox experience. Add server-side permission checks if your experience requires them.

---

More Roblox script projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/1baf7f85-cb20-4be0-a7b8-a456024e478d?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=1baf7f85-cb20-4be0-a7b8-a456024e478d
