--[[

NovaUI Library - Modern & Clean Roblox UI Library

Author: Assistant

Version: 1.0.0

License: MIT

​Features:

- Smooth Dragging & Tweens

- Dynamic Theme System (Dark / Light / Custom)

- Tab Switching System

- Modern Components: Section, Button, Toggle, Slider, Dropdown, Input, Paragraph

--]]

​local NovaUI = {}

NovaUI.__index = NovaUI

​-- Services

local TweenService = game:GetService("TweenService")

local UserInputService = game:GetService("UserInputService")

local CoreGui = game:GetService("CoreGui")

​-- Helper Functions

local function Create(className, properties, children)

local instance = Instance.new(className)

for prop, val in pairs(properties or {}) do

instance[prop] = val

end

for _, child in ipairs(children or {}) do

child.Parent = instance

end

return instance

end

​local function MakeDraggable(gui, handle)

local dragging, dragInput, dragStart, startPos

​handle = handle or gui

​handle.InputBegan:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then

dragging = true

dragStart = input.Position

startPos = gui.Position

​input.Changed:Connect(function()

if input.UserInputState == Enum.UserInputState.End then

dragging = false

end

end)

end

end)

​handle.InputChanged:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then

dragInput = input

end

end)

​UserInputService.InputChanged:Connect(function(input)

if input == dragInput and dragging then

local delta = input.Position - dragStart

TweenService:Create(gui, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {

Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)

}):Play()

end

end)

end

​-- Default Themes

NovaUI.Themes = {

Dark = {

Background = Color3.fromRGB(24, 24, 28),

Sidebar = Color3.fromRGB(18, 18, 22),

Container = Color3.fromRGB(32, 32, 38),

Element = Color3.fromRGB(40, 40, 48),

Text = Color3.fromRGB(240, 240, 245),

SubText = Color3.fromRGB(150, 150, 160),

Accent = Color3.fromRGB(99, 102, 241), -- Indigo

Border = Color3.fromRGB(50, 50, 60)

},

Light = {

Background = Color3.fromRGB(245, 245, 250),

Sidebar = Color3.fromRGB(235, 235, 240),

Container = Color3.fromRGB(255, 255, 255),

Element = Color3.fromRGB(240, 240, 245),

Text = Color3.fromRGB(30, 30, 35),

SubText = Color3.fromRGB(110, 110, 120),

Accent = Color3.fromRGB(79, 70, 229),

Border = Color3.fromRGB(220, 220, 230)

}

}

​-- Window Constructor

function NovaUI:CreateWindow(config)

config = config or {}

local windowTitle = config.Title or "NovaUI Interface"

local currentTheme = config.Theme or NovaUI.Themes.Dark

​-- Main ScreenGui Setup

local ScreenGui = Create("ScreenGui", {

Name = "NovaUI_ScreenGui",

ResetOnSpawn = false

})

​-- CoreGui Safety Fallback

local success, _ = pcall(function()

ScreenGui.Parent = CoreGui

end)

if not success then

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

end

​-- Main Window Frame

local MainFrame = Create("Frame", {

Name = "MainFrame",

Size = UDim2.fromOffset(600, 380),

Position = UDim2.new(0.5, -300, 0.5, -190),

BackgroundColor3 = currentTheme.Background,

BorderSizePixel = 0,

Parent = ScreenGui

}, {

Create("UICorner", { CornerRadius = UDim.new(0, 10) }),

Create("UIStroke", { Color = currentTheme.Border, Thickness = 1 })

})

​-- Topbar Header

local Topbar = Create("Frame", {

Name = "Topbar",

Size = UDim2.new(1, 0, 0, 40),

BackgroundTransparency = 1,

Parent = MainFrame

}, {

Create("TextLabel", {

Name = "Title",

Text = windowTitle,

Font = Enum.Font.GothamBold,

TextSize = 15,

TextColor3 = currentTheme.Text,

XAlign = Enum.TextXAlignment.Left,

Position = UDim2.new(0, 15, 0, 0),

Size = UDim2.new(0.7, 0, 1, 0),

BackgroundTransparency = 1

})

})

​MakeDraggable(MainFrame, Topbar)

​-- Sidebar for Tabs

local Sidebar = Create("Frame", {

Name = "Sidebar",

Size = UDim2.new(0, 150, 1, -40),

Position = UDim2.new(0, 0, 0, 40),

BackgroundColor3 = currentTheme.Sidebar,

BorderSizePixel = 0,

Parent = MainFrame

}, {

Create("UICorner", { CornerRadius = UDim.new(0, 10) }),

-- Cover Top Right Corner of Sidebar

Create("Frame", {

Size = UDim2.new(0, 10, 0, 10),

Position = UDim2.new(1, -10, 0, 0),

BackgroundColor3 = currentTheme.Sidebar,

BorderSizePixel = 0

})

})

