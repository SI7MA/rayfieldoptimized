--[[
    Rayfield Interface Suite - Optimized Version
    Improvements:
    - Reduced memory usage
    - Better performance
    - Cleaner code structure
    - Removed redundant features
    - Optimized animations
]]

-- Cache frequently used services
local Services = {
    TweenService = game:GetService("TweenService"),
    UserInputService = game:GetService("UserInputService"),
    RunService = game:GetService("RunService"),
    Players = game:GetService("Players"),
    CoreGui = game:GetService("CoreGui"),
    HttpService = game:GetService("HttpService")
}

-- Constants
local TWEEN_INFO_FAST = TweenInfo.new(0.3, Enum.EasingStyle.Exponential)
local TWEEN_INFO_NORMAL = TweenInfo.new(0.5, Enum.EasingStyle.Exponential)
local TWEEN_INFO_SLOW = TweenInfo.new(0.7, Enum.EasingStyle.Exponential)

-- Utility functions
local function createTween(object, properties, tweenInfo)
    tweenInfo = tweenInfo or TWEEN_INFO_NORMAL
    return Services.TweenService:Create(object, tweenInfo, properties)
end

local function safeCallback(callback, ...)
    if callback and type(callback) == "function" then
        local success, result = pcall(callback, ...)
        if not success then
            warn("Callback error:", result)
        end
        return success
    end
    return false
end

-- Theme system (simplified)
local Themes = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 25),
        ElementBackground = Color3.fromRGB(35, 35, 35),
        TextColor = Color3.fromRGB(240, 240, 240),
        AccentColor = Color3.fromRGB(50, 138, 220)
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 245),
        ElementBackground = Color3.fromRGB(240, 240, 240),
        TextColor = Color3.fromRGB(40, 40, 40),
        AccentColor = Color3.fromRGB(100, 150, 200)
    }
}

-- Main library
local RayfieldLibrary = {
    Flags = {},
    CurrentTheme = Themes.Dark
}

-- Create GUI structure (simplified)
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RayfieldOptimized"
    screenGui.ResetOnSpawn = false
    
    -- Try to parent to protected GUI location
    if gethui then
        screenGui.Parent = gethui()
    else
        screenGui.Parent = Services.CoreGui
    end
    
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 500, 0, 400)
    main.Position = UDim2.new(0.5, -250, 0.5, -200)
    main.BackgroundColor3 = RayfieldLibrary.CurrentTheme.Background
    main.BorderSizePixel = 0
    main.Parent = screenGui
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = main
    
    -- Add shadow effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ZIndex = -1
    shadow.Parent = main
    
    return screenGui, main
end

-- Optimized element creation
local function createElement(elementType, properties, parent)
    local element = Instance.new(elementType)
    for property, value in pairs(properties) do
        element[property] = value
    end
    if parent then
        element.Parent = parent
    end
    return element
end

