--==================================================
-- BLOOD HUB FINAL COMPLETE
-- UI: BloodHub | Logic: BananaHub-style
--==================================================

---------------- SERVICES ----------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer

---------------- CONFIG ------------------
local Config = {
    Minimized = false,

    ESP_Mob = false,
    ESP_Fruit = false,

    AutoFarm = false,
    Hitbox = false,
    HitboxSize = 60,
}

---------------- FAST ATTACK DATA --------
_G.FastAttackData = {
    Enabled = false,
    Mode = "Super Fast Attack",
    Delay = 1e-9
}

---------------- WEAPON DATA -------------
ChooseWeapon = "Melee"   -- Melee | Sword | Blox Fruit
SelectWeapon = nil

---------------- CLEAN -------------------
if game.CoreGui:FindFirstChild("BloodHub_UI") then
    game.CoreGui.BloodHub_UI:Destroy()
end

---------------- UI ----------------------
local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "BloodHub_UI"
Gui.ResetOnSpawn = false

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0,420,0,340)
Main.Position = UDim2.new(0.05,0,0.1,0)
Main.BackgroundColor3 = Color3.fromRGB(18,18,20)
Main.BorderSizePixel = 0
Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,10)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,-40,0,36)
Title.Position = UDim2.new(0,10,0,0)
Title.BackgroundTransparency = 1
Title.Text = "🩸 BloodHub | FINAL"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(255,80,80)
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0,32,0,32)
MinBtn.Position = UDim2.new(1,-36,0,2)
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 20
MinBtn.BackgroundColor3 = Color3.fromRGB(80,40,40)
MinBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", MinBtn)

---------------- DRAG --------------------
do
    local dragging, startPos, dragStart
    Main.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true
            dragStart=i.Position
            startPos=Main.Position
            i.Changed:Connect(function()
                if i.UserInputState==Enum.UserInputState.End then dragging=false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-dragStart
            Main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
        end
    end)
end

---------------- TAB BAR -----------------
local TabBar = Instance.new("Frame", Main)
TabBar.Size = UDim2.new(1,-20,0,34)
TabBar.Position = UDim2.new(0,10,0,40)
TabBar.BackgroundTransparency = 1

local function tabBtn(text,x)
    local b=Instance.new("TextButton",TabBar)
    b.Size=UDim2.new(0.5,-5,1,0)
    b.Position=UDim2.new(x,0,0,0)
    b.Text=text
    b.Font=Enum.Font.GothamBold
    b.TextSize=14
    b.BackgroundColor3=Color3.fromRGB(35,35,40)
    b.TextColor3=Color3.new(1,1,1)
    Instance.new("UICorner",b)
    return b
end

local EspTabBtn = tabBtn("ESP",0)
local FarmTabBtn = tabBtn("FARM",0.5)

---------------- HOLDERS -----------------
local EspHolder = Instance.new("Frame", Main)
EspHolder.Size = UDim2.new(1,-20,1,-90)
EspHolder.Position = UDim2.new(0,10,0,80)
EspHolder.BackgroundTransparency = 1

local FarmHolder = EspHolder:Clone()
FarmHolder.Parent = Main
FarmHolder.Visible = false

local function list(h)
    local l=Instance.new("UIListLayout",h)
    l.Padding=UDim.new(0,8)
end
list(EspHolder); list(FarmHolder)

---------------- TOGGLE ------------------
local function toggle(parent,text,cb)
    local b=Instance.new("TextButton",parent)
    b.Size=UDim2.new(1,0,0,36)
    b.BackgroundColor3=Color3.fromRGB(30,30,35)
    b.TextColor3=Color3.fromRGB(220,220,220)
    b.Font=Enum.Font.GothamBold
    b.TextSize=14
    b.Text=text..": OFF"
    Instance.new("UICorner",b)
    local st=false
    b.MouseButton1Click:Connect(function()
        st=not st
        b.Text=text..(st and ": ON" or ": OFF")
        b.BackgroundColor3=st and Color3.fromRGB(60,120,60) or Color3.fromRGB(30,30,35)
        cb(st)
    end)
end