​local TabButtonContainer = Create("ScrollingFrame", {

Name = "TabButtonContainer",

Size = UDim2.new(1, -10, 1, -10),

Position = UDim2.new(0, 5, 0, 5),

BackgroundTransparency = 1,

ScrollBarThickness = 2,

Parent = Sidebar

}, {

Create("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder })

})

​-- Content Container

local ContentContainer = Create("Frame", {

Name = "ContentContainer",

Size = UDim2.new(1, -160, 1, -50),

Position = UDim2.new(0, 155, 0, 45),

BackgroundTransparency = 1,

Parent = MainFrame

})

​local WindowObject = {

CurrentTab = nil,

Tabs = {},

Theme = currentTheme

}

​-- Tab System Methods

function WindowObject:CreateTab(tabName)

local TabButton = Create("TextButton", {

Name = tabName .. "_Button",

Size = UDim2.new(1, 0, 0, 32),

BackgroundColor3 = currentTheme.Element,

BackgroundTransparency = 1,

Text = tabName,

Font = Enum.Font.GothamMedium,

TextSize = 13,

TextColor3 = currentTheme.SubText,

Parent = TabButtonContainer

}, {

Create("UICorner", { CornerRadius = UDim.new(0, 6) }),

Create("UIPadding", { PaddingLeft = UDim.new(0, 10) })

})

​local TabContent = Create("ScrollingFrame", {

Name = tabName .. "_Content",

Size = UDim2.new(1, 0, 1, 0),

BackgroundTransparency = 1,

Visible = false,

ScrollBarThickness = 3,

ScrollBarImageColor3 = currentTheme.Border,

Parent = ContentContainer

}, {

Create("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })

})

​-- Tab Click Handler

TabButton.MouseButton1Click:Connect(function()

for _, tab in pairs(WindowObject.Tabs) do

tab.Content.Visible = false

TweenService:Create(tab.Button, TweenInfo.new(0.2), {

BackgroundTransparency = 1,

TextColor3 = currentTheme.SubText

}):Play()

end

TabContent.Visible = true

TweenService:Create(TabButton, TweenInfo.new(0.2), {

BackgroundTransparency = 0,

TextColor3 = currentTheme.Text

}):Play()

end)

​local TabObject = { Button = TabButton, Content = TabContent }

table.insert(WindowObject.Tabs, TabObject)

​-- Auto Select First Tab

if #WindowObject.Tabs == 1 then

TabContent.Visible = true

TabButton.BackgroundTransparency = 0

TabButton.TextColor3 = currentTheme.Text

end

​-- UI Elements Builders

function TabObject:AddSection(title)

local SectionFrame = Create("Frame", {

Name = "Section",

Size = UDim2.new(1, -10, 0, 24),

BackgroundTransparency = 1,

Parent = TabContent

}, {

Create("TextLabel", {

Text = string.upper(title),

Font = Enum.Font.GothamBold,

TextSize = 11,

TextColor3 = currentTheme.Accent,

XAlign = Enum.TextXAlignment.Left,

Size = UDim2.new(1, 0, 1, 0),

BackgroundTransparency = 1

})

})

end

​function TabObject:AddParagraph(title, desc)

local ParagraphFrame = Create("Frame", {

Name = "Paragraph",

Size = UDim2.new(1, -10, 0, 50),

BackgroundColor3 = currentTheme.Container,

Parent = TabContent

}, {

Create("UICorner", { CornerRadius = UDim.new(0, 6) }),

Create("UIStroke", { Color = currentTheme.Border, Thickness = 1 }),

Create("TextLabel", {

Text = title,

Font = Enum.Font.GothamMedium,

TextSize = 13,

TextColor3 = currentTheme.Text,

XAlign = Enum.TextXAlignment.Left,

Position = UDim2.new(0, 10, 0, 8),

Size = UDim2.new(1, -20, 0, 16),

BackgroundTransparency = 1

}),

Create("TextLabel", {

Text = desc,

Font = Enum.Font.Gotham,

TextSize = 11,

TextColor3 = currentTheme.SubText,

XAlign = Enum.TextXAlignment.Left,

Position = UDim2.new(0, 10, 0, 26),

Size = UDim2.new(1, -20, 0, 16),

BackgroundTransparency = 1

})

})

end

​function TabObject:AddButton(text, callback)

callback = callback or function() end

local BtnFrame = Create("TextButton", {

Name = "Button",

Size = UDim2.new(1, -10, 0, 36),

BackgroundColor3 = currentTheme.Container,

Text = "",

AutoButtonColor = false,

Parent = TabContent

}, {

Create("UICorner", { CornerRadius = UDim.new(0, 6) }),

Create("UIStroke", { Color = currentTheme.Border, Thickness = 1 }),

Create("TextLabel", {

Text = text,

Font = Enum.Font.GothamMedium,

TextSize = 13,

TextColor3 = currentTheme.Text,

XAlign = Enum.TextXAlignment.Left,

Position = UDim2.new(0, 10, 0, 0),

Size = UDim2.new(1, -20, 1, 0),

BackgroundTransparency = 1

})

})

​BtnFrame.MouseButton1Click:Connect(function()

TweenService:Create(BtnFrame, TweenInfo.new(0.1), { BackgroundColor3 = currentTheme.Element }):Play()

task.wait(0.1)

TweenService:Create(BtnFrame, TweenInfo.new(0.1), { BackgroundColor3 = currentTheme.Container }):Play()

pcall(callback)

end)

end

​function TabObject:AddToggle(text, default, callback)

default = default or false

callback = callback or function() end

local state = default

​local ToggleFrame = Create("TextButton", {

Name = "Toggle",

Size = UDim2.new(1, -10, 0, 36),

BackgroundColor3 = currentTheme.Container,

Text = "",

AutoButtonColor = false,

Parent = TabContent

}, {

Create("UICorner", { CornerRadius = UDim.new(0, 6) }),

Create("UIStroke", { Color = currentTheme.Border, Thickness = 1 }),

Create("TextLabel", {

Text = text,

Font = Enum.Font.GothamMedium,

TextSize = 13,

TextColor3 = currentTheme.Text,

XAlign = Enum.TextXAlignment.Left,

Position = UDim2.new(0, 10, 0, 0),

Size = UDim2.new(0.7, 0, 1, 0),

BackgroundTransparency = 1

})

})

​local SwitchBg = Create("Frame", {

Size = UDim2.new(0, 36, 0, 18),

Position = UDim2.new(1, -46, 0.5, -9),

BackgroundColor3 = state and currentTheme.Accent or currentTheme.Element,

Parent = ToggleFrame

}, {

Create("UICorner", { CornerRadius = UDim.new(1, 0) })

})

​local Knob = Create("Frame", {

Size = UDim2.new(0, 14, 0, 14),

Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),

BackgroundColor3 = Color3.fromRGB(255, 255, 255),

Parent = SwitchBg

}, {

Create("UICorner", { CornerRadius = UDim.new(1, 0) })

})

​local function UpdateToggle()

TweenService:Create(SwitchBg, TweenInfo.new(0.2), { BackgroundColor3 = state and currentTheme.Accent or currentTheme.Element }):Play()

TweenService:Create(Knob, TweenInfo.new(0.2), { Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7) }):Play()

