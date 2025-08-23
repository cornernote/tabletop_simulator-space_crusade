function onLoad()
    Timer.destroy('screenSpawnTimer')
    self.clearContextMenu()
    self.addContextMenuItem("Fix", reset, false) -- false = show for all players
end

function reset(player_color)
    copy({ self })
    self.destruct()
    Timer.create({
        identifier = 'screenSpawnTimer',
        function_name = 'timerTick',
        function_owner = self,
        parameters = { self.getPosition(), self.getRotation() },
        delay = 0.01
    })
end

function timerTick(param)
    local pasted = paste({})
    if pasted and #pasted > 0 then
        pasted[1].setPosition(param[1])
        pasted[1].setRotation(param[2])
    end
end