---------------- SLIDER ------------------
local function slider(parent,text,min,max,def,cb)
    local f=Instance.new("Frame",parent)
    f.Size=UDim2.new(1,0,0,50)
    f.BackgroundColor3=Color3.fromRGB(30,30,35)
    Instance.new("UICorner",f)

    local l=Instance.new("TextLabel",f)
    l.Size=UDim2.new(1,-10,0,20)
    l.Position=UDim2.new(0,5,0,2)
    l.BackgroundTransparency=1
    l.Font=Enum.Font.GothamBold
    l.TextSize=13
    l.TextColor3=Color3.fromRGB(220,220,220)
    l.Text=text..": "..def

    local bar=Instance.new("Frame",f)
    bar.Size=UDim2.new(1,-20,0,6)
    bar.Position=UDim2.new(0,10,0,30)
    bar.BackgroundColor3=Color3.fromRGB(50,50,55)
    Instance.new("UICorner",bar)

    local fill=Instance.new("Frame",bar)
    fill.Size=UDim2.new((def-min)/(max-min),0,1,0)
    fill.BackgroundColor3=Color3.fromRGB(120,80,80)
    Instance.new("UICorner",fill)

    local drag=false
    bar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local x=math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
            fill.Size=UDim2.new(x,0,1,0)
            local v=math.floor(min+(max-min)*x)
            l.Text=text..": "..v
            cb(v)
        end
    end)
end

---------------- TAB LOGIC ---------------
EspTabBtn.MouseButton1Click:Connect(function()
    EspHolder.Visible=true; FarmHolder.Visible=false
end)
FarmTabBtn.MouseButton1Click:Connect(function()
    EspHolder.Visible=false; FarmHolder.Visible=true
end)

---------------- MINIMIZE (GUI ONLY) -----
MinBtn.MouseButton1Click:Connect(function()
    Config.Minimized=not Config.Minimized
    if Config.Minimized then
        EspHolder.Visible=false
        FarmHolder.Visible=false
        TabBar.Visible=false
        Title.Visible=false
        Main.Size=UDim2.new(0,140,0,40)
        Main.Active=false
        MinBtn.Text="+"
    else
        Main.Size=UDim2.new(0,420,0,340)
        EspHolder.Visible=true
        FarmHolder.Visible=false
        TabBar.Visible=true
        Title.Visible=true
        Main.Active=true
        MinBtn.Text="-"
    end
end)

---------------- LOGIC -------------------
local function getEnemies()
    return workspace:FindFirstChild("Enemies")
end

local function getNet()
    local m=ReplicatedStorage:FindFirstChild("Modules")
    return m and m:FindFirstChild("Net")
end

local function getIsland()
    local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not workspace:FindFirstChild("Map") then return nil end
    local best,dist=nil,math.huge
    for _,m in pairs(workspace.Map:GetChildren()) do
        local p=m:FindFirstChildWhichIsA("BasePart",true)
        if p then
            local d=(hrp.Position-p.Position).Magnitude
            if d<dist then dist=d; best=m end
        end
    end
    return best
end

local function mobInIsland(e,island)
    local hrp=e:FindFirstChild("HumanoidRootPart")
    local p=island and island:FindFirstChildWhichIsA("BasePart",true)
    return hrp and p and (hrp.Position-p.Position).Magnitude<2000
end

task.spawn(function()
    while task.wait() do
        if _G.FastAttackData.Enabled then
            pcall(function()
                if _G.FastAttackData.Mode == "Super Fast Attack" then
                    _G.Fast_Delay = _G.FastAttackData.Delay
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local bp = LP.Backpack
            if not bp then return end

            for _,tool in pairs(bp:GetChildren()) do
                if ChooseWeapon == "Melee" and tool.ToolTip == "Melee" then
                    SelectWeapon = tool.Name
                    break
                elseif ChooseWeapon == "Sword" and tool.ToolTip == "Sword" then
                    SelectWeapon = tool.Name
                    break
                elseif ChooseWeapon == "Blox Fruit" and tool.ToolTip == "Blox Fruit" then
                    SelectWeapon = tool.Name
                    break
                end
            end
        end)
    end
end)

---------------- ESP ---------------------
local DrawingOK = type(Drawing)=="table"
local espMob,espFruit={},{}
local function clear(t) for _,d in pairs(t) do pcall(function() d:Remove() end) end table.clear(t) end

