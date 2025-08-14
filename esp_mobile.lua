--[[
ESP Móvel On/Off - Feito para KRNL
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ESP_ENABLED = false
local ESP_STORAGE = {}

-- Função para criar ESP
local function createESP(player)
    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
        local BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Name = "ESP"
        BillboardGui.Adornee = player.Character.Head
        BillboardGui.Size = UDim2.new(0, 200, 0, 50)
        BillboardGui.StudsOffset = Vector3.new(0, 2, 0)
        BillboardGui.AlwaysOnTop = true

        local TextLabel = Instance.new("TextLabel")
        TextLabel.Parent = BillboardGui
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = player.Name
        TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        TextLabel.TextStrokeTransparency = 0.5
        TextLabel.Font = Enum.Font.SourceSansBold
        TextLabel.TextScaled = true

        BillboardGui.Parent = player.Character.Head
        ESP_STORAGE[player] = BillboardGui
    end
end

-- Função para ativar ESP
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

-- Função para desativar ESP
local function disableESP()
    for _, gui in pairs(ESP_STORAGE) do
        if gui then
            gui:Destroy()
        end
    end
    ESP_STORAGE = {}
end

-- Criar botão para Mobile
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

-- Bordas arredondadas
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Button

-- Efeito de clique
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
