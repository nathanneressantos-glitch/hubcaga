-- 💩 CAGA NA ROUPA HUB v2 (Brookhaven - Bola Chiclete Forte)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- ========================
-- PERMISSÃO
-- ========================
local liberados = {
    ["rafa12gamerplay"] = true,
    ["soled_byisaac"] = true
}

-- Licenças temporárias (nick em minúsculo = data de expiração)
local temporarios = {
    ["eofastzzxy"] = DateTime.fromUniversalTime(2026, 11, 4, 23, 59, 59).UnixTimestamp
}

local function VerificarPermissao()
    local nome = string.lower(LocalPlayer.Name)

    if liberados[nome] then
        return true
    end

    local expira = temporarios[nome]
    if expira then
        if os.time() < expira then
            return true
        end
        LocalPlayer:Kick("sua licença de 10 dias expirou")
        return false
    end

    LocalPlayer:Kick("acesso negado otario")
    return false
end
if not VerificarPermissao() then return end

-- Se a licença vencer com ele já dentro do jogo, ele também leva kick
task.spawn(function()
    while task.wait(30) do
        local nome = string.lower(LocalPlayer.Name)
        local expira = temporarios[nome]
        if expira and os.time() >= expira then
            LocalPlayer:Kick("sua licença de 10 dias expirou")
            break
        end
    end
end)

-- ========================
-- SPLASH
-- ========================
local function MostrarSplash()
    local sg = Instance.new("ScreenGui")
    sg.Name = "CagaSplash"
    sg.IgnoreGuiInset = true
    sg.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local bg = Instance.new("Frame", sg)
    bg.Size = UDim2.new(1,0,1,0)
    bg.BackgroundColor3 = Color3.fromRGB(10,10,12)

    local bosta = Instance.new("TextLabel", bg)
    bosta.Size = UDim2.new(0,300,0,180)
    bosta.Position = UDim2.new(0.5,-150,0.32,-90)
    bosta.BackgroundTransparency = 1
    bosta.Text = "💩"
    bosta.TextSize = 150
    bosta.Font = Enum.Font.GothamBold

    local texto = Instance.new("TextLabel", bg)
    texto.Size = UDim2.new(1,-40,0,70)
    texto.Position = UDim2.new(0,20,0.55,0)
    texto.BackgroundTransparency = 1
    texto.Text = "caga na roupa hub\nsomente na pirulito store"
    texto.TextColor3 = Color3.fromRGB(0,255,140)
    texto.Font = Enum.Font.GothamBold
    texto.TextSize = 22
    texto.TextWrapped = true

    task.wait(2.6)
    TweenService:Create(bg, TweenInfo.new(0.55), {BackgroundTransparency = 1}):Play()
    TweenService:Create(bosta, TweenInfo.new(0.55), {TextTransparency = 1}):Play()
    TweenService:Create(texto, TweenInfo.new(0.55), {TextTransparency = 1}):Play()
    task.wait(0.6)
    sg:Destroy()
end
MostrarSplash()

-- ========================
-- CONFIG
-- ========================
local Config = {
    Active = {
        DesarmeAuto = false,
        AntiPulo = false,
        Speed = false,
        AntiLag = false,
        LagNet = false,
        SuperShoot = false,
        AtravessarDisfarcado = false,
        AtravessarSupremo = false,
        BolaChiclete = false,
        ConducaoSuave = false,
        Otimizacao = false,
        TiraCabeca = false,
        TPLag = false,
        Reach = false
    },
    Values = {
        Speed = 25,
        TackleRange = 10
    }
}

local Cache = {
    Character = nil,
    RootPart = nil,
    Humanoid = nil
}

local massParts = {}
local bolaCache = nil

-- ========================
-- FUNÇÕES
-- ========================
local function UpdateChar()
    Cache.Character = LocalPlayer.Character
    if Cache.Character then
        Cache.RootPart = Cache.Character:FindFirstChild("HumanoidRootPart")
        Cache.Humanoid = Cache.Character:FindFirstChildOfClass("Humanoid")
    end
end
UpdateChar()
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    UpdateChar()
    bolaCache = nil