local function espMobUpdate()
    if not DrawingOK or not Config.ESP_Mob then clear(espMob); return end
    local island=getIsland(); local Enemies=getEnemies()
    if not island or not Enemies then return end
    for _,e in pairs(Enemies:GetChildren()) do
        local hrp=e:FindFirstChild("HumanoidRootPart")
        local hum=e:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.Health>0 and mobInIsland(e,island) then
            if not espMob[e] then
                local t=Drawing.new("Text")
                t.Size=14; t.Center=true; t.Outline=true
                t.Color=Color3.fromRGB(255,80,80)
                espMob[e]=t
            end
            local pos,on=Camera:WorldToViewportPoint(hrp.Position)
            local d=espMob[e]; d.Visible=on
            if on then d.Text=e.Name; d.Position=Vector2.new(pos.X,pos.Y) end
        end
    end
end

---------------- HITBOX + FARM -----------
local saved={}
local function applyHitbox()
    local Enemies=getEnemies(); if not Enemies then return end
    if not Config.Hitbox then
        for e,s in pairs(saved) do
            if e:FindFirstChild("HumanoidRootPart") then
                e.HumanoidRootPart.Size=s
            end
        end
        table.clear(saved)
        return
    end
    for _,e in pairs(Enemies:GetChildren()) do
        local hrp=e:FindFirstChild("HumanoidRootPart")
        if hrp then
            if not saved[e] then saved[e]=hrp.Size end
            hrp.Size=Vector3.new(Config.HitboxSize,Config.HitboxSize,Config.HitboxSize)
            hrp.CanCollide=false
            hrp.Transparency=0.6
        end
    end
end

local function autoFarm()
    if not Config.AutoFarm then return end
    local char=LP.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart")
    local Enemies=getEnemies(); local Net=getNet()
    local island=getIsland()
    if not hrp or not Enemies or not Net or not island then return end

    if SelectWeapon then
    local tool = LP.Backpack:FindFirstChild(SelectWeapon)
    if tool then tool.Parent = LP.Character end
end

    for _,e in pairs(Enemies:GetChildren()) do
        local ehrp=e:FindFirstChild("HumanoidRootPart")
        local hum=e:FindFirstChildOfClass("Humanoid")
        if ehrp and hum and hum.Health>0 and mobInIsland(e,island) then
            hrp.CFrame=ehrp.CFrame*CFrame.new(0,0,-3)
            pcall(function()
                Net:FireServer("RegisterAttack")
                Net:FireServer("RegisterHit",ehrp)
            end)
            break
        end
    end
end

---------------- ANTI AFK ----------------
LP.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0),Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0),Camera.CFrame)
end)

---------------- TOGGLES -----------------
toggle(EspHolder,"ESP MOB",function(v) Config.ESP_Mob=v end)
toggle(FarmHolder,"AUTO FARM",function(v) Config.AutoFarm=v end)
do
    local modes = {"Melee","Sword","Blox Fruit"}
    local idx = 1

    local b = Instance.new("TextButton", FarmHolder)
    b.Size = UDim2.new(1,0,0,36)
    b.BackgroundColor3 = Color3.fromRGB(30,30,35)
    b.TextColor3 = Color3.fromRGB(220,220,220)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.Text = "WEAPON: "..modes[idx]
    Instance.new("UICorner", b)

    b.MouseButton1Click:Connect(function()
        idx = idx % #modes + 1
        ChooseWeapon = modes[idx]
        b.Text = "WEAPON: "..ChooseWeapon
    end)
end
toggle(FarmHolder,"SUPER FAST ATTACK",function(v)
    _G.FastAttackData.Enabled = v 
end)
toggle(FarmHolder,"HITBOX",function(v) Config.Hitbox=v end)
textbox(FarmHolder,"HITBOX SIZE",tostring(Config.HitboxSize),function(v)
    local size = tonumber(v)
    if size and size >= 4 and size <= 25 then
    Config.HitboxSize = size
end)

---------------- LOOP --------------------
RunService.RenderStepped:Connect(function()
    espMobUpdate()
    applyHitbox()
    autoFarm()
end)

print("[BloodHub] FINAL LOADED ✔")
