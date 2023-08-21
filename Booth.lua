repeat task.wait() until game:IsLoaded()
print("Script Started")
getgenv().LoadedAll = true
task.wait(40)
local a, b = pcall(function ()
    repeat
        task.wait()
    until require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library")).Loaded
end)

local httpService = game:GetService("HttpService")
local count = #game.Players:GetPlayers()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local groupId = 5060810
local apiUrl = "https://tracking-applicable-cork-wet.trycloudflare.com/servers"
local Root = game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local Player = game:GetService("Players").LocalPlayer
local Scripts = Player.PlayerScripts.Scripts
local playerPos = CFrame.new(-319.761322, 46.7770004, -2597.34473, 0.761269152, -1.61073377e-08, 0.64843601,
    3.39745867e-08, 1, -1.50461545e-08, -0.64843601, 3.34845183e-08, 0.761269152)

shared.Settings = {
    FilePath = "Selling.json",
    SellLink = getgenv().SellHook,
    SnipeLink = getgenv().SnipeHook
}
local function makeGetRequest(url)
    local response
    repeat
        local success, error = pcall(function() 
            response = game:HttpGetAsync(url)
            response = httpService:JSONDecode(response)["jobID"]
        end)
    until response ~= "" and success
    return response
end

if not a then
    local getResponse = makeGetRequest(apiUrl)
    game:GetService("TeleportService"):TeleportToPlaceInstance(7722306047, getResponse,
        game.Players.LocalPlayer)
end

local Library = require(game.ReplicatedStorage:WaitForChild('Framework'):WaitForChild('Library'))

while not Library.Loaded do
    task.wait()
end

local UserIDToUsername = Library.Functions.UserIdToUsername
local Network = require(game:GetService("ReplicatedStorage").Library.Client.Network)

local Fire, Invoke = Network.Fire, Network.Invoke

local old
old = hookfunction(getupvalue(Fire, 1), function(...)
    return true
end)


local function VirtualPressButton(Button)
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Button, false, nil)
    task.wait()
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Button, false, nil)
end

local function AdvancedSignal(Content, ColorToInput)
    return Library.Signal.Fire("Notification", Content, {
        color = ColorToInput
    })
end

local function makePostRequest(url, requestBody)
    local headers = {
        ["content-type"] = "application/json"
    }

    local request = request
    local sendRequest = {
        Url = url,
        Body = requestBody,
        Method = "POST",
        Headers = headers
    }
    local responseBody = request(sendRequest)
    return httpService:JSONEncode(responseBody)
end

local function Webhook(Url, Data)
    task.spawn(function()
        request {
            Url = Url,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = game:GetService("HttpService"):JSONEncode(Data)
        }
    end)
end

local function sendMail()
    url = getgenv().MailHook
    args = {
        [1] = {
            ["Recipient"] = getgenv().MailUsername,
            ["Diamonds"] = mailDiamonds,
            ["Pets"] = {},
            ["Message"] = ""
        }
    }

    local mailed = false
    pcall(function()
        while mailed == false do
            Root.CFrame = CFrame.new(-396, 33, -2549)
            task.wait(0.5)
            mailed = Invoke("Send Mail", unpack(args))
            task.wait(0.5)
            if mailed == true then
                Webhook(url, {
                    ["embeds"] = {{
                        ["title"] = game:GetService("Players").LocalPlayer.Name .. " has sent a mail!",
                        ["description"] = "Diamonds Mailed: " .. string.format('%.2f', mailDiamonds / 1000000000) .. 'b',
                        ["type"] = "rich",
                        ["color"] = tonumber(0x7269da)
                    }}
                })
            end
            task.wait(1)
        end
    end)
end

local function setRAM()
    task.spawn(function()
        local Threshold = 100000100000
        while true do
            local time = os.date("*t", os.time())
            allDiamonds = Library.Save.Get().Diamonds
            mailDiamonds = allDiamonds - Threshold

            num = Library.Save.Get().Pets
            -- if config == 'AM' then
            --     if #num > 40 then
            --         config = 'PM'
            --         local getResponse = makeGetRequest(apiUrl)
            --         game:GetService("TeleportService"):TeleportToPlaceInstance(7722306047, getResponse,
            --             game.Players.LocalPlayer)
            --     end
            -- else
            --     if #num < 6 then
            --         config = 'AM'
            --         local getResponse = makeGetRequest(apiUrl)
            --         game:GetService("TeleportService"):TeleportToPlaceInstance(7722306047, getResponse,
            --             game.Players.LocalPlayer)
            --     end
            -- end

            if time.hour == 11 and time.min <= 30 then
                if mailDiamonds > 101000000000 then
                    sendMail()
                end
            end

            task.wait(10)
        end
    end)
