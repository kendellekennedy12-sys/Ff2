repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- CONFIG
local CONFIG = {
    Version = "1.3.0",
    VersionURL = "RAW_version.txt",
    KeyURL = "https://raw.githubusercontent.com/kendellekennedy12-sys/Ff2/refs/heads/main/Keys.txt",
    MainURL = "RAW_main.enc",

    AllowedGames = {
        [PLACEID_HERE] = true
    }
}

-- GAME CHECK
if not CONFIG.AllowedGames[game.PlaceId] then
    LocalPlayer:Kick("Phantom Hub | Unsupported Game")
    return
end

-- VERSION CHECK
local latest
pcall(function()
    latest = game:HttpGet(CONFIG.VersionURL)
end)

if latest and latest:gsub("%s+", "") ~= CONFIG.Version then
    LocalPlayer:Kick("Phantom Hub | Outdated Version")
    return
end

-- KEY CHECK
if not _G.PhantomHubKey then
    LocalPlayer:Kick("Phantom Hub | No Key Set")
    return
end

local valid = false
pcall(function()
    for key in string.gmatch(game:HttpGet(CONFIG.KeyURL), "[^\r\n]+") do
        if key == _G.PhantomHubKey then
            valid = true
            break
        end
    end
end)

if not valid then
    LocalPlayer:Kick("Phantom Hub | Invalid Key")
    return
end

-- 🔓 DECRYPT
local SECRET = "PHANTOM_KEY_7391"

local function xor(str, key)
    local out = {}
    for i = 1, #str do
        local k = key:byte((i - 1) % #key + 1)
        out[i] = string.char(bit32.bxor(str:byte(i), k))
    end
    return table.concat(out)
end

local encrypted = game:HttpGet(CONFIG.MainURL)
local decoded = HttpService:Base64Decode(encrypted)
local decrypted = xor(decoded, SECRET)

-- ▶ RUN BINARY WRAPPER
loadstring(decrypted)()
