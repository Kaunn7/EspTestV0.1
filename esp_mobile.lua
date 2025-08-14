--[[
ESP Móvel On/Off - KRNL
Botão movível, box ESP, nome pequeno preto com borda bege
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ESP_ENABLED = false
local ESP_STORAGE = {}

-- Função para criar ESP Box
local function createESP(player)
    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        -- Caixa
        local box = Instance.new("BoxHandleAdornment")
        box.Adornee = player.Character:FindFirstChild("HumanoidRootPart")
        box.Size = Vector3.new(2, 5, 1) -- Ajuste conforme personagem
        box.Transparency = 0.5
        box.Color3 = Color3.fromRGB(255, 0, 0)
        box.AlwaysOnTop = true
        box.ZIndex = 2
        box.Parent = workspace

        -- Nome
        local BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Name = "ESP_Name"
        BillboardGui.Adornee = player.Character.Head
        BillboardGui.Size = UDim2.new(0, 100, 0, 25)
        BillboardGui.StudsOffset = Vector3.new(0, 2, 0)
        BillboardGui.AlwaysOnTop = true

        local TextLabel = Instance.new("TextLabel")
        TextLabel.Parent = BillboardGui
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = player.Name
        TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel.TextStrokeColor3 = Color3.fromRGB(245, 222, 179) -- Bege
        TextLabel.TextStrokeTransparency = 0
        TextLabel.Font = Enum.Font.SourceSansBold
        TextLabel.TextScaled = true

        BillboardGui.Parent = player.Character.Head

        ESP_STORAGE[player] = {Box = box, Name = BillboardGui}
    end
end

-- Ativar ESP
local function enableESP()
    for _, player in pairs(Players:GetPlayers()) do
        if not ESP_STORAGE[player] then
            createESP(player)
        end
    end

    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            createESP(player)
        end)
    end)
end

-- Desativar ESP
local function disableESP()
    for _, data in pairs(ESP_STORAGE) do
        if data.Box then data.Box:Destroy() end
        if data.Name then data.Name:Destroy() end
    end
    ESP_STORAGE = {}
end

-- Criar botão móvel
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")

local Button = Instance.new("TextButton")
Button.Parent = ScreenGui
Button.Size = UDim2.new(0, 120, 0, 50)
Button.Position = UDim2.new(0.05, 0, 0.1, 0)
Button.Text = "ESP: OFF"
Button.TextColor3 = Color3.new(1, 1, 1)
Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Button.Font = Enum.Font.SourceSansBold
Button.TextScaled = true
Button.BackgroundTransparency = 0.2

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Button

-- Botão movível
local dragging = false
local dragInput, mousePos, framePos

Button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = Button.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - mousePos
        Button.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X,
                                    framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

-- Alternar ESP
Button.MouseButton1Click:Connect(function()
    ESP_ENABLED = not ESP_ENABLED
    if ESP_ENABLED then
        Button.Text = "ESP: ON"
        Button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        enableESP()
    else
        Button.Text = "ESP: OFF"
        Button.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        disableESP()
    end
end)