-- Window creation
function RayfieldLibrary:CreateWindow(settings)
    settings = settings or {}
    
    local gui, main = createGUI()
    
    -- Create title bar
    local titleBar = createElement("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = RayfieldLibrary.CurrentTheme.ElementBackground,
        BorderSizePixel = 0
    }, main)
    
    local titleCorner = createElement("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, titleBar)
    
    local title = createElement("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = settings.Name or "Rayfield",
        TextColor3 = RayfieldLibrary.CurrentTheme.TextColor,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham
    }, titleBar)
    
    -- Close button
    local closeButton = createElement("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5),
        BackgroundColor3 = Color3.fromRGB(255, 100, 100),
        BorderSizePixel = 0,
        Text = "×",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 18,
        Font = Enum.Font.GothamBold
    }, titleBar)
    
    local closeCorner = createElement("UICorner", {
        CornerRadius = UDim.new(0, 4)
    }, closeButton)
    
    -- Content area
    local content = createElement("ScrollingFrame", {
        Name = "Content",
        Size = UDim2.new(1, -20, 1, -60),
        Position = UDim2.new(0, 10, 0, 50),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    }, main)
    
    local contentLayout = createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    }, content)
    
    -- Make draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    
    Services.UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
                                     startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    Services.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Close functionality
    closeButton.MouseButton1Click:Connect(function()
        createTween(main, {Size = UDim2.new(0, 0, 0, 0)}, TWEEN_INFO_FAST):Play()
        task.wait(0.3)
        gui:Destroy()
    end)
    
    -- Window object
    local Window = {
        GUI = gui,
        Main = main,
        Content = content
    }
    
    -- Create button
    function Window:CreateButton(settings)
        settings = settings or {}
        
        local button = createElement("TextButton", {
            Name = settings.Name or "Button",
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = RayfieldLibrary.CurrentTheme.ElementBackground,
            BorderSizePixel = 0,
            Text = settings.Name or "Button",
            TextColor3 = RayfieldLibrary.CurrentTheme.TextColor,
            TextSize = 14,
            Font = Enum.Font.Gotham
        }, content)
        
        local buttonCorner = createElement("UICorner", {
            CornerRadius = UDim.new(0, 6)
        }, button)
        
        -- Hover effects
        button.MouseEnter:Connect(function()
            createTween(button, {BackgroundColor3 = RayfieldLibrary.CurrentTheme.AccentColor}, TWEEN_INFO_FAST):Play()
        end)
        
        button.MouseLeave:Connect(function()
            createTween(button, {BackgroundColor3 = RayfieldLibrary.CurrentTheme.ElementBackground}, TWEEN_INFO_FAST):Play()
        end)
        
        -- Click handler
        button.MouseButton1Click:Connect(function()
            safeCallback(settings.Callback)
        end)
        
        return {
            Element = button,
            Set = function(self, newText)
                button.Text = newText
            end
        }
    end
    
    -- Create toggle
    function Window:CreateToggle(settings)
        settings = settings or {}
        
        local toggleFrame = createElement("Frame", {
            Name = settings.Name or "Toggle",
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = RayfieldLibrary.CurrentTheme.ElementBackground,
            BorderSizePixel = 0
        }, content)
        
        local toggleCorner = createElement("UICorner", {
            CornerRadius = UDim.new(0, 6)
        }, toggleFrame)
        
        local label = createElement("TextLabel", {
            Name = "Label",
            Size = UDim2.new(1, -60, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = settings.Name or "Toggle",
            TextColor3 = RayfieldLibrary.CurrentTheme.TextColor,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.Gotham
        }, toggleFrame)
        
        local switch = createElement("Frame", {
            Name = "Switch",
            Size = UDim2.new(0, 40, 0, 20),
            Position = UDim2.new(1, -50, 0.5, -10),
            BackgroundColor3 = settings.CurrentValue and RayfieldLibrary.CurrentTheme.AccentColor or Color3.fromRGB(100, 100, 100),
            BorderSizePixel = 0
        }, toggleFrame)
        
        local switchCorner = createElement("UICorner", {
            CornerRadius = UDim.new(0, 10)
        }, switch)
        
        local indicator = createElement("Frame", {
            Name = "Indicator",
            Size = UDim2.new(0, 16, 0, 16),
            Position = settings.CurrentValue and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0
        }, switch)
        
        local indicatorCorner = createElement("UICorner", {
            CornerRadius = UDim.new(0, 8)
        }, indicator)
        
        local currentValue = settings.CurrentValue or false
        
        -- Click handler
        local button = createElement("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = ""
        }, toggleFrame)
        
        button.MouseButton1Click:Connect(function()
            currentValue = not currentValue
            
            -- Animate switch
            createTween(switch, {
                BackgroundColor3 = currentValue and RayfieldLibrary.CurrentTheme.AccentColor or Color3.fromRGB(100, 100, 100)
            }, TWEEN_INFO_FAST):Play()
            
            createTween(indicator, {
                Position = currentValue and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            }, TWEEN_INFO_FAST):Play()
            
            safeCallback(settings.Callback, currentValue)
        end)
        
        return {
            Element = toggleFrame,
            Set = function(self, value)
                currentValue = value
                createTween(switch, {
                    BackgroundColor3 = currentValue and RayfieldLibrary.CurrentTheme.AccentColor or Color3.fromRGB(100, 100, 100)
                }, TWEEN_INFO_FAST):Play()
                
                createTween(indicator, {
                    Position = currentValue and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                }, TWEEN_INFO_FAST):Play()
            end
        }
    end
    
    -- Create slider
    function Window:CreateSlider(settings)
        settings = settings or {}
        local min, max = settings.Range[1] or 0, settings.Range[2] or 100
        local currentValue = settings.CurrentValue or min
        
        local sliderFrame = createElement("Frame", {
            Name = settings.Name or "Slider",
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = RayfieldLibrary.CurrentTheme.ElementBackground,
            BorderSizePixel = 0
        }, content)
        
        local sliderCorner = createElement("UICorner", {
            CornerRadius = UDim.new(0, 6)
        }, sliderFrame)
        
        local label = createElement("TextLabel", {
            Name = "Label",
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 10, 0, 5),
            BackgroundTransparency = 1,
            Text = settings.Name or "Slider",
            TextColor3 = RayfieldLibrary.CurrentTheme.TextColor,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.Gotham
        }, sliderFrame)
        
        local valueLabel = createElement("TextLabel", {
            Name = "Value",
            Size = UDim2.new(0, 50, 0, 20),
            Position = UDim2.new(1, -60, 0, 5),
            BackgroundTransparency = 1,
            Text = tostring(currentValue),
            TextColor3 = RayfieldLibrary.CurrentTheme.TextColor,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Right,
            Font = Enum.Font.Gotham
        }, sliderFrame)
        
        local track = createElement("Frame", {
            Name = "Track",
            Size = UDim2.new(1, -20, 0, 4),
            Position = UDim2.new(0, 10, 1, -15),
            BackgroundColor3 = Color3.fromRGB(100, 100, 100),
            BorderSizePixel = 0
        }, sliderFrame)
        
        local trackCorner = createElement("UICorner", {
            CornerRadius = UDim.new(0, 2)
        }, track)
        
        local fill = createElement("Frame", {
            Name = "Fill",
            Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0),
            BackgroundColor3 = RayfieldLibrary.CurrentTheme.AccentColor,
            BorderSizePixel = 0
        }, track)
        
        local fillCorner = createElement("UICorner", {
            CornerRadius = UDim.new(0, 2)
        }, fill)
        
        -- Dragging logic
        local dragging = false
        
        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        Services.UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        Services.UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mouse = Services.UserInputService:GetMouseLocation()
                local trackPos = track.AbsolutePosition.X
                local trackSize = track.AbsoluteSize.X
                local relativePos = math.clamp((mouse.X - trackPos) / trackSize, 0, 1)
                
                currentValue = min + (max - min) * relativePos
                if settings.Increment then
                    currentValue = math.floor(currentValue / settings.Increment + 0.5) * settings.Increment
                end
                currentValue = math.clamp(currentValue, min, max)
                
                -- Update UI
                fill.Size = UDim2.new(relativePos, 0, 1, 0)
                valueLabel.Text = tostring(currentValue)
                
                safeCallback(settings.Callback, currentValue)
            end
        end)
        
        return {
            Element = sliderFrame,
            Set = function(self, value)
                currentValue = math.clamp(value, min, max)
                local relativePos = (currentValue - min) / (max - min)
                createTween(fill, {Size = UDim2.new(relativePos, 0, 1, 0)}, TWEEN_INFO_FAST):Play()
                valueLabel.Text = tostring(currentValue)
            end
        }
    end
    
    return Window
