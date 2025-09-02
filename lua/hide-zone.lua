local hiddenZoneID = null

function onSave()
    return hiddenZoneID
end

function onload(savedZoneId)
    hiddenZoneID = savedZoneId
    if not getObjectFromGUID(hiddenZoneID) then
        hiddenZoneID = null
    end

    local label = 'Hide Zone'
    if hiddenZoneID then
        label = 'Show Zone'
    end

    self.createButton({
        click_function = 'null',
        function_owner = self,
        label = label,
        position = { 0, 0.8, 0 },
        rotation = { 0, 0, 0 },
        width = 0,
        height = 0,
        font_size = 280,
        color = ({ 204 / 255, 202 / 255, 192 / 255 }),
        font_color = { 1, 1, 1 },
        tooltip = "Click to Toggle Hidden Zone",
    })
    self.createButton({
        click_function = 'toggleHide',
        function_owner = self,
        label = '',
        position = { 0, 0.8, 0 },
        rotation = { 0, 0, 0 },
        width = 1200,
        height = 1200,
        font_size = 280,
        color = ({ 0, 0, 0, 0 }),
        font_color = { 0, 0, 0 },
        tooltip = "Click to Toggle Hidden Zone",
    })
end

function onDestroy()
    print("onPickup")
end

function toggleHide (obj, c, alt)
    self.AssetBundle.playTriggerEffect(1)
    scriptZone = getObjectFromGUID(obj.getDescription())
    if hiddenZoneID then
        local object = getObjectFromGUID(hiddenZoneID)
        if object then
            destroyObject(object)
        end
        hiddenZoneID = null
        self.editButton({ index = 0, label = 'Hide Zone' })
    else
        hiddenZone = spawnObject({
            type = "FogOfWarTrigger",
            rotation = scriptZone.getRotation(),
            scale = scriptZone.getScale(), })
        hiddenZone.setPosition(scriptZone.getPosition())
        hiddenZone.setValue("Black")
        hiddenZoneID = hiddenZone.getGUID()
        self.editButton({ index = 0, label = 'Show Zone' })
    end
end