end

local VirtualUser = game:GetService('VirtualUser')
game:GetService('Players').LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

for i, v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
    v:Disable()
end

local OldSavedPets = {}
for i, v in pairs(Library.Save.Get().Pets) do
    table.insert(OldSavedPets, v)
end

if game.PlaceId ~= 7722306047 then
    local count = 0
    print("Game is Not Equal Line 189 count: ", count)
    task.wait(3)
    while game.PlaceId ~= 7722306047 do
        local getResponse = makeGetRequest(apiUrl)
        game:GetService("TeleportService"):TeleportToPlaceInstance(7722306047, getResponse, game.Players.LocalPlayer)
        task.wait(10)
    end

else
    task.spawn(function()
        if count > 10 then
            local postRequestBody = {
                username = game:GetService 'Players'.LocalPlayer.Name,
                jobid = game.JobId
            }
            task.spawn(function()
                local postResponse = makePostRequest(apiUrl, httpService:JSONEncode(postRequestBody))
                if postResponse:find("Hopping server.") then
                    local getResponse = makeGetRequest(apiUrl)
                    game:GetService("TeleportService"):TeleportToPlaceInstance(7722306047, getResponse,
                        game.Players.LocalPlayer)
                    -- game:GetService("TeleportService"):Teleport(6284583030)
                end
            end)

        else
            local getResponse = makeGetRequest(apiUrl)
            game:GetService("TeleportService")
                :TeleportToPlaceInstance(7722306047, getResponse, game.Players.LocalPlayer)
            -- game:GetService("TeleportService"):Teleport(6284583030)
        end

        for _, v in pairs(Players:GetPlayers()) do
            pcall(function()
                if v:IsInGroup(groupId) then
                    player:Kick(string.format("Staff [%s] is in the game.", v.Name))
                end
            end)

        end

        Players.PlayerAdded:Connect(function(Player)
            count = count + 1
            if Player:IsInGroup(groupId) then
                player:Kick(string.format("Staff [%s] has joined the game.", Player.Name))
            end
        end)

        Players.PlayerRemoving:Connect(function(Player)
            count = count - 1
            if count < 10 then
                local getResponse = makeGetRequest(apiUrl)
                game:GetService("TeleportService"):TeleportToPlaceInstance(7722306047, getResponse,
                    game.Players.LocalPlayer)
                -- game:GetService("TeleportService"):Teleport(6284583030)
            end
        end)
    end)

    task.spawn(function()
        RAMAccount = loadstring(
            game:HttpGet 'https://raw.githubusercontent.com/ic3w0lf22/Roblox-Account-Manager/master/RAMAccount.lua')()
        num = {}

        myAccount = RAMAccount.new(game:GetService 'Players'.LocalPlayer.Name)
        num = Library.Save.Get().Pets

        if isfile("Exclusives.json") then
            delfile("Exclusives.json")
        end

        if isfile("Snipe.json") then
            delfile("Snipe.json")
        end

        if isfile("Purge.json") then
            delfile("Purge.json")
        end

        if isfile("Selling.json") then
            delfile("Selling.json")
        end

        local exclusives = tostring(game:HttpGetAsync(
            "https://raw.githubusercontent.com/miyuyumi/AutoConfig/main/Mobile/Configurations/Exclusives.json"))
        writefile("Exclusives.json", exclusives)
        local snipe = tostring(game:HttpGetAsync(
            "https://raw.githubusercontent.com/miyuyumi/AutoConfig/main/Mobile/Configurations/Sniping.json"))
        writefile("Snipe.json", snipe)
        local purge = tostring(game:HttpGetAsync(
            "https://raw.githubusercontent.com/miyuyumi/AutoConfig/main/Mobile/Configurations/Purging.json"))
        writefile("Purge.json", purge)
        local contents = tostring(game:HttpGetAsync(
            "https://raw.githubusercontent.com/miyuyumi/AutoConfig/main/Mobile/Configurations/Selling.json"))
        writefile("Selling.json", contents)

        if #num <= 20 then
            config = 'AM'
            setRAM()
            getgenv().Config = 'Snipe.json'
        else
            config = 'PM'
            setRAM()
            getgenv().Config = 'Purge.json'
        end

        local function sendExclusives(uid)
            args = {
                [1] = {
                    ["Recipient"] = getgenv().MailUsername,
                    ["Diamonds"] = 0,
                    ["Pets"] = {uid},
                    ["Message"] = ""
                }
            }

            local sentPet = false
            task.spawn(function()
                pcall(function()
                    while sentPet == false do
                        Root.CFrame = CFrame.new(-396, 33, -2549)
                        task.wait(0.5)
                        sentPet = Invoke("Send Mail", unpack(args))
                        task.wait(0.5)
                    end
                end)
            end)
        end

        local sendPets = httpService:JSONDecode(readfile("Exclusives.json"))
        task.spawn(function()
            while true do
                local checkPets = Library.Save.Get().Pets
                for i, v in pairs(checkPets) do
                    if not v.l then
                        for _, v2 in pairs(sendPets) do
                            if v2[1] ~= v.id then
                                continue
                            end

                            if v2[2][1] == "Any" then
                                sendExclusives(v.uid)
                                break
                            end

                            local rarity = (v.g and "Golden") or (v.r and "Rainbow") or (v.dm and "Dark Matter") or
                            "Regular"
                            if v2[2][1] ~= rarity then
                                continue
                            end


                            if v.sh and v2[2][2] ~= nil then
                                sendExclusives(v.uid)
                                break
                            elseif not v.sh and v2[2][2] == nil then
                                sendExclusives(v.uid)
                                break
                            end
                        end
                    end
                end
                task.wait(1)
            end
        end)

        task.spawn(function()
            local sellingList = httpService:JSONDecode(readfile(shared.Settings.FilePath))
            local snipeList = httpService:JSONDecode(readfile(getgenv().Config))
            local inventoryList = {}
            local addedList = {}
            local success, response
            repeat
                success, response = pcall(function()
                    for i, v in pairs(game:GetService("Workspace")["__MAP"]:WaitForChild("Interactive"):WaitForChild(
                        "Booths"):GetChildren()) do
                        local Snipe = Instance.new("Part")
                        Snipe.Parent = game.Workspace
                        Snipe.Size = Vector3.new(5, 1, 5)
                        Snipe.Anchored = true
                        Snipe.CFrame = v.Booth.CFrame * CFrame.new(0, -16, 0)
                    end
                end)
            until success

            local function addPet()
                inventoryList = {}
                for _, v in pairs(Library.Save.Get().Pets) do
                    if not v.l then
                        for _, v2 in pairs(sellingList) do
                            if v2[1] ~= v.id then
                                continue
                            end
                            local rarity = (v.g and "Golden") or (v.r and "Rainbow") or (v.dm and "Dark Matter") or
                                               "Regular"
                            if v2[3][1] ~= rarity then
                                continue
                            end

                            if v.sh and v2[3][2] ~= nil then
                                if RAPAve ~= nil then
                                    if RAPAve > v2[2] then
                                        table.insert(inventoryList, {v.uid, RAPAve})
                                        break
                                    else
                                        table.insert(inventoryList, {v.uid, v2[2]})
                                        break
                                    end
                                else
                                    table.insert(inventoryList, {v.uid, v2[2]})
                                    break
                                end
                            elseif not v.sh and v2[3][2] == nil then
                                if RAPAve ~= nil then
                                    if RAPAve > v2[2] then
                                        table.insert(inventoryList, {v.uid, RAPAve})
                                        break
                                    else
                                        table.insert(inventoryList, {v.uid, v2[2]})
                                        break
                                    end
                                else
                                    table.insert(inventoryList, {v.uid, v2[2]})
                                    break
                                end
                            end
                            
                            break
                        end
                    end
                end

                table.sort(inventoryList, function(a, b)
                    return a[2] > b[2]
                end)

                for _, v in pairs(inventoryList) do
                    if not table.find(addedList, v[1]) then
                        Invoke("Add Trading Booth Pet", {v})
                    end
                end
            end

            local function sendSellWebhook(buyer, price, pet)
                local Pet = Library.PetCmds.Get(pet.uid)
                local PetName = Library.Directory.Pets[Pet.id].name
                local PetType = (Pet.r and "Rainbow ") or (Pet.g and "Golden ") or (Pet.dm and "Dark Matter ") or ""
                local PetImage =
                    Library.Directory.Pets[Pet.id][(Pet.r and "thumbnail") or (Pet.g and "goldenThumbnail") or
                        (Pet.dm and "darkMatterThumbnail") or "thumbnail"]:split("//")[2]
                local diamonds = Library.Functions.NumberShorten(Library.Save.Get().Diamonds)
                if (Library.Directory.Pets[Pet.id].huge or Library.Directory.Pets[Pet.id].titanic) and tonumber(Library.Functions.ParseNumberSmart(price)) > 50000000000 then
                    Webhook(shared.Settings.SellLink, {
                        ["embeds"] = {{
                            ["title"] = "Sold A " .. ((Pet.sh and "Shiny ") or "") .. PetType .. PetName,
                            ["thumbnail"] = {
                                ["url"] = httpService:JSONDecode(game:HttpGet(
                                    ("https://thumbnails.roblox.com/v1/assets?assetIds=" .. PetImage ..
                                        "&size=250x250&format=Png&isCircular=false"))).data[1].imageUrl
                            },
                            ["description"] = "**Sold For:** " .. price .. " :diamonds:\n**To:** ||" .. buyer ..
                                "||\n**Current Diamonds:** " .. diamonds .. ":diamonds:\n**Account:** ||" .. Player.Name ..
                                "||",
                            ["type"] = "rich",
                            ["color"] = tonumber(0x00ff00)
                        }}
                    })
                end
            end

            Player.PlayerGui:FindFirstChild("Chat"):FindFirstChild("Frame"):FindFirstChild("ChatChannelParentFrame")
                :FindFirstChild("Frame_MessageLogDisplay"):FindFirstChild("Scroller").ChildAdded:Connect(function(Child)
                if Child:IsA("Frame") and Child.Name == "Frame" then
                    if not Child:FindFirstChild("TextLabel") then
                        return
                    end
                    if string.find(Child:FindFirstChild("TextLabel").Text, Player.DisplayName) then
                        local sellString = tostring(Child:FindFirstChild("TextLabel").Text)
                        local seller = sellString:match("from%s([^%s]+)%sfor")
                        local buyer = sellString:match("(%S+)%spurchased")
                        local price = sellString:match("for%s([^%s]+)%sDiamonds")
                        if seller == Player.DisplayName then
                            local PetsCheck = Library.Save.Get().Pets

                            for i, v in pairs(OldSavedPets) do
                                if not table.find(PetsCheck, v) then
                                    sendSellWebhook(buyer, price, v)
                                    OldSavedPets = {}
                                    for i, v in pairs(PetsCheck) do
                                        table.insert(OldSavedPets, v)
                                    end
                                    break
                                end
                            end
                            pcall(function()
                                addPet()
                            end)
                        end

                    end
                end
            end)

            local function CheckTypeOrRarity(Type, TypeTable, CheckTable)
                local Settings = TypeTable
                local Pet = CheckTable
                if Type == "Type" then
                    if (Settings["Regular"] and (not Pet.hc and not Pet.g and not Pet.r and not Pet.dm)) then
                        return true
                    end
                    if (Settings["Golden"] and (not Pet.hc and Pet.g)) then
                        return true
                    end
                    if (Settings["Rainbow"] and (not Pet.hc and Pet.r)) then
                        return true
                    end
                    if (Settings["Dark Matter"] and (not Pet.hc and Pet.dm)) then
                        return true
                    end
                    if ((Settings["Hardcore"] and Settings["Regular"]) and
                        (Pet.hc and not Pet.sh and not Pet.g and not Pet.r and not Pet.dm)) then
                        return true
                    end
                    if ((Settings["Hardcore"] and Settings["Golden"]) and (Pet.hc and not Pet.sh and Pet.g)) then
                        return true
                    end
                    if ((Settings["Hardcore"] and Settings["Rainbow"]) and (Pet.hc and not Pet.sh and Pet.r)) then
                        return true
                    end
                    if ((Settings["Hardcore"] and Settings["Dark Matter"]) and (Pet.hc and not Pet.sh and Pet.dm)) then
                        return true
                    end
                    if ((Settings["Shiny"] and Settings["Regular"]) and
                        (not Pet.hc and Pet.sh and not Pet.g and not Pet.r and not Pet.dm)) then
                        return true
                    end
                    if ((Settings["Shiny"] and Settings["Golden"]) and (not Pet.hc and Pet.sh and Pet.g)) then
                        return true
                    end
                    if ((Settings["Shiny"] and Settings["Rainbow"]) and (not Pet.hc and Pet.sh and Pet.r)) then
                        return true
                    end
                    if ((Settings["Shiny"] and Settings["Dark Matter"]) and (not Pet.hc and Pet.sh and Pet.dm)) then
                        return true
                    end
                    if ((Settings["Shiny"] and Settings["Hardcore"] and Settings["Regular"]) and
                        (Pet.hc and Pet.sh and not Pet.g and not Pet.r and not Pet.dm)) then
                        return true
                    end
                    if ((Settings["Shiny"] and Settings["Hardcore"] and Settings["Golden"]) and
                        (Pet.hc and Pet.sh and Pet.g)) then
                        return true
                    end
                    if ((Settings["Shiny"] and Settings["Hardcore"] and Settings["Rainbow"]) and
                        (Pet.hc and Pet.sh and Pet.r)) then
                        return true
                    end
                    if ((Settings["Shiny"] and Settings["Hardcore"] and Settings["Dark Matter"]) and
                        (Pet.hc and Pet.sh and Pet.dm)) then
                        return true
                    end
                    if ((Settings["Shiny"]) and (Pet.sh)) then
                        return true
                    end
                    if Settings["Any"] then
                        return true
                    end
                elseif Type == "Rarity" then
                    if (Settings.Rarities["Basic"] and Library.Directory.Pets[Pet.id].rarity == "Basic") or
                        (Settings.Rarities["Rare"] and Library.Directory.Pets[Pet.id].rarity == "Rare") or
                        (Settings.Rarities["Epic"] and Library.Directory.Pets[Pet.id].rarity == "Epic") or
                        (Settings.Rarities["Legendary"] and Library.Directory.Pets[Pet.id].rarity == "Legendary") or
                        (Settings.Rarities["Mythical"] and Library.Directory.Pets[Pet.id].rarity == "Mythical") or
                        (Settings.Rarities[""] and Library.Directory.Pets[Pet.id].rarity == "") or
                        (Settings.Rarities["Event"] and Library.Directory.Pets[Pet.id].rarity == "Event") or
                        (Settings.Rarities["Exclusive"] and Library.Directory.Pets[Pet.id].rarity == "Exclusive") or
                        (Settings.Rarities["Huge"] and Library.Directory.Pets[Pet.id].huge) or
                        (Settings.Rarities["Titanic"] and Library.Directory.Pets[Pet.id].titanic) then
                        return true
                    end
                end
                return false
            end

            local function CalculateItemsInTable(Table, AmountOfLoops)
                local AmountToReturn = 0
                if AmountOfLoops == 1 then
                    for i, v in pairs(Table) do
                        AmountToReturn = AmountToReturn + 1
                    end
                elseif AmountOfLoops == 2 then
                    for i, v in pairs(Table) do
                        for i2, v2 in pairs(v) do
                            AmountToReturn = AmountToReturn + 1
                        end
                    end
                end
                return AmountToReturn
            end

            local function CheckForSnipePet(PetUid)
                local Found = false
                for i, v in pairs(game:GetService("Workspace")["__MAP"].Interactive.Booths:GetDescendants()) do
                    task.spawn(function()
                        if v.Name == PetUid then
                            Found = true
                        end
                    end)
                end
                return Found
            end

            local function sellPet()
                print("Loaded seller")
                AdvancedSignal("Loaded Seller", Color3.fromRGB(115, 80, 255))
                for _, v in pairs(Library.Save.Get().Pets) do
                    local RAPAve = Library.RAPCmds.Get(v)
                    if not v.l then
                        for _, v2 in pairs(sellingList) do
                            if v2[1] ~= v.id then
                                continue
                            end
                            local rarity = (v.g and "Golden") or (v.r and "Rainbow") or (v.dm and "Dark Matter") or
                                               "Regular"
                            if v2[3][1] ~= rarity then
                                continue
                            end

                            if v.sh and v2[3][2] ~= nil then
                                if RAPAve ~= nil then
                                    if RAPAve > v2[2] then
                                        table.insert(inventoryList, {v.uid, RAPAve})
                                        break
                                    else
                                        table.insert(inventoryList, {v.uid, v2[2]})
                                        break
                                    end
                                else
                                    table.insert(inventoryList, {v.uid, v2[2]})
                                    break
                                end
                            elseif not v.sh and v2[3][2] == nil then
                                if RAPAve ~= nil then
                                    if RAPAve > v2[2] then
                                        table.insert(inventoryList, {v.uid, RAPAve})
                                        break
                                    else
                                        table.insert(inventoryList, {v.uid, v2[2]})
                                        break
                                    end
                                else
                                    table.insert(inventoryList, {v.uid, v2[2]})
                                    break
                                end
                            end
                            
                        end
                    end
                end

                table.sort(inventoryList, function(a, b)
                    return a[2] > b[2]
                end)

                for _, v in pairs(inventoryList) do
                    if #inventoryList >= 1 then
                        table.insert(addedList, v)
                    end
                    if #addedList == 12 then
                        break
                    end
                end
                local added = false
                while added == false do
                    added = Invoke("Add Trading Booth Pet", addedList)
                    task.wait(0.1)
                end
            end

            local function sendSnipeWebhook(petUID, price, diamonds, owner)
                local Pet = Library.PetCmds.Get(petUID)
                local PetName = Library.Directory.Pets[Pet.id].name
                local PetType = (Pet.r and "Rainbow ") or (Pet.g and "Golden ") or (Pet.dm and "Dark Matter ") or ""
                local PetImage =
                    Library.Directory.Pets[Pet.id][(Pet.r and "thumbnail") or (Pet.g and "goldenThumbnail") or
                        (Pet.dm and "darkMatterThumbnail") or "thumbnail"]:split("//")[2]

                if Library.Directory.Pets[Pet.id].huge or Library.Directory.Pets[Pet.id].titanic then
                    Webhook(shared.Settings.SnipeLink, {
                        ["embeds"] = {{
                            ["title"] = "Sniped A " .. ((Pet.sh and "Shiny ") or "") .. PetType .. PetName,
                            ["thumbnail"] = {
                                ["url"] = httpService:JSONDecode(game:HttpGet(
                                    ("https://thumbnails.roblox.com/v1/assets?assetIds=" .. PetImage ..
                                        "&size=250x250&format=Png&isCircular=false"))).data[1].imageUrl
                            },
                            ["description"] = "**Sniped For:** " .. price .. " :diamonds:\n**From:** ||" ..
                                UserIDToUsername(owner) .. "||\n**Current Diamonds:** " .. diamonds ..
                                ":diamonds:\n**Account:** ||" .. Player.Name .. "||",
                            ["type"] = "rich",
                            ["color"] = tonumber(0x00ff00)
                        }}
                    })
                end
            end

            local function attemptPurchase(boothIndex, petUID, price, owner)
                task.spawn(function()
                    local Success = false
                    repeat
                        Success = Invoke("Purchase Trading Booth Pet", boothIndex, petUID, price)
                        task.wait()
                    until CheckForSnipePet(petUID) == false
                    if Success then
                        addPet()
                        OldSavedPets = {}
                        for i, v in pairs(Library.Save.Get().Pets) do
                            table.insert(OldSavedPets, v)
                        end
                        sendSnipeWebhook(petUID, Library.Functions.NumberShorten(price),
                            Library.Functions.NumberShorten(Library.Save.Get().Diamonds), owner)
                        return Success
                    end
                end)
            end

            local function SettingsChecker(Config, Check)
                if Config == Check then
                    return true
                end
                return false
            end

            local Purchased = false
            local function snipePet()
                print("Loaded sniper")
                AdvancedSignal("Loaded Sniper", Color3.fromRGB(115, 80, 255))
                task.spawn(function()
                    while true do
                        pcall(function()
                            for i, v in
                                pairs(debug.getupvalues(getsenv(Scripts.Game["Trading Booths"]).SetupClaimed)[1]) do
                                task.spawn(function()
                                    pcall(function()
                                        if CalculateItemsInTable(v.Listings, 1) >= 1 and v.Owner ~= Player.UserId then
                                            for i2, v2 in pairs(v.Listings) do
                                                for i3, v3 in pairs(snipeList) do
                                                    local Pet = Library.PetCmds.Get(i2)
                                                    local Settings = {
                                                        ["Regular"] = (SettingsChecker(v3[3], "Regular") and true) or
                                                            false,
                                                        ["Hardcore"] = (SettingsChecker(v3[3], "Hardcore") and true) or
                                                            false,
                                                        ["Shiny"] = (SettingsChecker(v3[3], "Shiny") and true) or false,
                                                        ["Golden"] = (SettingsChecker(v3[3], "Golden") and true) or
                                                            false,
                                                        ["Rainbow"] = (SettingsChecker(v3[3], "Rainbow") and true) or
                                                            false,
                                                        ["Dark Matter"] = (SettingsChecker(v3[3], "Dark Matter") and
                                                            true) or false,
                                                        ["Any"] = (SettingsChecker(v3[3], "Any") and true) or false
                                                    }
                                                    local belowMax = (Library.Save.Get(
                                                                         game:GetService("Players")[UserIDToUsername(
                                                            v.Owner)]).Diamonds + v2.Price) < 10000000000001
                                                    if v3[1] ~= "" and Pet.id == v3[1] and Library.Save.Get().Diamonds >=
                                                        v2.Price and v3[2] >= v2.Price and
                                                        CheckTypeOrRarity("Type", Settings, Pet) and belowMax then
                                                        Root:PivotTo(v.Model.Booth.CFrame * CFrame.new(0, -13, 0))
                                                        Purchased = attemptPurchase(tonumber(i), i2, v2.Price, v.Owner)
                                                        if Purchased then
                                                            addPet()
                                                        end
                                                    elseif v3[4] ~= "" then
                                                        Settings["Rarities"] = {
                                                            ["Basic"] = (SettingsChecker(v3[4], "Basic") and true) or
                                                                false,
                                                            ["Rare"] = (SettingsChecker(v3[4], "Rare") and true) or
                                                                false,
                                                            ["Epic"] = (SettingsChecker(v3[4], "Epic") and true) or
                                                                false,
                                                            ["Legendary"] = (SettingsChecker(v3[4], "Legendary") and
                                                                true) or false,
                                                            ["Mythical"] = (SettingsChecker(v3[4], "Mythical") and true) or
                                                                false,
                                                            [""] = (SettingsChecker(v3[4], "") and true) or false,
                                                            ["Event"] = (SettingsChecker(v3[4], "Event") and true) or
                                                                false,
                                                            ["Exclusive"] = (SettingsChecker(v3[4], "Exclusive") and
                                                                true) or false,
                                                            ["Huge"] = (SettingsChecker(v3[4], "Huge") and true) or
                                                                false,
                                                            ["Titanic"] = (SettingsChecker(v3[4], "Titanic") and true) or
                                                                false
                                                        }
                                                        if Library.Save.Get().Diamonds >= v2.Price and v3[2] >= v2.Price and
                                                            CheckTypeOrRarity("Type", Settings, Pet) and
                                                            CheckTypeOrRarity("Rarity", Settings, Pet) and belowMax then
                                                            Root:PivotTo(v.Model.Booth.CFrame * CFrame.new(0, -13, 0))
                                                            Purchased =
                                                                attemptPurchase(tonumber(i), i2, v2.Price, v.Owner)
                                                            if Purchased then
                                                                addPet()
                                                            end
                                                        end
                                                    end
                                                    if Purchased then
                                                        break
                                                    end
                                                end
                                                if Purchased then
                                                    break
                                                end
                                            end
                                        end
                                    end)
                                end)
                                if Purchased then
                                    Purchased = false
                                    break
                                end
                            end
                        end)
                        task.wait()
                    end
                end)
            end

            while not getsenv(Scripts.Game["Trading Booths"]).GetBooth() do
                getBooths = Invoke("Get All Booths")
                claimedBooths = {}
                for k, v in pairs(getBooths) do
                    table.insert(claimedBooths, tonumber(k))
                end
                table.sort(claimedBooths, function(a, b)
                    return a < b
                end)
                for x = 1, 40 do
                    if x ~= claimedBooths[x] then
                        Invoke("Claim Trading Booth", x)
                        Root:PivotTo(playerPos)
                        break
                    end
                end
            end

            task.spawn(function()
                pcall(function()
                    sellPet()
                end)
            end)

            task.spawn(function()
                pcall(function()
                    snipePet()
                end)
            end)

            VirtualPressButton("X")
        end)
    end)
end