end

-- Notification system (simplified)
function RayfieldLibrary:Notify(settings)
    settings = settings or {}
    
    local notification = createElement("Frame", {
        Name = "Notification",
        Size = UDim2.new(0, 300, 0, 60),
        Position = UDim2.new(1, -320, 0, 20),
        BackgroundColor3 = RayfieldLibrary.CurrentTheme.ElementBackground,
        BorderSizePixel = 0
    })
    
    if gethui then
        notification.Parent = gethui()
    else
        notification.Parent = Services.CoreGui
    end
    
    local corner = createElement("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, notification)
    
    local title = createElement("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = settings.Title or "Notification",
        TextColor3 = RayfieldLibrary.CurrentTheme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold
    }, notification)
    
    local content = createElement("TextLabel", {
        Name = "Content",
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 25),
        BackgroundTransparency = 1,
        Text = settings.Content or "",
        TextColor3 = RayfieldLibrary.CurrentTheme.TextColor,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Font = Enum.Font.Gotham
    }, notification)
    
    -- Animate in
    notification.Position = UDim2.new(1, 0, 0, 20)
    createTween(notification, {Position = UDim2.new(1, -320, 0, 20)}, TWEEN_INFO_NORMAL):Play()
    
    -- Auto dismiss
    task.wait(settings.Duration or 3)
    createTween(notification, {Position = UDim2.new(1, 0, 0, 20)}, TWEEN_INFO_NORMAL):Play()
    task.wait(0.5)
    notification:Destroy()
end

return RayfieldLibrary