end)

local function GetBall()
    if bolaCache and bolaCache.Parent and bolaCache:IsDescendantOf(workspace) then
        return bolaCache
    end

    local nomes = {"SoccerBall", "Ball", "Football", "Bola", "Soccer Ball", "soccerball", "ball"}
    for _, nome in ipairs(nomes) do
        local ball = workspace:FindFirstChild(nome)
        if ball then
            if ball:IsA("BasePart") then
                bolaCache = ball
                return ball
            elseif ball:IsA("Model") then
                local part = ball:FindFirstChildWhichIsA("BasePart")
                if part then
                    bolaCache = part
                    return part
                end
            end
        end
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local n = obj.Name:lower()
            if (n:find("ball") or n:find("bola") or n:find("soccer")) and obj.Size.Magnitude < 5.5 then
                bolaCache = obj
                return obj
            end
        end
    end

    return nil
end

local function AtravessarDisfarcado()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CanCollide = false
            end
        end
    end
end

local function AtravessarSupremo()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            for _, part in ipairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    part.CanTouch = false
                end
            end
        end
    end
end

local function DesarmeAuto()
    local ball = GetBall()
    if not ball or not Cache.RootPart then return end
    local myPos = Cache.RootPart.Position
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if root and (root.Position - myPos).Magnitude < Config.Values.TackleRange then
                pcall(function()
                    ball.CFrame = Cache.RootPart.CFrame * CFrame.new(0, 1.5, -2.5)
                    ball.AssemblyLinearVelocity = Vector3.zero
                end)
            end
        end
    end
end

local function OptimizeBall()
    local ball = GetBall()
    if not ball then return end
    pcall(function()
        ball:SetNetworkOwner(LocalPlayer)
        if ball.AssemblyLinearVelocity.Magnitude > 90 then
            ball.AssemblyLinearVelocity = ball.AssemblyLinearVelocity * 0.8
        end
    end)
end

-- BOLA CHICLETE FORTE
local function BolaChiclete()
    local ball = GetBall()
    local root = Cache.RootPart
    if not ball or not root then return end

    pcall(function()
        ball:SetNetworkOwner(LocalPlayer)
        ball.CFrame = root.CFrame * CFrame.new(0, -1.35, -1.1)
        ball.AssemblyLinearVelocity = Vector3.zero
        ball.AssemblyAngularVelocity = Vector3.zero
        ball.CanCollide = false
        ball.CanTouch = false
        ball.CanQuery = false
    end)
end

local function ConducaoSuave()
    local ball = GetBall()
    if not ball or not Cache.RootPart then return end
    local dist = (ball.Position - Cache.RootPart.Position).Magnitude
    if dist < 11 then
        pcall(function()
            local vel = ball.AssemblyLinearVelocity
            if vel.Magnitude < 7 then
                local dir = (Cache.RootPart.Position - ball.Position).Unit
                ball.AssemblyLinearVelocity = dir * 10
            elseif vel.Magnitude > 42 then
                ball.AssemblyLinearVelocity = vel.Unit * 36
            end
        end)
    end
end

local function AtivarLag()
    pcall(function()
        settings().Network.IncomingReplicationLag = 0.5
        settings().Physics.AllowSleep = true
    end)
end

local function DesativarLag()
    pcall(function()
        settings().Network.IncomingReplicationLag = 0
        settings().Physics.AllowSleep = false
    end)
end

local function AplicarOtimizacao(state)
    pcall(function()
        if state then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 1e9
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") then v.Enabled = false end
            end
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
                    obj.Enabled = false
                end
            end
        else
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
            Lighting.GlobalShadows = true
        end
    end)
end

local function TiraCabeca(state)
    local char = LocalPlayer.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = state and 1 or 0
    end
end

local function removeMasses()
    for _, part in ipairs(massParts) do
        if part and part.Parent then part:Destroy() end
    end
    massParts = {}
end

