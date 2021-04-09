--[[ DOCUMENTATION ])--
> window = LIbrary:Init("SCRIPT NAME")
        > slider = window:Slider( [NAME], [MINIMUM], [MAXIMUM], [DEFAULT], [CALLBACK/FUNCTION] )
                > slider:SetValue( [NUMBER] )
                > slider:GetValue() -> returns slider's value
        > box = window:Box( [NAME], [PLACEHOLDERTEXT], [CALLBACK/FUNCTION] )
                > box:SetValue( [STRING] )
                > box:GetValue() -> returns box's string value
        > window:Button( [NAME], [CALLBACK] )
        > toggle = window:Toggle( [NAME], [DEFAULT], [CALLBACK] )
                > toggle:SetValue( [BOOLEAN] )
                > toggle:GetValue() -> returns toggled value
----------------------------------------------------------------------------------------------------]]

local library = {}
local services = {
	players = game:GetService('Players'),
	runservice = game:GetService('RunService'),
	guiservice = game:GetService('GuiService'),
	uis = game:GetService('UserInputService'),
	ts = game:GetService('TweenService')
}
local mouse = services.players.LocalPlayer:GetMouse()
local inset = services.guiservice:GetGuiInset()

local minmaxpercent = function(min, max, percent)
	return ((max - min) * percent) + min
end
local percentminmax = function(min, max, percent)
	return 1 - ((max - percent) / (max - min))
end

