function onPickUp(color)
    local gridX = Grid and Grid.sizeX or 2
    local startPos = self.getPosition()

    for _, hit in ipairs(Physics.cast({
        origin = self.getBoundsNormalized().center - self.getBoundsNormalized().size,
        direction = { 0, -1, 0 },
        type = 1,
        max_distance = 10
    })) do
        if hit.point and hit.hit_object ~= self then
            startPos = hit.point
            break
        end
    end

    startPos[2] = startPos[2] + 0.01

    local spinner = spawnObject({
        type = "Custom_Model",
        position = startPos,
        rotation = { 0, 0, 0 },
        scale = { gridX / 2.2, 0.1, gridX / 2.2 }
    })

    spinner.setLock(true)
    spinner.setCustomObject({
        type = "coin",
        mesh = "http://pastebin.com/raw/RBUFj0HE",
        collider = "http://pastebin.com/raw/bUwzJeWz"
    })
    spinner.setColorTint({ 1, 1, 1 })
    spinner.interactable = false
    spinner.lock()

    spinner.createButton({
        click_function = "null",
        function_owner = self,
        label = "0",
        position = { 0, 0, 0 },
        font_color = color,
        width = 0,
        height = 0,
        font_size = 400
    })

    self.clearButtons()
    self.createButton({
        click_function = "null",
        function_owner = self,
        label = "0",
        position = { 0, self.getVisualBoundsNormalized().size.z + 1, 0 },
        font_color = { 1, 1, 1 },
        width = 0,
        height = 0,
        font_size = 400
    })

    local parentGUID = self.getGUID()
    spinner.setLuaScript([=[
        local time_of_release = nil
        
        function onUpdate()
            local parent = getObjectFromGUID("]=] .. parentGUID .. [=[")
            
            if parent and parent.held_by_color then
			    if (not time_of_release) then
					local gridX = Grid and Grid.sizeX or 2
					local diff = self.getPosition() - parent.getPosition()
					diff.y = 0
					local dist = math.max(math.abs(diff.x), math.abs(diff.z)) * (5.0 / gridX)
					parent.editButton({index=0, label=tostring(math.floor((dist+2.5)/5.0))})
					self.editButton({index=0, label=tostring(math.floor((dist+2.5)/5.0))})
					self.setRotation({0, self.getRotation().y + 1, 0})
                end
            else
                -- The object is NOT being held.
                if time_of_release == nil then
                    time_of_release = os.clock()
                end

                -- Check if time has passed since release.
                if os.clock() - time_of_release >= 5 then
                    destroyObject(self)
                end
            end
        end
    ]=])
end

local time_of_release = nil
function onUpdate()
    if self.held_by_color then
        time_of_release = nil
    else
        if time_of_release == nil then
            time_of_release = os.clock()
        end

        if os.clock() - time_of_release >= 5 then
            self.clearButtons()
        end
    end
end
