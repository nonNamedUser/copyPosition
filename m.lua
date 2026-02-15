local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local gui = Instance.new("ScreenGui")
gui.Name = "PositionCopierModernResponsive"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local function tween(obj, props, t, style, dir)
	local tw = TweenService:Create(
		obj,
		TweenInfo.new(t or 0.25, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
		props
	)
	tw:Play()
	return tw
end

local card = Instance.new("Frame")
card.BackgroundColor3 = Color3.fromRGB(16, 20, 30)
card.BorderSizePixel = 0
card.ClipsDescendants = true
card.Active = true
card.Parent = gui

local cardCorner = Instance.new("UICorner")
cardCorner.CornerRadius = UDim.new(0, 16)
cardCorner.Parent = card

local cardStroke = Instance.new("UIStroke")
cardStroke.Thickness = 1.2
cardStroke.Transparency = 0.35
cardStroke.Color = Color3.fromRGB(90, 125, 200)
cardStroke.Parent = card

local grad = Instance.new("UIGradient")
grad.Rotation = 35
grad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 38, 56)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 18, 26))
})
grad.Parent = card

local bgLayer = Instance.new("Frame")
bgLayer.BackgroundTransparency = 1
bgLayer.Size = UDim2.fromScale(1, 1)
bgLayer.Parent = card

local header = Instance.new("Frame")
header.BackgroundTransparency = 1
header.Active = true
header.Parent = card

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Text = "Position Copier"
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(242, 247, 255)
title.Font = Enum.Font.GothamBold
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Text = "Drag header • Press P or tap button"
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.TextColor3 = Color3.fromRGB(170, 188, 220)
subtitle.Font = Enum.Font.GothamMedium
subtitle.Parent = header

local output = Instance.new("TextBox")
output.BackgroundColor3 = Color3.fromRGB(10, 13, 20)
output.BorderSizePixel = 0
output.Text = "Vector3.new(...)"
output.ClearTextOnFocus = false
output.TextEditable = false
output.TextXAlignment = Enum.TextXAlignment.Left
output.Font = Enum.Font.Code
output.TextColor3 = Color3.fromRGB(210, 225, 255)
output.Parent = card

local outputCorner = Instance.new("UICorner")
outputCorner.CornerRadius = UDim.new(0, 12)
outputCorner.Parent = output

local outputStroke = Instance.new("UIStroke")
outputStroke.Color = Color3.fromRGB(84, 110, 165)
outputStroke.Transparency = 0.45
outputStroke.Parent = output

local copyBtn = Instance.new("TextButton")
copyBtn.BackgroundColor3 = Color3.fromRGB(70, 128, 255)
copyBtn.AutoButtonColor = false
copyBtn.Text = "Copy Position"
copyBtn.TextColor3 = Color3.fromRGB(245, 250, 255)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.Parent = card

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 12)
btnCorner.Parent = copyBtn

local status = Instance.new("TextLabel")
status.BackgroundTransparency = 1
status.Text = "Ready"
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextColor3 = Color3.fromRGB(150, 230, 175)
status.Font = Enum.Font.GothamSemibold
status.Parent = card

local baseButtonSize = Vector2.new(170, 42)

local function layoutResponsive()
	local vp = camera and camera.ViewportSize or Vector2.new(1280, 720)
	local w = vp.X

	local cardW = math.clamp(math.floor(w * 0.88), 300, 520)
	local cardH = math.clamp(math.floor(cardW * 0.56), 190, 290)
	local isMobile = w < 700
	local yScale = isMobile and 0.54 or 0.50

	card.Size = UDim2.fromOffset(cardW, cardH)
	card.Position = UDim2.new(0.5, -math.floor(cardW / 2), yScale, -math.floor(cardH / 2))

	local pad = math.max(10, math.floor(cardW * 0.032))
	local headerH = math.max(48, math.floor(cardH * 0.23))
	local outputH = math.max(50, math.floor(cardH * 0.25))
	local titleSize = math.clamp(math.floor(cardW * 0.05), 17, 22)
	local subSize = math.clamp(math.floor(cardW * 0.028), 11, 13)
	local statusSize = math.clamp(math.floor(cardW * 0.031), 12, 14)
	local btnTextSize = math.clamp(math.floor(cardW * 0.032), 12, 14)
	local codeSize = math.clamp(math.floor(cardW * 0.032), 12, 15)

	local btnW = math.clamp(math.floor(cardW * 0.40), 140, 180)
	local btnH = math.clamp(math.floor(cardH * 0.18), 36, 44)
	baseButtonSize = Vector2.new(btnW, btnH)

	header.Size = UDim2.new(1, 0, 0, headerH)

	title.Position = UDim2.fromOffset(pad, math.floor(headerH * 0.14))
	title.Size = UDim2.new(1, -pad * 2, 0, math.floor(headerH * 0.45))
	title.TextSize = titleSize

	subtitle.Position = UDim2.fromOffset(pad, math.floor(headerH * 0.56))
	subtitle.Size = UDim2.new(1, -pad * 2, 0, math.floor(headerH * 0.32))
	subtitle.TextSize = subSize

	output.Position = UDim2.fromOffset(pad, pad + headerH - 2)
	output.Size = UDim2.new(1, -pad * 2, 0, outputH)
	output.TextSize = codeSize

	copyBtn.Size = UDim2.fromOffset(btnW, btnH)
	copyBtn.Position = UDim2.new(1, -(pad + btnW), 1, -(pad + btnH))
	copyBtn.TextSize = btnTextSize

	status.Position = UDim2.fromOffset(pad, cardH - (pad + btnH - 2))
	status.Size = UDim2.new(1, -(pad * 2 + btnW + 8), 0, btnH)
	status.TextSize = statusSize
