--[[
Obsidian.kys
Made by 1ksuwu
]]
--[[
    Obsidian Key System Library
    Layout based on AirFlow, Theme based on Obsidian
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- Safe Parent Target
local function GetGuiParent()
    local success, parent = pcall(function()
        if gethui then
            return gethui()
        end
        return CoreGui
    end)
    if success and parent then
        return parent
    end
    local localPlayer = Players.LocalPlayer
    if localPlayer then
        return localPlayer:WaitForChild("PlayerGui")
    end
    return CoreGui
end

local Library = {}

function Library:CreateKeySystem(config)
    config = config or {}
    
    local title = config.Title or "Key system"
    local description = config.Description or "My HUB"
    local iconId = config.Icon or 5437589347
    local supportedGame = config.SupportedGame or {}
    local socialLinks = config.SocialLinks or {
        Discord = "dsc.gg/obsidian",
        WebSite = "obsidian.com"
    }
    
    local adsConfig = config.Ads
    local getKeyFunc = config.Getkey or function() end
    local checkKeyFunc = config.CheckKey or function(key) return false end
    
    local Theme = config.Theme or {}
    local BackgroundColor = Theme.BackgroundColor or Color3.fromRGB(15, 15, 15)
    local MainColor = Theme.MainColor or Color3.fromRGB(25, 25, 25)
    local AccentColor = Theme.AccentColor or Color3.fromRGB(125, 85, 255)
    local OutlineColor = Theme.OutlineColor or Color3.fromRGB(40, 40, 40)
    local FontColor = Theme.FontColor or Color3.fromRGB(255, 255, 255)
    local SecondaryFontColor = Theme.SecondaryFontColor or Color3.fromRGB(150, 150, 150)
    local Font = Theme.Font or Font.fromEnum(Enum.Font.Code)
    
    local root = Instance.new("ScreenGui")
    root.Name = "Obsidian_KeySystem"
    root.ResetOnSpawn = false
    root.DisplayOrder = 999
    root.IgnoreGuiInset = true
    root.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Pop in scale
    local uiScale = Instance.new("UIScale")
    uiScale.Scale = 0.85
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 600, 0, 360) -- Slightly taller to fit socials
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = BackgroundColor
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.ClipsDescendants = false
    mainFrame.Parent = root
    
    uiScale.Parent = mainFrame
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 11)
    mainCorner.Parent = mainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = OutlineColor
    mainStroke.Thickness = 1
    mainStroke.Parent = mainFrame
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 50, 1, 50)
    shadow.Position = UDim2.new(0, -25, 0, -25)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.ZIndex = 0
    shadow.Parent = mainFrame
    
    -- Left Panel
    local leftPanel = Instance.new("Frame")
    leftPanel.Name = "LeftPanel"
    leftPanel.Size = UDim2.new(0, 356, 1, 0)
    leftPanel.BackgroundTransparency = 1
    leftPanel.ZIndex = 2
    leftPanel.Parent = mainFrame
    
    -- App Icon
    local appIcon = Instance.new("ImageLabel")
    appIcon.Name = "AppIcon"
    appIcon.Size = UDim2.new(0, 40, 0, 40)
    appIcon.Position = UDim2.new(0, 28, 0, 28)
    appIcon.BackgroundTransparency = 1
    appIcon.Image = "rbxassetid://" .. tostring(iconId)
    appIcon.ImageColor3 = FontColor
    appIcon.ScaleType = Enum.ScaleType.Fit
    appIcon.Parent = leftPanel
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(0, 240, 0, 24)
    titleLabel.Position = UDim2.new(0, 82, 0, 28)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = FontColor
    titleLabel.TextSize = 22
    titleLabel.FontFace = Font
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = leftPanel
    
    -- Description
    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "DescriptionLabel"
    descLabel.Size = UDim2.new(0, 240, 0, 14)
    descLabel.Position = UDim2.new(0, 82, 0, 54)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = SecondaryFontColor
    descLabel.TextSize = 12
    descLabel.FontFace = Font
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = leftPanel
    
    -- Center Divider
    local centerDivider = Instance.new("Frame")
    centerDivider.Name = "CenterDivider"
    centerDivider.Size = UDim2.new(0, 1, 1, -56)
    centerDivider.Position = UDim2.new(0, 356, 0, 28)
    centerDivider.BackgroundColor3 = OutlineColor
    centerDivider.BorderSizePixel = 0
    centerDivider.ZIndex = 2
    centerDivider.Parent = mainFrame
    
    -- Right Panel
    local rightPanel = Instance.new("Frame")
    rightPanel.Name = "RightPanel"
    rightPanel.Size = UDim2.new(0, 244, 1, 0)
    rightPanel.Position = UDim2.new(0, 357, 0, 0)
    rightPanel.BackgroundTransparency = 1
    rightPanel.ZIndex = 2
    rightPanel.Parent = mainFrame
    
    -- Game Info
    local gameTitleLabel = Instance.new("TextLabel")
    gameTitleLabel.Name = "DetectedGameHeader"
    gameTitleLabel.Size = UDim2.new(0, 187, 0, 14)
    gameTitleLabel.Position = UDim2.new(0, 28, 0, 28)
    gameTitleLabel.BackgroundTransparency = 1
    gameTitleLabel.Text = "Detected game"
    gameTitleLabel.TextColor3 = SecondaryFontColor
    gameTitleLabel.TextSize = 12
    gameTitleLabel.FontFace = Font
    gameTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    gameTitleLabel.Parent = rightPanel
    
    local gameCard = Instance.new("Frame")
    gameCard.Name = "GameCard"
    gameCard.Size = UDim2.new(0, 187, 0, 50)
    gameCard.Position = UDim2.new(0, 28, 0, 48)
    gameCard.BackgroundColor3 = MainColor
    gameCard.BorderSizePixel = 0
    gameCard.Parent = rightPanel
    
    local gameCardCorner = Instance.new("UICorner")
    gameCardCorner.CornerRadius = UDim.new(0, 6)
    gameCardCorner.Parent = gameCard
    
    local gameCardStroke = Instance.new("UIStroke")
    gameCardStroke.Color = OutlineColor
    gameCardStroke.Thickness = 1
    gameCardStroke.Parent = gameCard
    
    local gameThumbnail = Instance.new("ImageLabel")
    gameThumbnail.Name = "GameThumbnail"
    gameThumbnail.Size = UDim2.new(0, 32, 0, 32)
    gameThumbnail.Position = UDim2.new(0, 10, 0, 9)
    gameThumbnail.BackgroundColor3 = BackgroundColor
    gameThumbnail.Image = "rbxthumb://type=Asset&id=" .. tostring(game.PlaceId) .. "&w=150&h=150"
    gameThumbnail.ScaleType = Enum.ScaleType.Crop
    gameThumbnail.Parent = gameCard
    
    local gameThumbCorner = Instance.new("UICorner")
    gameThumbCorner.CornerRadius = UDim.new(0, 4)
    gameThumbCorner.Parent = gameThumbnail
    
    local gameNameText = Instance.new("TextLabel")
    gameNameText.Name = "GameName"
    gameNameText.Size = UDim2.new(0, 130, 0, 14)
    gameNameText.Position = UDim2.new(0, 48, 0, 10)
    gameNameText.BackgroundTransparency = 1
    gameNameText.Text = "Loading..."
    gameNameText.TextColor3 = FontColor
    gameNameText.TextSize = 12
    gameNameText.FontFace = Font
    gameNameText.TextXAlignment = Enum.TextXAlignment.Left
    gameNameText.TextTruncate = Enum.TextTruncate.AtEnd
    gameNameText.Parent = gameCard
    
    local gameStatusText = Instance.new("TextLabel")
    gameStatusText.Name = "GameStatus"
    gameStatusText.Size = UDim2.new(0, 130, 0, 13)
    gameStatusText.Position = UDim2.new(0, 48, 0, 26)
    gameStatusText.BackgroundTransparency = 1
    gameStatusText.Text = "Checking..."
    gameStatusText.TextColor3 = SecondaryFontColor
    gameStatusText.TextSize = 11
    gameStatusText.FontFace = Font
    gameStatusText.TextXAlignment = Enum.TextXAlignment.Left
    gameStatusText.Parent = gameCard
    
    task.spawn(function()
        local pName = "Roblox Experience"
        pcall(function()
            local info = MarketplaceService:GetProductInfo(game.PlaceId)
            if info and info.Name then
                pName = info.Name
            end
        end)
        gameNameText.Text = pName
        
        local isSupported = false
        for _, idInfo in pairs(supportedGame) do
            if tostring(idInfo[1]) == tostring(game.PlaceId) or tostring(idInfo[1]) == tostring(game.GameId) then
                isSupported = idInfo[2]
                break
            end
        end
        
        if isSupported then
            gameStatusText.Text = "Supported"
            gameStatusText.TextColor3 = Color3.fromRGB(130, 220, 140)
        else
            gameStatusText.Text = "Not in our list"
            gameStatusText.TextColor3 = Color3.fromRGB(220, 100, 100)
        end
    end)
    
    -- Executor Info
    local execHeader = Instance.new("TextLabel")
    execHeader.Name = "ExecHeader"
    execHeader.Size = UDim2.new(0, 187, 0, 12)
    execHeader.Position = UDim2.new(0, 28, 0, 108)
    execHeader.BackgroundTransparency = 1
    execHeader.Text = "Executor"
    execHeader.TextColor3 = SecondaryFontColor
    execHeader.TextSize = 12
    execHeader.FontFace = Font
    execHeader.TextXAlignment = Enum.TextXAlignment.Left
    execHeader.Parent = rightPanel
    
    local detectedExec = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "Unknown"
    local execValue = Instance.new("TextLabel")
    execValue.Name = "ExecValue"
    execValue.Size = UDim2.new(0, 187, 0, 14)
    execValue.Position = UDim2.new(0, 28, 0, 124)
    execValue.BackgroundTransparency = 1
    execValue.Text = detectedExec
    execValue.TextColor3 = FontColor
    execValue.TextSize = 12
    execValue.FontFace = Font
    execValue.TextXAlignment = Enum.TextXAlignment.Left
    execValue.Parent = rightPanel
    
    -- Status Info
    local statusHeader = Instance.new("TextLabel")
    statusHeader.Name = "StatusHeader"
    statusHeader.Size = UDim2.new(0, 187, 0, 12)
    statusHeader.Position = UDim2.new(0, 28, 0, 148)
    statusHeader.BackgroundTransparency = 1
    statusHeader.Text = "Status"
    statusHeader.TextColor3 = SecondaryFontColor
    statusHeader.TextSize = 12
    statusHeader.FontFace = Font
    statusHeader.TextXAlignment = Enum.TextXAlignment.Left
    statusHeader.Parent = rightPanel
    
    local statusValue = Instance.new("TextLabel")
    statusValue.Name = "StatusValue"
    statusValue.Size = UDim2.new(0, 187, 0, 14)
    statusValue.Position = UDim2.new(0, 28, 0, 164)
    statusValue.BackgroundTransparency = 1
    statusValue.Text = "Key required"
    statusValue.TextColor3 = FontColor
    statusValue.TextSize = 12
    statusValue.FontFace = Font
    statusValue.TextXAlignment = Enum.TextXAlignment.Left
    statusValue.Parent = rightPanel
    
    local rightDivider = Instance.new("Frame")
    rightDivider.Name = "RightDivider"
    rightDivider.Size = UDim2.new(0, 187, 0, 1)
    rightDivider.Position = UDim2.new(0, 28, 0, 192)
    rightDivider.BackgroundColor3 = OutlineColor
    rightDivider.BorderSizePixel = 0
    rightDivider.Parent = rightPanel
    
    -- Social Links (Discord & Website)
    local function createSocialButton(yPos, name, linkText, defaultIconId)
        local btn = Instance.new("TextButton")
        btn.Name = name .. "Button"
        btn.Size = UDim2.new(0, 187, 0, 48)
        btn.Position = UDim2.new(0, 28, 0, yPos)
        btn.BackgroundColor3 = MainColor
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Text = ""
        btn.ClipsDescendants = true
        btn.Parent = rightPanel
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = OutlineColor
        btnStroke.Thickness = 1
        btnStroke.Parent = btn
        
        -- Icon
        local iconFrame = Instance.new("Frame")
        iconFrame.Size = UDim2.new(0, 24, 0, 24)
        iconFrame.Position = UDim2.new(0, 10, 0, 12)
        iconFrame.BackgroundTransparency = 1
        iconFrame.Parent = btn
        
        local iconImg = Instance.new("ImageLabel")
        iconImg.Name = "IconImg"
        iconImg.Size = UDim2.new(0, 18, 0, 18)
        iconImg.Position = UDim2.new(0.5, 0, 0.5, 0)
        iconImg.AnchorPoint = Vector2.new(0.5, 0.5)
        iconImg.BackgroundTransparency = 1
        iconImg.Image = defaultIconId
        iconImg.ImageColor3 = SecondaryFontColor
        iconImg.ScaleType = Enum.ScaleType.Fit
        iconImg.Parent = iconFrame
        
        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(0, 130, 0, 14)
        titleLbl.Position = UDim2.new(0, 42, 0, 10)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = name
        titleLbl.TextColor3 = FontColor
        titleLbl.TextSize = 12
        titleLbl.FontFace = Font
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.Parent = btn
        
        local linkLbl = Instance.new("TextLabel")
        linkLbl.Size = UDim2.new(0, 136, 0, 13)
        linkLbl.Position = UDim2.new(0, 42, 0, 26)
        linkLbl.BackgroundTransparency = 1
        linkLbl.Text = linkText or ""
        linkLbl.TextColor3 = SecondaryFontColor
        linkLbl.TextSize = 11
        linkLbl.FontFace = Font
        linkLbl.TextXAlignment = Enum.TextXAlignment.Left
        linkLbl.TextTruncate = Enum.TextTruncate.AtEnd
        linkLbl.Parent = btn
        
        -- Hover
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(MainColor.R*255 + 5, MainColor.G*255 + 5, MainColor.B*255 + 5)}):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.15), {Color = AccentColor}):Play()
            TweenService:Create(iconImg, TweenInfo.new(0.15), {ImageColor3 = AccentColor}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = MainColor}):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.15), {Color = OutlineColor}):Play()
            TweenService:Create(iconImg, TweenInfo.new(0.15), {ImageColor3 = SecondaryFontColor}):Play()
        end)
        
        -- Copy Click Animation
        local isCopying = false
        btn.MouseButton1Click:Connect(function()
            if linkText and linkText ~= "" and not isCopying then
                isCopying = true
                pcall(function()
                    if setclipboard then
                        setclipboard(linkText)
                    elseif toclipboard then
                        toclipboard(linkText)
                    end
                end)
                
                -- Button pop punch removed
                
                -- Text Slide Out Up
                local origText = linkLbl.Text
                local origPos = linkLbl.Position
                local slideOut = TweenService:Create(linkLbl, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Position = UDim2.new(0, 42, 0, 17),
                    TextTransparency = 1
                })
                slideOut:Play()
                slideOut.Completed:Connect(function()
                    linkLbl.Text = "Copied!"
                    linkLbl.TextColor3 = AccentColor
                    linkLbl.Position = UDim2.new(0, 42, 0, 31)
                    
                    -- Slide In from Bottom
                    TweenService:Create(linkLbl, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Position = origPos,
                        TextTransparency = 0
                    }):Play()
                    
                    task.delay(1.5, function()
                        local slideOutBack = TweenService:Create(linkLbl, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            Position = UDim2.new(0, 42, 0, 17),
                            TextTransparency = 1
                        })
                        slideOutBack:Play()
                        slideOutBack.Completed:Connect(function()
                            linkLbl.Text = origText
                            linkLbl.TextColor3 = SecondaryFontColor
                            linkLbl.Position = UDim2.new(0, 42, 0, 31)
                            TweenService:Create(linkLbl, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                                Position = origPos,
                                TextTransparency = 0
                            }):Play()
                            isCopying = false
                        end)
                    end)
                end)
            end
        end)
        
        return btn
    end
    
    createSocialButton(204, "Discord", socialLinks.Discord, "rbxassetid://10709782758") -- Lucide Message-Square fallback
    createSocialButton(260, "Website", socialLinks.WebSite, "rbxassetid://10709782154") -- Lucide Globe fallback
    
    -- Key Input
    local inputLabel = Instance.new("TextLabel")
    inputLabel.Name = "InputLabel"
    inputLabel.Size = UDim2.new(0, 300, 0, 14)
    inputLabel.Position = UDim2.new(0, 28, 0, 120)
    inputLabel.BackgroundTransparency = 1
    inputLabel.Text = "License key"
    inputLabel.TextColor3 = SecondaryFontColor
    inputLabel.TextSize = 12
    inputLabel.FontFace = Font
    inputLabel.TextXAlignment = Enum.TextXAlignment.Left
    inputLabel.Parent = leftPanel
    
    local inputFrame = Instance.new("Frame")
    inputFrame.Name = "InputFrame"
    inputFrame.Size = UDim2.new(0, 300, 0, 38)
    inputFrame.Position = UDim2.new(0, 28, 0, 140)
    inputFrame.BackgroundColor3 = MainColor
    inputFrame.BorderSizePixel = 0
    inputFrame.Parent = leftPanel
    
    local inputScale = Instance.new("UIScale")
    inputScale.Parent = inputFrame
    
    local inCorner = Instance.new("UICorner")
    inCorner.CornerRadius = UDim.new(0, 6)
    inCorner.Parent = inputFrame
    
    local inStroke = Instance.new("UIStroke")
    inStroke.Color = OutlineColor
    inStroke.Thickness = 1
    inStroke.Parent = inputFrame
    
    local textBox = Instance.new("TextBox")
    textBox.Name = "TextBox"
    textBox.Size = UDim2.new(1, -20, 1, 0)
    textBox.Position = UDim2.new(0, 10, 0, 0)
    textBox.BackgroundTransparency = 1
    textBox.Text = ""
    textBox.PlaceholderText = "Paste your key here"
    textBox.PlaceholderColor3 = SecondaryFontColor
    textBox.TextColor3 = FontColor
    textBox.TextSize = 13
    textBox.FontFace = Font
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.ClearTextOnFocus = false
    textBox.Parent = inputFrame
    
    -- Pop Bounce Animation removed
    
    textBox.Focused:Connect(function()
        TweenService:Create(inStroke, TweenInfo.new(0.2), {Color = AccentColor}):Play()
    end)
    textBox.FocusLost:Connect(function()
        TweenService:Create(inStroke, TweenInfo.new(0.2), {Color = OutlineColor}):Play()
    end)
    
    -- Buttons
    local function CreateButton(text, pos, size, isAccent)
        local btn = Instance.new("TextButton")
        btn.Size = size
        btn.Position = pos
        btn.BackgroundColor3 = isAccent and AccentColor or MainColor
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Text = ""
        btn.Parent = leftPanel
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = btn
        
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1
        stroke.Color = isAccent and AccentColor or OutlineColor
        stroke.Parent = btn
        
        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(1, 0, 1, 0)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = text
        titleLbl.TextColor3 = isAccent and Color3.fromRGB(20, 16, 20) or FontColor
        titleLbl.TextSize = 13
        titleLbl.FontFace = Font
        titleLbl.Parent = btn
        
        btn.MouseEnter:Connect(function()
            if not isAccent then
                TweenService:Create(stroke, TweenInfo.new(0.2), {Color = AccentColor}):Play()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(MainColor.R*255 + 5, MainColor.G*255 + 5, MainColor.B*255 + 5)}):Play()
            else
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(AccentColor.R*255 + 20, AccentColor.G*255 + 20, AccentColor.B*255 + 20)}):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if not isAccent then
                TweenService:Create(stroke, TweenInfo.new(0.2), {Color = OutlineColor}):Play()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = MainColor}):Play()
            else
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = AccentColor}):Play()
            end
        end)
        
        return btn
    end
    
    local submitButton = CreateButton("Submit", UDim2.new(0, 28, 0, 196), UDim2.new(0, 144, 0, 38), true)
    local getKeyButton = CreateButton("Get a key", UDim2.new(0, 184, 0, 196), UDim2.new(0, 144, 0, 38), false)
    
    local feedbackLabel = Instance.new("TextLabel")
    feedbackLabel.Name = "FeedbackLabel"
    feedbackLabel.Size = UDim2.new(0, 300, 0, 16)
    feedbackLabel.Position = UDim2.new(0, 28, 0, 250)
    feedbackLabel.BackgroundTransparency = 1
    feedbackLabel.Text = ""
    feedbackLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    feedbackLabel.TextSize = 12
    feedbackLabel.FontFace = Font
    feedbackLabel.TextXAlignment = Enum.TextXAlignment.Center
    feedbackLabel.TextTransparency = 1
    feedbackLabel.Parent = leftPanel
    
    local feedbackThread
    local function ShowFeedback(text, color, duration)
        if feedbackThread then
            task.cancel(feedbackThread)
            feedbackThread = nil
        end
        feedbackLabel.Text = text
        feedbackLabel.TextColor3 = color
        
        -- Slide up slightly and fade in
        feedbackLabel.Position = UDim2.new(0, 28, 0, 255)
        TweenService:Create(feedbackLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0,
            Position = UDim2.new(0, 28, 0, 250)
        }):Play()
        
        if duration then
            feedbackThread = task.delay(duration, function()
                local fade = TweenService:Create(feedbackLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    TextTransparency = 1,
                    Position = UDim2.new(0, 28, 0, 245)
                })
                fade:Play()
                fade.Completed:Connect(function()
                    if feedbackLabel.TextTransparency == 1 then
                        feedbackLabel.Text = ""
                    end
                end)
            end)
        end
    end
    
    -- Content container inside leftPanel for slide transitions
    local leftContainer = Instance.new("Frame")
    leftContainer.Name = "LeftContainer"
    leftContainer.Size = UDim2.new(1, 0, 1, 0)
    leftContainer.BackgroundTransparency = 1
    leftContainer.ClipsDescendants = true
    leftContainer.ZIndex = 2
    leftContainer.Parent = leftPanel

    -- Key Input View (Page 1)
    local keyPageView = Instance.new("Frame")
    keyPageView.Name = "KeyPageView"
    keyPageView.Size = UDim2.new(1, 0, 1, 0)
    keyPageView.Position = UDim2.new(0, 0, 0, 0)
    keyPageView.BackgroundTransparency = 1
    keyPageView.Parent = leftContainer

    -- Move key input elements to keyPageView
    inputLabel.Parent = keyPageView
    inputFrame.Parent = keyPageView
    submitButton.Parent = keyPageView
    getKeyButton.Parent = keyPageView
    feedbackLabel.Parent = keyPageView

    -- Ads View (Page 2 - Full Left Panel Slide)
    local adsPageView = Instance.new("Frame")
    adsPageView.Name = "AdsPageView"
    adsPageView.Size = UDim2.new(1, 0, 1, 0)
    adsPageView.Position = UDim2.new(1, 20, 0, 0) -- starts off-screen to the right
    adsPageView.BackgroundTransparency = 1
    adsPageView.Visible = false
    adsPageView.Parent = leftContainer

    -- Back Button Header
    local adsBackBtn = Instance.new("TextButton")
    adsBackBtn.Name = "BackBtn"
    adsBackBtn.Size = UDim2.new(0, 26, 0, 26)
    adsBackBtn.Position = UDim2.new(0, 28, 0, 116)
    adsBackBtn.BackgroundColor3 = MainColor
    adsBackBtn.BorderSizePixel = 0
    adsBackBtn.AutoButtonColor = false
    adsBackBtn.Text = "←"
    adsBackBtn.TextColor3 = SecondaryFontColor
    adsBackBtn.TextSize = 14
    adsBackBtn.FontFace = Font
    adsBackBtn.Parent = adsPageView

    local adsBackCorner = Instance.new("UICorner")
    adsBackCorner.CornerRadius = UDim.new(0, 6)
    adsBackCorner.Parent = adsBackBtn

    local adsBackStroke = Instance.new("UIStroke")
    adsBackStroke.Color = OutlineColor
    adsBackStroke.Thickness = 1
    adsBackStroke.Parent = adsBackBtn

    adsBackBtn.MouseEnter:Connect(function()
        TweenService:Create(adsBackBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(MainColor.R*255 + 10, MainColor.G*255 + 10, MainColor.B*255 + 10)}):Play()
        TweenService:Create(adsBackStroke, TweenInfo.new(0.15), {Color = AccentColor}):Play()
        TweenService:Create(adsBackBtn, TweenInfo.new(0.15), {TextColor3 = FontColor}):Play()
    end)
    adsBackBtn.MouseLeave:Connect(function()
        TweenService:Create(adsBackBtn, TweenInfo.new(0.15), {BackgroundColor3 = MainColor}):Play()
        TweenService:Create(adsBackStroke, TweenInfo.new(0.15), {Color = OutlineColor}):Play()
        TweenService:Create(adsBackBtn, TweenInfo.new(0.15), {TextColor3 = SecondaryFontColor}):Play()
    end)

    local adsHeaderTitle = Instance.new("TextLabel")
    adsHeaderTitle.Name = "AdsHeaderTitle"
    adsHeaderTitle.Size = UDim2.new(0, 200, 0, 16)
    adsHeaderTitle.Position = UDim2.new(0, 62, 0, 114)
    adsHeaderTitle.BackgroundTransparency = 1
    adsHeaderTitle.Text = "Select Checkpoint"
    adsHeaderTitle.TextColor3 = FontColor
    adsHeaderTitle.TextSize = 13
    adsHeaderTitle.FontFace = Font
    adsHeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
    adsHeaderTitle.Parent = adsPageView

    local adsHeaderSub = Instance.new("TextLabel")
    adsHeaderSub.Name = "AdsHeaderSub"
    adsHeaderSub.Size = UDim2.new(0, 200, 0, 13)
    adsHeaderSub.Position = UDim2.new(0, 62, 0, 131)
    adsHeaderSub.BackgroundTransparency = 1
    adsHeaderSub.Text = "Choose a provider to get key"
    adsHeaderSub.TextColor3 = SecondaryFontColor
    adsHeaderSub.TextSize = 10
    adsHeaderSub.FontFace = Font
    adsHeaderSub.TextXAlignment = Enum.TextXAlignment.Left
    adsHeaderSub.Parent = adsPageView

    -- Ads List (Big vertical cards)
    local adsScroll = Instance.new("ScrollingFrame")
    adsScroll.Name = "AdsScroll"
    adsScroll.Size = UDim2.new(0, 300, 0, 185)
    adsScroll.Position = UDim2.new(0, 28, 0, 150)
    adsScroll.BackgroundTransparency = 1
    adsScroll.BorderSizePixel = 0
    adsScroll.ScrollBarThickness = 3
    adsScroll.ScrollBarImageColor3 = AccentColor
    adsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    adsScroll.Parent = adsPageView

    local adsLayout = Instance.new("UIListLayout")
    adsLayout.Padding = UDim.new(0, 10)
    adsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    adsLayout.Parent = adsScroll

    adsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        adsScroll.CanvasSize = UDim2.new(0, 0, 0, adsLayout.AbsoluteContentSize.Y + 6)
    end)

    local isAnimatingTransition = false
    local isAdsViewOpen = false

    local function switchToAdsView()
        if isAnimatingTransition or isAdsViewOpen then return end
        isAnimatingTransition = true
        isAdsViewOpen = true

        adsPageView.Visible = true
        adsPageView.Position = UDim2.new(1, 20, 0, 0)

        -- Slide key page out to the left
        TweenService:Create(keyPageView, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
            Position = UDim2.new(-1, -20, 0, 0)
        }):Play()

        -- Slide ads page in from right
        local slideIn = TweenService:Create(adsPageView, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 0, 0)
        })
        slideIn:Play()
        slideIn.Completed:Connect(function()
            keyPageView.Visible = false
            isAnimatingTransition = false
        end)
    end

    local function switchToKeyView(onComplete)
        if isAnimatingTransition or not isAdsViewOpen then return end
        isAnimatingTransition = true
        isAdsViewOpen = false

        keyPageView.Visible = true
        keyPageView.Position = UDim2.new(-1, -20, 0, 0)

        -- Slide ads page out to right
        TweenService:Create(adsPageView, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, 20, 0, 0)
        }):Play()

        -- Slide key page in from left
        local slideIn = TweenService:Create(keyPageView, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 0, 0)
        })
        slideIn:Play()
        slideIn.Completed:Connect(function()
            adsPageView.Visible = false
            isAnimatingTransition = false
            if onComplete then onComplete() end
        end)
    end

    adsBackBtn.MouseButton1Click:Connect(function()
        switchToKeyView()
    end)

    -- Populate large Ad Cards
    local function populateAdsCards()
        for _, child in ipairs(adsScroll:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        if type(adsConfig) ~= "table" then return end

        for adKey, adData in pairs(adsConfig) do
            local cardIcon = 0
            local cardName = tostring(adKey)

            if type(adData) == "table" then
                cardIcon = adData[1] or adData.Icon or 0
                cardName = adData[2] or adData.Name or tostring(adKey)
            elseif type(adData) == "string" then
                cardName = adData
            elseif type(adData) == "number" then
                cardIcon = adData
            end

            local cardBtn = Instance.new("TextButton")
            cardBtn.Name = "AdCard_" .. tostring(adKey)
            cardBtn.Size = UDim2.new(1, -6, 0, 60)
            cardBtn.BackgroundColor3 = MainColor
            cardBtn.BorderSizePixel = 0
            cardBtn.AutoButtonColor = false
            cardBtn.Text = ""
            cardBtn.ClipsDescendants = true
            cardBtn.Parent = adsScroll

            local cardCorner = Instance.new("UICorner")
            cardCorner.CornerRadius = UDim.new(0, 8)
            cardCorner.Parent = cardBtn

            local cardStroke = Instance.new("UIStroke")
            cardStroke.Color = OutlineColor
            cardStroke.Thickness = 1
            cardStroke.Parent = cardBtn

            -- Icon without background box
            local iconImg = Instance.new("ImageLabel")
            iconImg.Name = "AdIcon"
            iconImg.Size = UDim2.new(0, 38, 0, 38)
            iconImg.Position = UDim2.new(0, 14, 0.5, 0)
            iconImg.AnchorPoint = Vector2.new(0, 0.5)
            iconImg.BackgroundTransparency = 1
            iconImg.BorderSizePixel = 0
            iconImg.ScaleType = Enum.ScaleType.Fit

            local iconStr = tostring(cardIcon)
            if iconStr:find("rbxasset") or iconStr:find("http") then
                iconImg.Image = iconStr
            elseif tonumber(cardIcon) and tonumber(cardIcon) > 0 then
                iconImg.Image = "rbxassetid://" .. tostring(cardIcon)
            elseif (isfile and isfile(iconStr)) or (readfile and pcall(readfile, iconStr)) then
                local getAsset = getcustomasset or getsynasset or GetCustomAsset
                if getAsset then
                    iconImg.Image = getAsset(iconStr)
                else
                    iconImg.Image = iconStr
                end
            else
                iconImg.Image = "rbxassetid://10709782154"
            end
            iconImg.Parent = cardBtn

            -- Title and Subtitle
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Name = "AdName"
            nameLabel.Size = UDim2.new(1, -100, 0, 18)
            nameLabel.Position = UDim2.new(0, 62, 0, 12)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = cardName
            nameLabel.TextColor3 = FontColor
            nameLabel.TextSize = 13
            nameLabel.FontFace = Font
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
            nameLabel.Parent = cardBtn

            local subLabel = Instance.new("TextLabel")
            subLabel.Name = "AdSub"
            subLabel.Size = UDim2.new(1, -100, 0, 14)
            subLabel.Position = UDim2.new(0, 62, 0, 32)
            subLabel.BackgroundTransparency = 1
            subLabel.Text = "Click to get key link"
            subLabel.TextColor3 = SecondaryFontColor
            subLabel.TextSize = 11
            subLabel.FontFace = Font
            subLabel.TextXAlignment = Enum.TextXAlignment.Left
            subLabel.Parent = cardBtn

            -- Right arrow indicator
            local arrowLabel = Instance.new("TextLabel")
            arrowLabel.Name = "Arrow"
            arrowLabel.Size = UDim2.new(0, 20, 0, 20)
            arrowLabel.Position = UDim2.new(1, -28, 0.5, 0)
            arrowLabel.AnchorPoint = Vector2.new(0, 0.5)
            arrowLabel.BackgroundTransparency = 1
            arrowLabel.Text = "→"
            arrowLabel.TextColor3 = SecondaryFontColor
            arrowLabel.TextSize = 14
            arrowLabel.FontFace = Font
            arrowLabel.Parent = cardBtn

            -- Hover Effect
            cardBtn.MouseEnter:Connect(function()
                TweenService:Create(cardBtn, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(MainColor.R*255 + 8, MainColor.G*255 + 8, MainColor.B*255 + 8)
                }):Play()
                TweenService:Create(cardStroke, TweenInfo.new(0.15), {Color = AccentColor}):Play()
                TweenService:Create(arrowLabel, TweenInfo.new(0.15), {TextColor3 = AccentColor}):Play()
            end)
            cardBtn.MouseLeave:Connect(function()
                TweenService:Create(cardBtn, TweenInfo.new(0.15), {BackgroundColor3 = MainColor}):Play()
                TweenService:Create(cardStroke, TweenInfo.new(0.15), {Color = OutlineColor}):Play()
                TweenService:Create(arrowLabel, TweenInfo.new(0.15), {TextColor3 = SecondaryFontColor}):Play()
            end)

            -- Click: highlight & slide smoothly back to key view
            local isProcessing = false
            cardBtn.MouseButton1Click:Connect(function()
                if isProcessing then return end
                isProcessing = true

                TweenService:Create(cardBtn, TweenInfo.new(0.1), {
                    BackgroundColor3 = AccentColor
                }):Play()
                nameLabel.TextColor3 = Color3.fromRGB(20, 16, 20)
                subLabel.TextColor3 = Color3.fromRGB(40, 32, 40)
                arrowLabel.TextColor3 = Color3.fromRGB(20, 16, 20)

                task.wait(0.1)
                switchToKeyView(function()
                    -- Reset card visual state
                    cardBtn.BackgroundColor3 = MainColor
                    cardStroke.Color = OutlineColor
                    nameLabel.TextColor3 = FontColor
                    subLabel.TextColor3 = SecondaryFontColor
                    arrowLabel.TextColor3 = SecondaryFontColor
                    isProcessing = false

                    pcall(getKeyFunc, adKey)
                    ShowFeedback("Link copied for " .. cardName .. "!", AccentColor, 3)
                end)
            end)
        end
    end

    if adsConfig and next(adsConfig) then
        populateAdsCards()
    end

    getKeyButton.MouseButton1Click:Connect(function()
        if adsConfig and next(adsConfig) then
            switchToAdsView()
        else
            pcall(getKeyFunc)
            ShowFeedback("Get Key link copied!", AccentColor, 3)
        end
    end)
    
    submitButton.MouseButton1Click:Connect(function()
        local key = textBox.Text
        ShowFeedback("Checking key...", AccentColor)
        
        task.spawn(function()
            local success, result = pcall(checkKeyFunc, key)
            if success and result then
                ShowFeedback("Key verified!", Color3.fromRGB(120, 230, 130))
                task.wait(0.5)
                
                -- Smooth Close Animation
                local closeTween = TweenService:Create(uiScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0.8})
                local fadeTween = TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
                closeTween:Play()
                fadeTween:Play()
                closeTween.Completed:Connect(function()
                    root:Destroy()
                end)
            else
                ShowFeedback("Invalid key. Please try again.", Color3.fromRGB(255, 90, 90), 3)
                
                -- Shake Input
                local shakeOffsets = { -6, 6, -4, 4, -2, 2, 0 }
                for _, off in ipairs(shakeOffsets) do
                    TweenService:Create(inputFrame, TweenInfo.new(0.04, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Position = UDim2.new(0, 28 + off, 0, 140)
                    }):Play()
                    task.wait(0.04)
                end
                inputFrame.Position = UDim2.new(0, 28, 0, 140)
            end
        end)
    end)
    
    -- Dragging Logic
    local dragging = false
    local dragInput, dragStart, startPos
    
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(mainFrame, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            }):Play()
        end
    end)
    
    root.Parent = GetGuiParent()
    
    -- Entrance Animation
    TweenService:Create(uiScale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()
    
    return root
end

return Library
