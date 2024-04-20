
local playerDetector = peripheral.wrap("top")

local function savePlayerData()
    local players = playerDetector.getOnlinePlayers()
    while true do
        for _, player in ipairs(players) do
            local playerData = playerDetector.getPlayerPos(player)
            if playerData.respawnPosition == nil then
                playerData.respawnPosition = {x=0, y=0, z=0}
            end

            if playerData.respawnAngle == nil then
                playerData.respawnAngle = 0
            end

            if playerData.respawnDimension == nil then
                playerData.respawnDimension = 'minecraft:overworld'
            end

            local header = {
                ["Content-Type"] = "application/json",
                ["player"] = player,
                ["respawnAngle"] = tostring(playerData.respawnAngle + 0.0001),
                ["maxHP"] = tostring(playerData.maxHeatlh),
                ["health"] = tostring(playerData.health),
                ["airSupply"] = tostring(playerData.airSupply),
                ["respawnDimention"] = tostring(playerData.respawnDimension),
                ["x"] = tostring(playerData.x),
                ["y"] = tostring(playerData.y),
                ["z"] = tostring(playerData.z),
                ["eyeHeight"] = tostring(playerData.eyeHeight),
                ["yaw"] = tostring(playerData.yaw),
                ["pitch"] = tostring(playerData.pitch),
                ["dimension"] = tostring(playerData.dimension),
                ["respawnX"] = tostring(playerData.respawnPosition.x),
                ["respawnY"] = tostring(playerData.respawnPosition.y),
                ["respawnZ"] = tostring(playerData.respawnPosition.z)
            }            
            
            print(textutils.serializeJSON(header))
            print("----")

            local response = http.post("http://185.105.91.126:27777/api/saveplayerdata", "", header)
    
            if response then
                print(response.readAll())
            end
        end
        sleep(30)
    end
end

local function handlePLayerJoin()
    while true do
        local event, username, dimension = os.pullEvent("playerJoin")
        print("Player " .. username .. " joined the server in the dimension " .. dimension)
        print("----")
    
        local header = {
            ["player"] = username,
            ["dimension"] = dimension,
            ["logged"] = "true"
        }
                
        print(textutils.serializeJSON(header))
    
        local response = http.post("http://185.105.91.126:27777/api/playerlogin", "", header)
    
        if response then
            print(response.readAll())
        end        
    end
end

local function handlePLayerLeave()
    while true do
        local event, username, dimension = os.pullEvent("playerLeave")
        print("Player " .. username .. " joined the server in the dimension " .. dimension)
        print("----")
    
        local header = {
            ["player"] = username,
            ["dimension"] = dimension,
            ["logged"] = "false"
        }
                
        print(textutils.serializeJSON(header))
    
        local response = http.post("http://185.105.91.126:27777/api/playerlogin", "", header)
    
        if response then
            print(response.readAll())
        end      
    end
end

local function handlePlayerDimChange()
    while true do
        local event, username, fromDim, toDim = os.pullEvent("playerChangedDimension")
        print("Player " .. username .. " left the dimension " .. fromDim .. " and is now in " .. toDim)
        print("----")
        local header = {
            ["player"] = username,
            ["toDim"] = toDim,
            ["fromDim"] = fromDim
        }
    
        local response = http.post("http://185.105.91.126:27777/api/dimchanged", "", header)
    
        if response then
            print(response.readAll())
        end        
    end
end

parallel.waitForAll(savePlayerData, handlePLayerJoin, handlePLayerLeave, handlePlayerDimChange)