end

layoutResponsive()
if camera then
	camera:GetPropertyChangedSignal("ViewportSize"):Connect(layoutResponsive)
end

local function makeSquare()
	local sq = Instance.new("Frame")
	local s = math.random(10, 24)
	sq.Size = UDim2.fromOffset(s, s)
	sq.Position = UDim2.new(math.random(), -s, math.random(), -s)
	sq.BackgroundColor3 = Color3.fromRGB(92, 136, 235)
	sq.BackgroundTransparency = math.random(70, 88) / 100
	sq.BorderSizePixel = 0
	sq.Rotation = math.random(-30, 30)
	sq.ZIndex = 0
	sq.Parent = bgLayer

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, math.random(2, 7))
	c.Parent = sq

	local life = math.random(7, 12)
	local start = tick()
	local p0 = sq.Position
	local dx = (math.random() * 0.14 - 0.07)
	local dy = -(0.16 + math.random() * 0.20)
	local spin = math.random(-20, 20)

	local conn
	conn = RunService.RenderStepped:Connect(function(dt)
		if not sq.Parent then conn:Disconnect() return end
		local a = (tick() - start) / life
		if a >= 1 then
			conn:Disconnect()
			sq:Destroy()
			return
		end
		local wobble = math.sin((tick() - start) * 2.5) * 0.01
		sq.Position = UDim2.new(p0.X.Scale + dx * a + wobble, p0.X.Offset, p0.Y.Scale + dy * a, p0.Y.Offset)
		sq.Rotation += spin * dt
	end)
end

for _ = 1, 10 do makeSquare() end
task.spawn(function()
	while gui.Parent do
		task.wait(math.random(30, 55) / 10)
		makeSquare()
	end
end)

local function getPositionText()
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil, "HumanoidRootPart not found" end
	local p = hrp.Position
	return string.format("Vector3.new(%.3f, %.3f, %.3f)", p.X, p.Y, p.Z)
end

local function flash(ok)
	if ok then
		tween(copyBtn, {BackgroundColor3 = Color3.fromRGB(85, 200, 130)}, 0.12)
	else
		tween(copyBtn, {BackgroundColor3 = Color3.fromRGB(220, 95, 95)}, 0.12)
	end
	task.delay(0.2, function()
		if copyBtn.Parent then
			tween(copyBtn, {BackgroundColor3 = Color3.fromRGB(70, 128, 255)}, 0.18)
		end
	end)
end

local function copyPosition()
	local text, err = getPositionText()
	if not text then
		status.Text = err
		status.TextColor3 = Color3.fromRGB(255, 150, 150)
		flash(false)
		return
	end

	output.Text = text
	if setclipboard then
		setclipboard(text)
		status.Text = "Copied to clipboard"
		status.TextColor3 = Color3.fromRGB(150, 230, 175)
	else
		status.Text = "Clipboard unavailable (value shown above)"
		status.TextColor3 = Color3.fromRGB(255, 220, 125)
	end
	flash(true)
end

copyBtn.MouseEnter:Connect(function()
	local grow = Vector2.new(baseButtonSize.X + 4, baseButtonSize.Y + 2)
	tween(copyBtn, {BackgroundColor3 = Color3.fromRGB(86, 145, 255), Size = UDim2.fromOffset(grow.X, grow.Y)}, 0.12)
end)

copyBtn.MouseLeave:Connect(function()
	tween(copyBtn, {BackgroundColor3 = Color3.fromRGB(70, 128, 255), Size = UDim2.fromOffset(baseButtonSize.X, baseButtonSize.Y)}, 0.12)
end)

copyBtn.MouseButton1Click:Connect(copyPosition)

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.P then
		copyPosition()
	end
end)

local dragging = false
local dragInput, dragStart, startPos

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = card.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not dragging or input ~= dragInput then return end
	local delta = input.Position - dragStart
	card.Position = UDim2.new(
		startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y
	)
end)

card.BackgroundTransparency = 1
cardStroke.Transparency = 1
title.TextTransparency = 1
subtitle.TextTransparency = 1
output.BackgroundTransparency = 1
output.TextTransparency = 1
copyBtn.BackgroundTransparency = 1
copyBtn.TextTransparency = 1
status.TextTransparency = 1

local p = card.Position
card.Position = UDim2.new(p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset + 25)

tween(card, {BackgroundTransparency = 0, Position = p}, 0.35, Enum.EasingStyle.Quart)
tween(cardStroke, {Transparency = 0.35}, 0.4)
tween(title, {TextTransparency = 0}, 0.3)
tween(subtitle, {TextTransparency = 0}, 0.35)
tween(output, {BackgroundTransparency = 0, TextTransparency = 0}, 0.4)
tween(copyBtn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.4)
tween(status, {TextTransparency = 0}, 0.45)
