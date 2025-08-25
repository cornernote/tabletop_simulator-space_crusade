ZONE_GUID = "6c0858"

function calculateTotalValue()
    local zone = getObjectFromGUID(ZONE_GUID)

    if zone == nil then
        printToAll("Error: Scripting zone with GUID '" .. ZONE_GUID .. "' was not found. Please check the script.", "Red")
        return
    end

    local objectsInZone = zone.getObjects()
    
    local totalValue = 0
    local objectCount = 0

    for _, obj in ipairs(objectsInZone) do
        local description = obj.getDescription()
        
        local points_string = string.match(description, "- Points : (%d+)")

        if points_string ~= nil then
            local value = tonumber(points_string)

            if value ~= nil then
                totalValue = totalValue + value
                objectCount = objectCount + 1
            end
        end
    end

    local message = "Total value of " .. objectCount .. " objects in the zone: " .. totalValue
    broadcastToAll(message, {r=0.4, g=0.8, b=0.4})
end

function onload()
    self.clearButtons()

    local buttonParameters = {
        click_function = "calculateTotalValue",
        function_owner = self,
        label          = "Calculate Value",
        position       = {1.2, 0.3, 1},
        height         = 60,
        width          = 400,
        font_size      = 40,
    }

    self.createButton(buttonParameters)
end
