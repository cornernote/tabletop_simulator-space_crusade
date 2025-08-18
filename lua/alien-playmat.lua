local blipText = nil
local reinforcementText = nil

-- offsets relative to mat local axes
local blipOffset = {x = 10, y = 1, z = -6}    -- left top
local reinfOffset = {x = -7, y = 1, z = -6}    -- right top

-- convert local offset to world coordinates
local function localToWorld(offset, obj)
    local rotY = math.rad(obj.getRotation().y)
    local cosR = math.cos(rotY)
    local sinR = math.sin(rotY)
    local worldX = obj.getPosition().x + offset.x * cosR + offset.z * sinR
    local worldZ = obj.getPosition().z - offset.x * sinR + offset.z * cosR
    local worldY = obj.getPosition().y + offset.y + obj.getBounds().size.y/2
    return {x = worldX, y = worldY, z = worldZ}
end

function spawnLabels()
    -- Blip Tokens
    local blipPos = localToWorld(blipOffset, self)
    blipText = spawnObject({
        type = "3DText",
        position = blipPos,
        rotation = {45, self.getRotation().y + 180, 0},
    })
    blipText.setValue("Blip Tokens")
    blipText.interactable = false

    -- Reinforcement Tokens
    local reinfPos = localToWorld(reinfOffset, self)
    reinforcementText = spawnObject({
        type = "3DText",
        position = reinfPos,
        rotation = {45, self.getRotation().y + 180, 0},
    })
    reinforcementText.setValue("Reinforcement Tokens")
    reinforcementText.interactable = false
end

function onLoad()
    spawnLabels()
end

function onPickUp(color)
    if blipText then blipText.destroy() end
    if reinforcementText then reinforcementText.destroy() end
end

function onDrop(color)
    Wait.time(function()
        spawnLabels()
    end, 1)
end

function onDestroy()
    if blipText then
        blipText.destroy()
        blipText = nil
    end
    if reinforcementText then
        reinforcementText.destroy()
        reinforcementText = nil
    end
end