local randomstr = function(len)
	local letters = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}
	local s = ''
	local random = Random.new()
	for i = 1,len do
		local letter = letters[math.random(1,#letters)]
		if random:NextNumber() > .5 then
			letter = letter:upper()
		end
		s = s .. letter
	end
	return s
end

function library:Init(name, config)
	local UILib = Instance.new("ScreenGui")
	local Main = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local TextLabel = Instance.new("TextLabel")
	local TabList = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	local UIPadding = Instance.new("UIPadding")
	local Frames = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local Close = Instance.new("ImageButton")

	UILib.Name = randomstr(25)
	UILib.Parent = game.CoreGui
	UILib.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	Main.Name = "Main"
	Main.Parent = UILib
	Main.BackgroundColor3 = Color3.fromRGB(25, 24, 25)
	Main.BorderSizePixel = 0
	Main.ClipsDescendants = true
	Main.Position = UDim2.new(0.181549817, 0, 0.176470593, 0)
	Main.Size = UDim2.new(0, 463, 0, 289)
	Main.Active = true
	Main.Draggable = true

	UICorner.CornerRadius = UDim.new(0, 4)
	UICorner.Parent = Main

	TextLabel.Parent = Main
	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.BackgroundTransparency = 1.000
	TextLabel.Position = UDim2.new(0.0280777533, 0, 0, 0)
	TextLabel.Size = UDim2.new(0, 173, 0, 31)
	TextLabel.Font = Enum.Font.GothamSemibold
	TextLabel.Text = tostring(name)
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextSize = 15.000
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left

	TabList.Name = "TabList"
	TabList.Parent = Main
	TabList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabList.BackgroundTransparency = 1.000
	TabList.Position = UDim2.new(0, 0, 0.107266434, 0)
	TabList.Size = UDim2.new(0, 135, 0, 258)

	UIListLayout.Parent = TabList
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 3)

	UIPadding.Parent = TabList
	UIPadding.PaddingLeft = UDim.new(0, 5)
	UIPadding.PaddingTop = UDim.new(0, 3)

	Frames.Name = "Frames"
	Frames.Parent = Main
	Frames.BackgroundColor3 = Color3.fromRGB(32, 31, 32)
	Frames.BorderSizePixel = 0
	Frames.Position = UDim2.new(0.304535627, 0, 0.117647059, 0)
	Frames.Size = UDim2.new(0, 322, 0, 263)

	UICorner_2.CornerRadius = UDim.new(0, 5)
	UICorner_2.Parent = Frames

	Close.Name = "Close"
	Close.Parent = Main
	Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Close.BackgroundTransparency = 0.980
	Close.Position = UDim2.new(0.935000002, 0, 0.0270000007, 0)
	Close.Size = UDim2.new(0, 18, 0, 18)
	Close.Image = "rbxassetid://6656451315"
	Close.ImageColor3 = Color3.fromRGB(118, 118, 118)
	Close.Active = true
	
	local Master = {
		Connections = {},
		Tabs = {}
	}
	
	table.insert(Master.Connections, services.uis.InputBegan:Connect(function(k,g)
		if g then return end
		if config and config.ToggleKey and k.KeyCode == config.ToggleKey then
			Main.Visible = not Main.Visible
		elseif (not config or not config.ToggleKey) and k.KeyCode == Enum.KeyCode.RightControl then
			Main.Visible = not Main.Visible
		end
	end))
	
	function Master:Destroy()
		for i,v in pairs(Master.Connections) do
			v:Disconnect()
		end
		UILib:Destroy()
	end
	
	Close.MouseEnter:Connect(function()
		services.ts:Create(Close, TweenInfo.new(0.05), {ImageColor3 = Color3.fromRGB(186, 186, 186)}):Play()
	end)
	Close.MouseButton1Down:Connect(function()
		services.ts:Create(Close, TweenInfo.new(0.05), {ImageColor3 = Color3.fromRGB(130, 130, 130)}):Play()
	end)
	Close.InputEnded:Connect(function(k,g)
		if k.UserInputType == Enum.UserInputType.MouseButton1 then
			Master:Destroy()
		else
			services.ts:Create(Close, TweenInfo.new(0.05), {ImageColor3 = Color3.fromRGB(118, 118, 118)}):Play()
		end
	end)
	
	function Master:CreateTab(name)
		
		local TabButton = Instance.new("TextButton")
		local UICorner = Instance.new("UICorner")

		TabButton.Name = "TabButton"
		TabButton.Parent = TabList
		TabButton.BackgroundColor3 = Color3.fromRGB(229, 34, 68)
		TabButton.BorderSizePixel = 0
		TabButton.Position = UDim2.new(0.0250000004, 0, 0.0116279069, 0)
		TabButton.Size = UDim2.new(0.949999988, 0, 0.109786823, 0)
		TabButton.AutoButtonColor = false
		TabButton.Font = Enum.Font.Gotham
		TabButton.Text = tostring(name)
		TabButton.TextColor3 = Color3.fromRGB(238, 238, 238)
		TabButton.TextSize = 18.000

		UICorner.CornerRadius = UDim.new(0, 6)
		UICorner.Parent = TabButton
		
		local TabFrame = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local UIPadding = Instance.new("UIPadding")

		TabFrame.Name = "TabFrame"
		TabFrame.Parent = Frames
		TabFrame.Active = true
		TabFrame.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
		TabFrame.BackgroundTransparency = 1.000
		TabFrame.BorderSizePixel = 0
		TabFrame.Size = UDim2.new(0, 322, 0, 266)
		TabFrame.ScrollBarThickness = 1

		UIListLayout.Parent = TabFrame
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 5)

		UIPadding.Parent = TabFrame
		UIPadding.PaddingTop = UDim.new(0, 3)
		
		table.insert(Master.Tabs, {
			TabButton = TabButton,
			TabFrame = TabFrame,
			Name = name
		})
		
		local function SwitchTab()
			for i,v in pairs(Master.Tabs) do
				v.TabFrame.Visible = false
			end
			TabFrame.Visible = true
		end
		
		SwitchTab()
		
		TabButton.MouseButton1Down:Connect(function()
			TabButton:TweenSize(UDim2.new(0.85, 0, 0.089, 0),'In','Linear',0.05)
		end)
		TabButton.MouseButton1Up:Connect(function()
			SwitchTab()
			TabButton:TweenSize(UDim2.new(0.949999988, 0, 0.109786823, 0),'In','Linear',0.05)
		end)
		TabButton.InputEnded:Connect(function(k,g)
			if k.UserInputType == Enum.UserInputType.MouseButton1 then
				SwitchTab()
				TabButton:TweenSize(UDim2.new(0.949999988, 0, 0.109786823, 0),'In','Linear',0.05)
			else
				TabButton:TweenSize(UDim2.new(0.949999988, 0, 0.109786823, 0),'In','Linear',0.05)
			end
		end)
		
		
		local self = {}
		
		function self:Slider(name, min, max, default, callback)
			
			local SliderFrame = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local img = Instance.new("ImageLabel")
			local ToggleName = Instance.new("TextLabel")
			local Slider = Instance.new("Frame")
			local Fill = Instance.new("Frame")
			local UICorner_2 = Instance.new("UICorner")
			local dot = Instance.new("ImageLabel")
			local UICorner_3 = Instance.new("UICorner")
			local Number = Instance.new("TextLabel")

			SliderFrame.Name = "SliderFrame"
			SliderFrame.Parent = TabFrame
			SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 24, 25)
			SliderFrame.BorderSizePixel = 0
			SliderFrame.Position = UDim2.new(0.0295999665, 0, 0.13909775, 0)
			SliderFrame.Size = UDim2.new(0.950400054, 0, 0, 34)

			UICorner.CornerRadius = UDim.new(0, 6)
			UICorner.Parent = SliderFrame

			img.Name = "img"
			img.Parent = SliderFrame
			img.AnchorPoint = Vector2.new(0, 0.5)
			img.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			img.BackgroundTransparency = 1.000
			img.Position = UDim2.new(0.0289999992, 0, 0.5, 0)
			img.Size = UDim2.new(0, 25, 0, 25)
			img.Image = "rbxassetid://6656286382"
			img.ImageColor3 = Color3.fromRGB(232, 33, 68)

			ToggleName.Name = "ToggleName"
			ToggleName.Parent = SliderFrame
			ToggleName.AnchorPoint = Vector2.new(0, 0.5)
			ToggleName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleName.BackgroundTransparency = 1.000
			ToggleName.Position = UDim2.new(0.117858559, 0, 0.5, 0)
			ToggleName.Size = UDim2.new(0, 84, 0, 34)
			ToggleName.Font = Enum.Font.SourceSansLight
			ToggleName.Text = tostring(name)
			ToggleName.TextColor3 = Color3.fromRGB(127, 155, 141)
			ToggleName.TextSize = 19.000
			ToggleName.TextWrapped = true
			ToggleName.TextXAlignment = Enum.TextXAlignment.Left

			Slider.Name = "Slider"
			Slider.Parent = SliderFrame
			Slider.AnchorPoint = Vector2.new(0, 0.5)
			Slider.BackgroundColor3 = Color3.fromRGB(20, 19, 20)
			Slider.BorderColor3 = Color3.fromRGB(27, 42, 53)
			Slider.BorderSizePixel = 0
			Slider.Position = UDim2.new(0.419999987, 0, 0.5, 0)
			Slider.Size = UDim2.new(0, 128,0, 18)
			Slider.BackgroundTransparency = 1

			Fill.Name = "Fill"
			Fill.Parent = Slider
			Fill.AnchorPoint = Vector2.new(0, 0.5)
			Fill.BackgroundColor3 = Color3.fromRGB(229, 34, 68)
			Fill.Position = UDim2.new(0, 0, 0.5, 0)
			Fill.Size = UDim2.new(1, 0, 0.1, 0)

			UICorner_2.CornerRadius = UDim.new(0, 3)
			UICorner_2.Parent = Fill

			dot.Name = "dot"
			dot.Parent = Fill
			dot.AnchorPoint = Vector2.new(0.5, 0.5)
			dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			dot.BackgroundTransparency = 1.000
			dot.Position = UDim2.new(0.99000001, 0, 0.5, 0)
			dot.Size = UDim2.new(0, 15, 0, 15)
			dot.Image = "rbxassetid://6656252837"
			dot.ImageColor3 = Color3.fromRGB(232, 33, 68)

			Number.Name = "Number"
			Number.Parent = SliderFrame
			Number.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Number.BackgroundTransparency = 1.000
			Number.Position = UDim2.new(0.869199216, 0, 0, 0)
			Number.Size = UDim2.new(0, 33, 0, 34)
			Number.Font = Enum.Font.SourceSansItalic
			Number.Text = tostring(default)
			Number.TextColor3 = Color3.fromRGB(184, 184, 184)
			Number.TextSize = 14.000

			UICorner_3.CornerRadius = UDim.new(0, 3)
			UICorner_3.Parent = Slider
			
			default = math.clamp(default, min, max)
			local self = {
				Value = default
			}
			local dragging = false
			
			local function start(k)
				if k.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
				end
			end
			Slider.InputBegan:Connect(start)
			dot.InputBegan:Connect(start)
			Fill.InputBegan:Connect(start)
			
			table.insert(Master.Connections, services.uis.InputChanged:Connect(function(k,g)
				if dragging then
					local pos = Vector2.new(mouse.X, mouse.Y + inset.Y)
					local relpos = pos - Slider.AbsolutePosition
					local percent = math.clamp(relpos.X / Slider.AbsoluteSize.X, 0, 1)
					services.ts:Create(Fill, TweenInfo.new(0.05), {Size = UDim2.new(percent, 0, 0.1, 0)}):Play()
					local value = math.floor(minmaxpercent(min,max,percent))
					Number.Text = tostring(value)
					pcall(callback, value)
				end
			end))
			table.insert(Master.Connections, services.uis.InputEnded:Connect(function(k,g)
				if k.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end))
			
			function self:SetValue(value)
				if not tonumber(value) then return false end
				self.Value = tonumber(value)
				Number.Text = tostring(value)
				services.ts:Create(Fill, TweenInfo.new(0.05), {Size = UDim2.new(percentminmax(min, max, tonumber(value)), 0, 0.1, 0)}):Play()
				pcall(callback, tonumber(value))
			end
			
			function self:GetValue()
				return self.Value
			end
			
			self:SetValue(default)
			
			return self
		end
		
		function self:Button(name, callback)
			
			local ButtonFrame = Instance.new("Frame")
			local Button = Instance.new("TextButton")
			local UICorner = Instance.new("UICorner")

			ButtonFrame.Name = "ButtonFrame"
			ButtonFrame.Parent = TabFrame
			ButtonFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ButtonFrame.BackgroundTransparency = 1.000
			ButtonFrame.Position = UDim2.new(0, 0, 0.0112781953, 0)
			ButtonFrame.Size = UDim2.new(0.959999979, 0, 0, 34)

			Button.Name = "Button"
			Button.Parent = ButtonFrame
			Button.AnchorPoint = Vector2.new(0.5, 0.5)
			Button.BackgroundColor3 = Color3.fromRGB(229, 34, 68)
			Button.BorderSizePixel = 0
			Button.Position = UDim2.new(0.5, 0, 0.5, 0)
			Button.Size = UDim2.new(0.980000019, 0, 0.899999976, 0)
			Button.AutoButtonColor = false
			Button.Font = Enum.Font.Gotham
			Button.Text = tostring(name)
			Button.TextColor3 = Color3.fromRGB(238, 238, 238)
			Button.TextSize = 18.000

			UICorner.CornerRadius = UDim.new(0, 6)
			UICorner.Parent = Button
			
			local self = {}
			
			function self:Activate()
				pcall(callback)
			end
			
			Button.MouseButton1Down:Connect(function()
				Button:TweenSize(UDim2.new(0.95, 0, 0.83, 0),'In','Linear',0.05)
				self:Activate()
			end)
			Button.MouseButton1Up:Connect(function()
				Button:TweenSize(UDim2.new(0.980000019, 0, 0.899999976, 0),'In','Linear',0.05)
			end)
			Button.InputEnded:Connect(function()
				Button:TweenSize(UDim2.new(0.980000019, 0, 0.899999976, 0),'In','Linear',0.05)
			end)
			
			return self
		end
		
		function self:Toggle(name, bool, callback)
			local ToggleFrame = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local ring = Instance.new("ImageLabel")
			local dot = Instance.new("ImageLabel")
			local ToggleName = Instance.new("TextLabel")
			local Info = Instance.new("ImageButton")

			ToggleFrame.Name = "ToggleFrame"
			ToggleFrame.Parent = TabFrame
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 24, 25)
			ToggleFrame.BorderSizePixel = 0
			ToggleFrame.Position = UDim2.new(0.0295999665, 0, 0.13909775, 0)
			ToggleFrame.Size = UDim2.new(0.950400054, 0, 0, 34)

			UICorner.CornerRadius = UDim.new(0, 6)
			UICorner.Parent = ToggleFrame

			ring.Name = "ring"
			ring.Parent = ToggleFrame
			ring.AnchorPoint = Vector2.new(0, 0.5)
			ring.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ring.BackgroundTransparency = 1.000
			ring.Position = UDim2.new(0.0289999992, 0, 0.5, 0)
			ring.Size = UDim2.new(0, 25, 0, 25)
			ring.Image = "rbxassetid://6656249169"
			ring.ImageColor3 = Color3.fromRGB(232, 33, 68)

			dot.Name = "dot"
			dot.Parent = ring
			dot.AnchorPoint = Vector2.new(0.5, 0.5)
			dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			dot.BackgroundTransparency = 1.000
			dot.Position = UDim2.new(0.5, 0, 0.5, 0)
			dot.Size = UDim2.new(0,0,0,0)
			dot.Image = "rbxassetid://6656252837"
			dot.ImageColor3 = Color3.fromRGB(232, 33, 68)

			ToggleName.Name = "ToggleName"
			ToggleName.Parent = ToggleFrame
			ToggleName.AnchorPoint = Vector2.new(0, 0.5)
			ToggleName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleName.BackgroundTransparency = 1.000
			ToggleName.Position = UDim2.new(0.143999994, 0, 0.5, 0)
			ToggleName.Size = UDim2.new(0, 177, 0, 34)
			ToggleName.Font = Enum.Font.SourceSansLight
			ToggleName.Text = tostring(name)
			ToggleName.TextColor3 = Color3.fromRGB(127, 155, 141)
			ToggleName.TextSize = 19.000
			ToggleName.TextXAlignment = Enum.TextXAlignment.Left

			Info.Name = "Info"
			Info.Parent = ToggleFrame
			Info.AnchorPoint = Vector2.new(0.5, 0.5)
			Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Info.BackgroundTransparency = 1.000
			Info.BorderSizePixel = 0
			Info.Position = UDim2.new(0.925742149, 0, 0.5, 0)
			Info.Size = UDim2.new(0.144949317, 0, 1, 0)
			Info.Image = "rbxassetid://6656273920"
			Info.ImageColor3 = Color3.fromRGB(229, 34, 68)
			
			local self = {
				Active = bool
			}
			function self:SetValue(b)
				if b ~= false and b ~= true then return end
				self.Active = b
				local s = UDim2.new(0,0,0,0)
				if b then
					s = UDim2.new(0.600000024, 0, 0.600000024, 0)
				end
				dot:TweenSize(s, 'In', 'Linear', 0.05)
				pcall(callback, b)
			end
			
			local function enter(k,g)
				services.ts:Create(ToggleFrame, TweenInfo.new(0.05), {BackgroundColor3 = Color3.fromRGB(48, 46, 48)}):Play()
			end
			local function click(k,g)
				if k.UserInputType == Enum.UserInputType.MouseButton1 then
					services.ts:Create(ToggleFrame, TweenInfo.new(0.05), {BackgroundColor3 = Color3.fromRGB(8, 7, 8)}):Play()
					self:SetValue(not self.Active)
				else
					enter()
				end
			end
			local function leave(k,g)
				services.ts:Create(ToggleFrame, TweenInfo.new(0.05), {BackgroundColor3 = Color3.fromRGB(25, 24, 25)}):Play()
			end
			
			dot.InputBegan:Connect(click)
			ring.InputBegan:Connect(click)
			ToggleFrame.InputBegan:Connect(click)
			
			dot.InputEnded:Connect(leave)
			ring.InputEnded:Connect(leave)
			ToggleFrame.InputEnded:Connect(leave)
			
			function self:GetValue()
				return self.Active
			end
			
			return self
		end
		
		function self:Box(name, placeholdertext, callback)
			
			local BoxFrame = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local BoxName = Instance.new("TextLabel")
			local keyboard = Instance.new("ImageLabel")
			local Box = Instance.new("TextBox")

			BoxFrame.Name = "BoxFrame"
			BoxFrame.Parent = TabFrame
			BoxFrame.BackgroundColor3 = Color3.fromRGB(25, 24, 25)
			BoxFrame.BorderSizePixel = 0
			BoxFrame.Position = UDim2.new(0.0295999665, 0, 0.13909775, 0)
			BoxFrame.Size = UDim2.new(0.950400054, 0, 0, 34)

			UICorner.CornerRadius = UDim.new(0, 6)
			UICorner.Parent = BoxFrame

			BoxName.Name = "ToggleName"
			BoxName.Parent = BoxFrame
			BoxName.AnchorPoint = Vector2.new(0, 0.5)
			BoxName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			BoxName.BackgroundTransparency = 1.000
			BoxName.Position = UDim2.new(0.143999889, 0, 0.5, 0)
			BoxName.Size = UDim2.new(0, 76, 0, 34)
			BoxName.Font = Enum.Font.SourceSansLight
			BoxName.Text = tostring(name)
			BoxName.TextColor3 = Color3.fromRGB(127, 155, 141)
			BoxName.TextSize = 19.000
			BoxName.TextWrapped = true
			BoxName.TextXAlignment = Enum.TextXAlignment.Left

			keyboard.Name = "keyboard"
			keyboard.Parent = BoxFrame
			keyboard.AnchorPoint = Vector2.new(0, 0.5)
			keyboard.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			keyboard.BackgroundTransparency = 1.000
			keyboard.Position = UDim2.new(0.0289999992, 0, 0.419999987, 0)
			keyboard.Size = UDim2.new(0, 25, 0, 25)
			keyboard.Image = "rbxassetid://6656550935"
			keyboard.ImageColor3 = Color3.fromRGB(232, 33, 68)

			Box.Name = "Box"
			Box.Parent = BoxFrame
			Box.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
			Box.BorderSizePixel = 0
			Box.Position = UDim2.new(0.443, 0, 0.5, 0)
			Box.Size = UDim2.new(0, 159, 0, 19)
			Box.Font = Enum.Font.Ubuntu
			Box.PlaceholderColor3 = Color3.fromRGB(95, 95, 95)
			Box.PlaceholderText = tostring(placeholdertext)
			Box.Text = ""
			Box.TextColor3 = Color3.fromRGB(255, 255, 255)
			Box.TextSize = 14.000
			Box.AnchorPoint = Vector2.new(0,0.5)
			
			local self = {}
			
			function self:Activate(value)
				pcall(callback, value)
			end
			
			Box.Focused:Connect(function()
				BoxFrame:TweenSize(UDim2.new(0.95, 0,0.083, 34), 'In', 'Linear', 0.05, true)
				keyboard:TweenPosition(UDim2.new(0.026, 0,0.42, 0), 'In', 'Linear', 0.05, true)
				BoxName:TweenPosition(UDim2.new(0.144, 0,0.436, 0), 'In', 'Linear', 0.05, true)
				Box:TweenSizeAndPosition(UDim2.new(0, 159,0, 43), UDim2.new(0.443, 0,0.5, 0), 'In', 'Linear', 0.05, true)
			end)
			Box.FocusLost:Connect(function(enter)
				if enter then
					self:Activate(Box.Text)
				end
				BoxFrame:TweenSize(UDim2.new(0.950400054, 0, 0, 34), 'In', 'Linear', 0.05, true)
				keyboard:TweenPosition(UDim2.new(0.026, 0,0.42, 0), 'In', 'Linear', 0.05, true)
				BoxName:TweenPosition(UDim2.new(0.144, 0,0.436, 0), 'In', 'Linear', 0.05, true)
				Box:TweenSizeAndPosition(UDim2.new(0, 159, 0, 19), UDim2.new(0.443, 0, 0.5, 0), 'In', 'Linear', 0.05, true)
			end)
			
			
			return self
		end
		
		
		return self
	end
	
	return Master
end

return library
