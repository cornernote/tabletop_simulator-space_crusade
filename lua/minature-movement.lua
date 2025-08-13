--[dnd-measurement-injector]--
function onPickUp(color)
    local gridX = Grid and Grid.sizeX or 2
    local startPos = self.getPosition()

    for _, hit in ipairs(Physics.cast({
        origin = self.getBounds().center,
        direction = {0, -1, 0},
        type = 1,
        max_distance = 10
    })) do
        if hit.point and hit.hit_object ~= self then
            startPos = hit.point
            break
        end
    end

    local token = spawnObject({
        type = "Custom_Tile",
        position = startPos,
        rotation = {0, Player[color].getPointerRotation(), 0},
        scale = {gridX / 2.2, 0.1, gridX / 2.2}
    })

    token.setLock(true)
    token.setCustomObject({
        image = "https://steamusercontent-a.akamaihd.net/ugc/1021697601906583980/C63D67188FAD8B02F1B58E17C7B1DB304B7ECBE3/",
        thickness = 0.1,
        type = 2
    })
    token.interactable = false

    token.createButton({
        click_function = "noop",
        function_owner = self,
        label = "00",
        position = {0, 0.1, 0},
        width = 0, height = 0,
        font_size = 600
    })

    local parentGUID = self.getGUID()
    token.setLuaScript([=[
        local time_of_release = nil
        
        function onUpdate()
            local parent = getObjectFromGUID("]=] .. parentGUID .. [=[")
            
            if parent and parent.held_by_color then
			    if (not time_of_release) then
					local gridX = Grid and Grid.sizeX or 2
					local diff = self.getPosition() - parent.getPosition()
					diff.y = 0
					local dist = math.max(math.abs(diff.x), math.abs(diff.z)) * (5.0 / gridX)
					self.editButton({index=0, label=tostring(math.floor((dist+2.5)/5.0))})
                end
            else
                -- The object is NOT being held.
                -- Start the timer if it hasn't been started yet.
                if time_of_release == nil then
                    time_of_release = os.clock()
                end

                -- Check if 3 seconds have passed since release.
                if os.clock() - time_of_release >= 3 then
                    destroyObject(self)
                end
            end
        end
    ]=])
end

function noop() end