-- Place this LocalScript in StarterPlayer > StarterPlayerScripts.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local TOGGLE_KEY = Enum.KeyCode.F
local UP_KEY = Enum.KeyCode.Space
local DOWN_KEY = Enum.KeyCode.LeftControl
local NORMAL_SPEED = 70
local BOOST_SPEED = 140
local ACCELERATION = 8

local character
local humanoid
local rootPart
local flightConnection
local bodyVelocity
local bodyGyro
local flying = false
local boostHeld = false
local pressedKeys = {}

local function refreshCharacter(newCharacter)
	character = newCharacter
	humanoid = character:WaitForChild("Humanoid")
	rootPart = character:WaitForChild("HumanoidRootPart")
	flying = false
	boostHeld = false
	pressedKeys = {}
end

local function removeFlightObjects()
	if flightConnection then
		flightConnection:Disconnect()
		flightConnection = nil
	end

	if bodyVelocity then
		bodyVelocity:Destroy()
		bodyVelocity = nil
	end

	if bodyGyro then
		bodyGyro:Destroy()
		bodyGyro = nil
	end
end

local function stopFlying()
	if not flying then
		return
	end

	flying = false
	removeFlightObjects()

	if humanoid and humanoid.Parent then
		humanoid.PlatformStand = false
		humanoid.AutoRotate = true
	end
end

local function startFlying()
	if flying or not character or not humanoid or not rootPart then
		return
	end

	if humanoid.Health <= 0 then
		return
	end

	flying = true
	humanoid.PlatformStand = true
	humanoid.AutoRotate = false

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Name = "FlightVelocity"
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyVelocity.P = 10000
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.Parent = rootPart

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.Name = "FlightGyro"
	bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	bodyGyro.P = 10000
	bodyGyro.D = 500
	bodyGyro.CFrame = rootPart.CFrame
	bodyGyro.Parent = rootPart

	flightConnection = RunService.RenderStepped:Connect(function(deltaTime)
		if not flying or not rootPart or not rootPart.Parent then
			stopFlying()
			return
		end

		local camera = workspace.CurrentCamera
		if not camera then
			return
		end

		local direction = Vector3.zero
		local forward = camera.CFrame.LookVector
		local right = camera.CFrame.RightVector

		if pressedKeys[Enum.KeyCode.W] then
			direction += forward
		end
		if pressedKeys[Enum.KeyCode.S] then
			direction -= forward
		end
		if pressedKeys[Enum.KeyCode.D] then
			direction += right
		end
		if pressedKeys[Enum.KeyCode.A] then
			direction -= right
		end
		if pressedKeys[UP_KEY] then
			direction += Vector3.yAxis
		end
		if pressedKeys[DOWN_KEY] then
			direction -= Vector3.yAxis
		end

		if direction.Magnitude > 0 then
			direction = direction.Unit
		end

		local speed = boostHeld and BOOST_SPEED or NORMAL_SPEED
		local targetVelocity = direction * speed
		local blend = math.clamp(deltaTime * ACCELERATION, 0, 1)
		bodyVelocity.Velocity = bodyVelocity.Velocity:Lerp(targetVelocity, blend)

		local lookDirection = camera.CFrame.LookVector
		if lookDirection.Magnitude > 0 then
			bodyGyro.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + lookDirection)
		end
	end)
end

local function toggleFlight()
	if flying then
		stopFlying()
	else
		startFlying()
	end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if input.KeyCode == TOGGLE_KEY then
		toggleFlight()
		return
	end

	if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
		boostHeld = true
	end

	pressedKeys[input.KeyCode] = true
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
		boostHeld = false
	end

	pressedKeys[input.KeyCode] = nil
end)

player.CharacterAdded:Connect(refreshCharacter)

if player.Character then
	refreshCharacter(player.Character)
else
	refreshCharacter(player.CharacterAdded:Wait())
end

player.CharacterRemoving:Connect(function()
	stopFlying()
end)
