-- CoreFly Noclip v6.2 (by nixsize | special thanks to impaer)
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Noclip Controller
local NoclipController = {
    Active = false,
    Character = nil,
    Humanoid = nil,
    Speed = 1.2,
    Immortality = true
}

-- Создание перемещаемого GUI
local CoreGui = game:GetService("CoreGui")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PhysicsDebugger"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 90)
MainFrame.Position = UDim2.new(0.5, -110, 0.8, -45)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 1000
MainFrame.Parent = ScreenGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 25)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "CORE NOCLIP v6.2"
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 18
TitleLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
TitleLabel.Parent = MainFrame

local AuthorLabel = Instance.new("TextLabel")
AuthorLabel.Size = UDim2.new(1, 0, 0, 20)
AuthorLabel.Position = UDim2.new(0, 0, 0.25, 0)
AuthorLabel.BackgroundTransparency = 1
AuthorLabel.Text = "Created by nixsize | Special thanks to impaer"
AuthorLabel.Font = Enum.Font.SourceSans
AuthorLabel.TextSize = 14
AuthorLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
AuthorLabel.Parent = MainFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.9, 0, 0, 30)
ToggleButton.Position = UDim2.new(0.05, 0, 0.6, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ToggleButton.TextColor3 = Color3.fromRGB(200, 200, 255)
ToggleButton.Text = "NOCLIP: OFF"
ToggleButton.Font = Enum.Font.Code
ToggleButton.TextSize = 14
ToggleButton.BorderSizePixel = 0
ToggleButton.ZIndex = 1001
ToggleButton.Parent = MainFrame

-- Перемещение GUI
local dragging, dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Защитные функции
local function SecureCall(func, ...)
    local success, result = pcall(func, ...)
    return success
end

local function ObfuscatedSetProperty(object, property, value)
    SecureCall(function()
        object[property] = value
    end)
end

-- Инициализация персонажа с бессмертием
local function SetupCharacter()
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    
    SecureCall(function()
        -- Критическое исправление: отключаем смерть
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        
        -- Делаем персонажа бессмертным
        if NoclipController.Immortality then
            Humanoid.MaxHealth = math.huge
            Humanoid.Health = math.huge
        end
    end)
    
    return Character, Humanoid
end

-- Обновление персонажа при смерти
Player.CharacterAdded:Connect(function(character)
    NoclipController.Character, NoclipController.Humanoid = SetupCharacter()
end)

NoclipController.Character, NoclipController.Humanoid = SetupCharacter()

-- Переключение режима Noclip
ToggleButton.MouseButton1Click:Connect(function()
    NoclipController.Active = not NoclipController.Active
    ToggleButton.Text = "NOCLIP: " .. (NoclipController.Active and "ON" or "OFF")
    ToggleButton.BackgroundColor3 = NoclipController.Active and Color3.fromRGB(60, 30, 30) or Color3.fromRGB(40, 40, 50)
    
    if NoclipController.Active then
        TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
        -- Активируем бессмертие при включении
        if NoclipController.Humanoid then
            ObfuscatedSetProperty(NoclipController.Humanoid, "MaxHealth", math.huge)
            ObfuscatedSetProperty(NoclipController.Humanoid, "Health", math.huge)
        end
    else
        TitleLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    end
end)

-- Основной цикл Noclip
RunService.Stepped:Connect(function()
    if not NoclipController.Character or not NoclipController.Character.Parent then
        NoclipController.Character, NoclipController.Humanoid = SetupCharacter()
    end
    
    -- Отключение коллизий
    for _, part in ipairs(NoclipController.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            ObfuscatedSetProperty(part, "CanCollide", not NoclipController.Active)
            if NoclipController.Active then
                ObfuscatedSetProperty(part, "Velocity", Vector3.new())
                ObfuscatedSetProperty(part, "RotVelocity", Vector3.new())
                ObfuscatedSetProperty(part, "AssemblyLinearVelocity", Vector3.new())
                ObfuscatedSetProperty(part, "AssemblyAngularVelocity", Vector3.new())
            end
        end
    end
    
    -- Механика прохождения сквозь стены
    if NoclipController.Active and NoclipController.Humanoid then
        -- Критическое исправление: сохраняем состояние Humanoid
        if NoclipController.Humanoid:GetState() == Enum.HumanoidStateType.Dead then
            NoclipController.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
        
        local hrp = NoclipController.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local moveVector = Vector3.new()
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveVector = moveVector + Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveVector = moveVector - Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveVector = moveVector + Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveVector = moveVector - Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveVector = moveVector + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveVector = moveVector - Vector3.new(0, 1, 0)
            end
            
            if moveVector.Magnitude > 0 then
                moveVector = moveVector.Unit * NoclipController.Speed
                ObfuscatedSetProperty(hrp, "CFrame", hrp.CFrame + moveVector)
            end
        end
    end
end)

-- Защита от обнаружения
spawn(function()
    while true do
        wait(math.random(10, 20))
        
        SecureCall(function()
            -- Изменение внешнего вида GUI
            MainFrame.BackgroundColor3 = Color3.fromRGB(
                math.random(20, 30),
                math.random(20, 30),
                math.random(30, 40)
            )
            
            -- Ложные вызовы API
            workspace:GetRealPhysicsFPS()
            game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
    end
end)

warn("CoreFly NOCLIP v6.2 initialized | by nixsize | special thanks to impaer")
