local lifespan = 3
local spin_speed = 3
local rise_speed = 1
local grow_speed = 2
local font_size = 3
local log_chat = true
local roll_active = false
local rv = false

function onLoad()
    rv = self.getRotationValues() or false
end

function onDrop(player_color)
    trigger(player_color)
end

function onRandomize(player_color)
    trigger(player_color)
end

function trigger(player_color)
    if roll_active then
        return
    end
    roll_active = true

    Wait.condition(
            function()
                roll_active = false
                local roll_value = self.getRotationValue() or false
                if not roll_value or not rv then
                    log("Dice " .. self.guid .. " has no valid rotation value set! Unable to show roll value.")
                    return
                end

                local pos = self.getPosition() + Vector({ 0, 1 + font_size / 5, 0 })
                local text_obj = spawnObject({ type = "3DText", position = pos, sound = true })

                text_obj.TextTool.setValue(tostring(roll_value))
                text_obj.TextTool.setFontColor(self.getColorTint())
                text_obj.TextTool.setFontSize(font_size * 24)

                Wait.frames(function()
                    text_obj.interactable = false
                    text_obj.auto_raise = false

                    rise(text_obj, pos)
                    spin(text_obj, { 0, spin_speed * 18, 0 })
                    grow(text_obj, font_size * 24)

                    if log_chat then
                        local label = player_color
                        if self.getName() and self.getName() ~= "" then
                            label = label .. " | " .. self.getName()
                        end
                        printToAll("[" .. label .. "] " .. Player[player_color].steam_name ..
                                " rolled a " .. roll_value, player_color)
                    end

                    Wait.time(function()
                        text_obj.destruct()
                    end, lifespan)
                end, 1)
            end,
            function()
                return self.resting
            end,
            30,
            function()
                log("Timeout exceeded waiting for dice to stop rolling")
                roll_active = false
            end
    )
end

function rise(obj, pos)
    if not getObjectFromGUID(obj.guid) then
        return
    end
    obj.setPosition(pos)
    pos[2] = pos[2] + rise_speed / 100
    Wait.frames(function()
        rise(obj, pos)
    end, 1)
end

function spin(obj, rot)
    if not getObjectFromGUID(obj.guid) then
        return
    end
    obj.setRotationSmooth(rot, false, true)
    rot[2] = rot[2] + spin_speed * 5
    Wait.time(function()
        spin(obj, rot)
    end, 0.5)
end

function grow(obj, size)
    if not getObjectFromGUID(obj.guid) then
        return
    end
    obj.TextTool.setFontSize(size)
    Wait.time(function()
        grow(obj, size * (grow_speed + 100) / 100)
    end, 0.1)
end