local function reinforceCharacter()
    local char = LocalPlayer.Character
    if not char then return end
    removeMasses()

    for _, v in ipairs(char:GetChildren()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            for i = 1, 4 do
                local scale = 0.85 - (i-1) * 0.08
                local mass = Instance.new("Part")
                mass.Name = "InternalMass"
                mass.Size = v.Size * scale
                mass.CFrame = v.CFrame
                mass.Transparency = 1
                mass.CanCollide = false
                mass.CanTouch = false
                mass.CanQuery = false
                mass.Massless = false
                mass.CustomPhysicalProperties = PhysicalProperties.new(12.8 * 1.7, 0, 0, 0, 0)
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = v
                weld.Part1 = mass
                weld.Parent = mass
                mass.Parent = v
                table.insert(massParts, mass)
            end
        end
    end
end

-- ========================
-- GUI
-- ========================
local function CreateHub()
    local sg = Instance.new("ScreenGui")
    sg.Name = "CagaNaRoupaHub"
    sg.ResetOnSpawn = false
    sg.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 540, 0, 380)
    main.Position = UDim2.new(0.5, -270, 0.5, -190)
    main.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    main.Active = true
    main.Draggable = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

    local header = Instance.new("Frame", main)
    header.Size = UDim2.new(1, 0, 0, 42)
    header.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -50, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "💩  Caga na Roupa Hub v2"
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left

    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -38, 0.5, -16)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)

    local sidebar = Instance.new("Frame", main)
    sidebar.Size = UDim2.new(0, 155, 1, -42)
    sidebar.Position = UDim2.new(0, 0, 0, 42)
    sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)

    local content = Instance.new("Frame", main)
    content.Size = UDim2.new(1, -155, 1, -42)
    content.Position = UDim2.new(0, 155, 0, 42)
    content.BackgroundColor3 = Color3.fromRGB(26, 26, 30)

    local function ClearContent()
        for _, v in ipairs(content:GetChildren()) do v:Destroy() end
    end

    local function CreateToggle(parent, text, key, y)
        local frame = Instance.new("Frame", parent)
        frame.Size = UDim2.new(1, -20, 0, 34)
        frame.Position = UDim2.new(0, 10, 0, y)
        frame.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(1, -55, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(220,220,220)
        label.Font = Enum.Font.Gotham
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left

        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(0, 44, 0, 22)
        btn.Position = UDim2.new(1, -48, 0.5, -11)
        btn.BackgroundColor3 = Color3.fromRGB(50,50,55)
        btn.Text = ""
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)

        local circle = Instance.new("Frame", btn)
        circle.Size = UDim2.new(0, 16, 0, 16)
        circle.Position = UDim2.new(0, 3, 0.5, -8)
        circle.BackgroundColor3 = Color3.fromRGB(180,180,180)
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

        local function Update(state)
            if state then
                btn.BackgroundColor3 = Color3.fromRGB(0,170,90)
                circle.Position = UDim2.new(1, -19, 0.5, -8)
                circle.BackgroundColor3 = Color3.new(1,1,1)
            else
                btn.BackgroundColor3 = Color3.fromRGB(50,50,55)
                circle.Position = UDim2.new(0, 3, 0.5, -8)
                circle.BackgroundColor3 = Color3.fromRGB(180,180,180)
            end
        end

        btn.MouseButton1Click:Connect(function()
            Config.Active[key] = not Config.Active[key]
            local state = Config.Active[key]
            Update(state)

            if key == "Speed" and Cache.Humanoid then
                Cache.Humanoid.WalkSpeed = state and Config.Values.Speed or 16
            elseif key == "AntiPulo" and Cache.Humanoid then
                Cache.Humanoid.JumpPower = state and 0 or 50
            elseif key == "LagNet" then
                if state then AtivarLag() else DesativarLag() end
            elseif key == "Otimizacao" then
                AplicarOtimizacao(state)
            elseif key == "TiraCabeca" then
                TiraCabeca(state)
            elseif key == "SuperShoot" then
                if state then reinforceCharacter() else removeMasses() end
            elseif key == "BolaChiclete" and not state then
                local ball = GetBall()
                if ball then
                    pcall(function()
                        ball.CanCollide = true
                        ball.CanTouch = true
                        ball.CanQuery = true
                    end)
                end
            elseif key == "Reach" and state then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/wrestonbest/Helixia-2026/refs/heads/main/Universal%20Reach/v1.lua"))()
            end
        end)

        Update(Config.Active[key])
    end

    local function ShowPage(name)
        ClearContent()

        if name == "Zaga" then
            CreateToggle(content, "Desarme Auto", "DesarmeAuto", 12)
            CreateToggle(content, "Anti Pulo", "AntiPulo", 48)
            CreateToggle(content, "Speed", "Speed", 84)
            CreateToggle(content, "Anti-Lag", "AntiLag", 120)
            CreateToggle(content, "Lag Net", "LagNet", 156)
            CreateToggle(content, "SuperShoot", "SuperShoot", 192)
        elseif name == "Ataque" then
            CreateToggle(content, "Atravessar Disfarçado", "AtravessarDisfarcado", 12)
            CreateToggle(content, "Atravessar Supremo", "AtravessarSupremo", 48)
            CreateToggle(content, "Bola Chiclete", "BolaChiclete", 84)
            CreateToggle(content, "Condução Suave", "ConducaoSuave", 120)
            CreateToggle(content, "SuperShoot", "SuperShoot", 156)
        elseif name == "Otimizacao" then
            CreateToggle(content, "Otimização (FPS)", "Otimizacao", 12)
            CreateToggle(content, "Tira Cabeça", "TiraCabeca", 48)
        elseif name == "TP" then
            CreateToggle(content, "TP (Efeito Lag)", "TPLag", 12)
        elseif name == "Reach" then
            CreateToggle(content, "Universal Reach", "Reach", 12)
        end
    end

    local function CreateSidebarBtn(text, page, y)
        local btn = Instance.new("TextButton", sidebar)
        btn.Size = UDim2.new(1, -10, 0, 34)
        btn.Position = UDim2.new(0, 5, 0, y)
        btn.BackgroundColor3 = Color3.fromRGB(28,28,34)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(200,200,200)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 12
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        btn.MouseButton1Click:Connect(function()
            ShowPage(page)
            for _, b in ipairs(sidebar:GetChildren()) do
                if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(28,28,34) end
            end
            btn.BackgroundColor3 = Color3.fromRGB(0,140,80)
        end)
    end

    CreateSidebarBtn("Caga na Roupa Zaga", "Zaga", 12)
    CreateSidebarBtn("Caga na Roupa Ataque", "Ataque", 50)
    CreateSidebarBtn("Otimização", "Otimizacao", 88)
    CreateSidebarBtn("Caga na Roupa TP", "TP", 126)
    CreateSidebarBtn("Caga no Reach", "Reach", 164)

    local float = Instance.new("TextButton", sg)
    float.Size = UDim2.new(0, 48, 0, 48)
    float.Position = UDim2.new(0.02, 0, 0.5, -24)
    float.BackgroundColor3 = Color3.fromRGB(0,180,90)
    float.Text = "💩"
    float.TextSize = 20
    Instance.new("UICorner", float).CornerRadius = UDim.new(1,0)
    float.MouseButton1Click:Connect(function()
        main.Visible = not main.Visible
    end)

    ShowPage("Zaga")
end

-- ========================
-- LOOP
-- ========================
RunService.Heartbeat:Connect(function()
    if Config.Active.AtravessarDisfarcado then AtravessarDisfarcado() end
    if Config.Active.AtravessarSupremo then AtravessarSupremo() end
    if Config.Active.DesarmeAuto then DesarmeAuto() end
    if Config.Active.AntiLag then OptimizeBall() end
    if Config.Active.BolaChiclete then BolaChiclete() end
    if Config.Active.ConducaoSuave then ConducaoSuave() end

    if Config.Active.SuperShoot then
        local ball = GetBall()
        local root = Cache.RootPart
        if ball and root then
            local dist = (ball.Position - root.Position).Magnitude
            if dist < 5.5 then
                pcall(function()
                    ball.AssemblyLinearVelocity = root.CFrame.LookVector * 210
                end)
            end
        end
    end
end)

CreateHub()
print("✅ Caga na Roupa Hub v2 carregado!")