pcall(callback, state)

end

​ToggleFrame.MouseButton1Click:Connect(function()

state = not state

UpdateToggle()

end)

end

​function TabObject:AddSlider(text, min, max, default, callback)

min = min or 0

max = max or 100

default = math.clamp(default or min, min, max)

callback = callback or function() end

​local SliderFrame = Create("Frame", {

Name = "Slider",

Size = UDim2.new(1, -10, 0, 50),

BackgroundColor3 = currentTheme.Container,

Parent = TabContent

}, {

Create("UICorner", { CornerRadius = UDim.new(0, 6) }),

Create("UIStroke", { Color = currentTheme.Border, Thickness = 1 }),

Create("TextLabel", {

Text = text,

Font = Enum.Font.GothamMedium,

TextSize = 13,

TextColor3 = currentTheme.Text,

XAlign = Enum.TextXAlignment.Left,

Position = UDim2.new(0, 10, 0, 8),

Size = UDim2.new(0.6, 0, 0, 16),

BackgroundTransparency = 1

})

})

​local ValueLabel = Create("TextLabel", {

Text = tostring(default),

Font = Enum.Font.Gotham,

TextSize = 12,

TextColor3 = currentTheme.SubText,

XAlign = Enum.TextXAlignment.Right,

Position = UDim2.new(1, -50, 0, 8),

Size = UDim2.new(0, 40, 0, 16),

BackgroundTransparency = 1,

Parent = SliderFrame

})

​local SliderTrack = Create("Frame", {

Size = UDim2.new(1, -20, 0, 4),

Position = UDim2.new(0, 10, 0, 34),

BackgroundColor3 = currentTheme.Element,

Parent = SliderFrame

}, {

Create("UICorner", { CornerRadius = UDim.new(1, 0) })

})

​local Fill = Create("Frame", {

Size = UDim2.new((default - min) / (max - min), 0, 1, 0),

BackgroundColor3 = currentTheme.Accent,

Parent = SliderTrack

}, {

Create("UICorner", { CornerRadius = UDim.new(1, 0) })

})

​local dragging = false

local function Update(input)

local pos = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)

local val = math.floor(min + (max - min) * pos)

