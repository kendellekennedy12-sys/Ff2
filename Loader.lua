repeat task.wait() until game:IsLoaded()

--// Phantom Hub Loader
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

--// CONFIG
local CONFIG = {
    Version = "1.3.0",

    VersionURL = "https://raw.githubusercontent.com/YOURNAME/phantomhub/main/version.txt",
    KeyURL = "https://raw.githubusercontent.com/YOURNAME/phantomhub/main/keys.txt",
    MainURL = "https://raw.githubusercontent.com/YOURNAME/phantomhub/main/main.lua",

    AllowedGames = {
        [PLACEID_HERE] = true, -- add more if needed
    }
}

--// GAME CHECK
if not CONFIG.AllowedGames[game.PlaceId] then
    LocalPlayer:Kick("Phantom Hub ❌ Unsupported Game")
    return
end

--// VERSION CHECK
local latestVersion
pcall(function()
    latestVersion = game:HttpGet(CONFIG.VersionURL)
end)

if latestVersion and latestVersion:gsub("%s+", "") ~= CONFIG.Version then
    LocalPlayer:Kick(
        "Phantom Hub ⚠️ Outdated Version\n" ..
        "Current: "..CONFIG.Version..
        "\nLatest: "..latestVersion
    )
    return
end

--// KEY SYSTEM
if not _G.PhantomHubKey then
    LocalPlayer:Kick(
        "Phantom Hub 🔐 Key Required\n\n" ..
        "Set _G.PhantomHubKey before executing"
    )
    return
end

local valid = false
pcall(function()
    local keys = game:HttpGet(CONFIG.KeyURL)
    for key in string.gmatch(keys, "[^\r\n]+") do
        if key == _G.PhantomHubKey then
            valid = true
            break
        end
    end
end)

if not valid then
    LocalPlayer:Kick("Phantom Hub ❌ Invalid Key")
    return
end

--// LOAD MAIN
loadstring(game:HttpGet(CONFIG.MainURL))()
