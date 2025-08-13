-- This script is for a Bag object.
-- To use it, right-click the bag, go to "Scripting", and paste this code.

-- The name of the player who is allowed to take items from this bag.
-- IMPORTANT: Replace 'cornernote' with your actual username.
local ownerName = "☣CoRNeRNoTe☣"

-- Helper function to find the player with the cursor closest to a given position.
-- This is a workaround for not having the player in the `onObjectLeaveContainer` event.
function findClosestPlayer(objectPosition)
    local closestPlayer = nil
    local minDistance = math.huge

    -- Get all players in the game, seated or not.
    for _, player in ipairs(Player.getPlayers()) do
        local cursorPosition = player.getPointerPosition()
        if cursorPosition ~= nil then
            -- Calculate the distance between the player's cursor and the object.
            local distance = Vector.distance(cursorPosition, objectPosition)

            -- If this player's cursor is closer than the previous closest,
            -- update our closest player.
            if distance < minDistance then
                minDistance = distance
                closestPlayer = player
            end
        end
    end

    return closestPlayer
end

-- Called when an object leaves the container.
function onObjectLeaveContainer(container, removedObject)
    -- Get the position of the container.
    local containerPosition = container.getPosition()

    -- Find the player whose cursor is closest to the bag when the item is removed.
    local player = findClosestPlayer(containerPosition)

    -- Check if a player was found and if their name is not the owner's name.
    if player ~= nil and player.steam_name ~= ownerName then
        -- The player is not the owner, so we need to return the object.
        
        -- Get the unique GUID of the removed object right away.
        local objectGuid = removedObject.getGUID()

        -- Send a message to all players to let them know an unauthorized removal was attempted.
        broadcastToAll("WARNING: "..player.." attempted to steal from " .. ownerName .. "'s bag!", {0, 0.5, 1})
return
        -- Return the object to the bag. We use a Timer to prevent scripting issues.
        container.putObject(removedObject, false)
    end
end