Fill.Size = UDim2.new(pos, 0, 1, 0)

ValueLabel.Text = tostring(val)

pcall(callback, val)

end

​SliderTrack.InputBegan:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 then

dragging = true

Update(input)

end

end)

​UserInputService.InputEnded:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 then

dragging = false

end

end)

​UserInputService.InputChanged:Connect(function(input)

if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then

Update(input)

end

end)

end

​function TabObject:AddInput(text, placeholder, callback)

placeholder = placeholder or "Enter text..."

callback = callback or function() end

​local InputFrame = Create("Frame", {

Name = "Input",

Size = UDim2.new(1, -10, 0, 36),

BackgroundColor3 = currentTheme.Container,

Parent = TabContent

}, {

Create("UICorner", { CornerRadius = UDim.new(0, 6) }),

Create("UIStroke", { Color = currentTheme.Border, Thickness = 1 }),

Create("TextLabel", {

Text = text,

Font = Enum.Font.GothamMedium,

TextSize = 13,

TextColor3 = currentTheme.Text,

XAlign = Enum.TextXAlignment.Left,

Position = UDim2.new(0, 10, 0, 0),

Size = UDim2.new(0.4, 0, 1, 0),

BackgroundTransparency = 1

})

})

​local TextBox = Create("TextBox", {

PlaceholderText = placeholder,

Text = "",

Font = Enum.Font.Gotham,

TextSize = 12,

TextColor3 = currentTheme.Text,

PlaceholderColor3 = currentTheme.SubText,

XAlign = Enum.TextXAlignment.Right,

Size = UDim2.new(0.5, 0, 0, 24),

Position = UDim2.new(0.5, -10, 0.5, -12),

BackgroundTransparency = 1,

Parent = InputFrame

})

​TextBox.FocusLost:Connect(function(enterPressed)

pcall(callback, TextBox.Text, enterPressed)

end)

end

​function TabObject:AddDropdown(text, options, callback)

options = options or {}

callback = callback or function() end

local expanded = false

​local DropdownFrame = Create("Frame", {

Name = "Dropdown",

Size = UDim2.new(1, -10, 0, 36),

BackgroundColor3 = currentTheme.Container,

ClipsDescendants = true,

Parent = TabContent

}, {

Create("UICorner", { CornerRadius = UDim.new(0, 6) }),

Create("UIStroke", { Color = currentTheme.Border, Thickness = 1 })

})

​local Header = Create("TextButton", {

Size = UDim2.new(1, 0, 0, 36),

BackgroundTransparency = 1,

Text = "",

Parent = DropdownFrame

}, {

Create("TextLabel", {

Text = text,

Font = Enum.Font.GothamMedium,

TextSize = 13,

TextColor3 = currentTheme.Text,

XAlign = Enum.TextXAlignment.Left,

Position = UDim2.new(0, 10, 0, 0),

Size = UDim2.new(0.5, 0, 1, 0),

BackgroundTransparency = 1

}),

Create("TextLabel", {

Name = "SelectedText",

Text = "Select...",

Font = Enum.Font.Gotham,

TextSize = 12,

TextColor3 = currentTheme.SubText,

XAlign = Enum.TextXAlignment.Right,

Position = UDim2.new(0.5, -10, 0, 0),

Size = UDim2.new(0.5, 0, 1, 0),

BackgroundTransparency = 1

})

})

​local OptionContainer = Create("Frame", {

Size = UDim2.new(1, -20, 0, #options * 26),

Position = UDim2.new(0, 10, 0, 36),

BackgroundTransparency = 1,

Parent = DropdownFrame

}, {

Create("UIListLayout", { Padding = UDim.new(0, 2) })

})

​for _, opt in ipairs(options) do

local OptBtn = Create("TextButton", {

Size = UDim2.new(1, 0, 0, 24),

BackgroundColor3 = currentTheme.Element,

Text = opt,

Font = Enum.Font.Gotham,

TextSize = 12,

TextColor3 = currentTheme.Text,

Parent = OptionContainer

}, {

Create("UICorner", { CornerRadius = UDim.new(0, 4) })

})

​OptBtn.MouseButton1Click:Connect(function()

Header.SelectedText.Text = opt

expanded = false

TweenService:Create(DropdownFrame, TweenInfo.new(0.2), { Size = UDim2.new(1, -10, 0, 36) }):Play()

pcall(callback, opt)

end)

end

​Header.MouseButton1Click:Connect(function()

expanded = not expanded

local targetHeight = expanded and (36 + #options * 26 + 10) or 36

TweenService:Create(DropdownFrame, TweenInfo.new(0.2), { Size = UDim2.new(1, -10, 0, targetHeight) }):Play()

end)

end

​return TabObject

end

​return WindowObject

end

​return NovaUI

