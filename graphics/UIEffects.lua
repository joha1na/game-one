local UIEffects = {}

-- UI-Effekte für bessere Benutzeroberfläche
-- Verwaltet Animationen, Übergänge und visuelle Verbesserungen für die UI

UIEffects.animations = {}
UIEffects.screenShake = {active = false, intensity = 0, duration = 0}
UIEffects.fadeEffect = {active = false, alpha = 0, direction = 1, speed = 2}

--[[
    Initialisiert die UI-Effekte
]]
function UIEffects.init()
    UIEffects.animations = {}
end

--[[
    Aktualisiert alle UI-Effekte
    @param dt number - Delta-Zeit seit dem letzten Update
]]
function UIEffects.update(dt)
    -- Bildschirm-Shake aktualisieren
    if UIEffects.screenShake.active then
        UIEffects.screenShake.duration = UIEffects.screenShake.duration - dt
        if UIEffects.screenShake.duration <= 0 then
            UIEffects.screenShake.active = false
            UIEffects.screenShake.intensity = 0
        end
    end
    
    -- Fade-Effekt aktualisieren
    if UIEffects.fadeEffect.active then
        UIEffects.fadeEffect.alpha = UIEffects.fadeEffect.alpha + 
            (UIEffects.fadeEffect.direction * UIEffects.fadeEffect.speed * dt)
        
        if UIEffects.fadeEffect.alpha >= 1 then
            UIEffects.fadeEffect.alpha = 1
            UIEffects.fadeEffect.active = false
        elseif UIEffects.fadeEffect.alpha <= 0 then
            UIEffects.fadeEffect.alpha = 0
            UIEffects.fadeEffect.active = false
        end
    end
    
    -- Animationen aktualisieren
    for i = #UIEffects.animations, 1, -1 do
        local anim = UIEffects.animations[i]
        anim.time = anim.time + dt
        
        if anim.time >= anim.duration then
            table.remove(UIEffects.animations, i)
        end
    end
end

--[[
    Startet einen Bildschirm-Shake-Effekt
    @param intensity number - Intensität des Shake-Effekts
    @param duration number - Dauer des Effekts in Sekunden
]]
function UIEffects.startScreenShake(intensity, duration)
    UIEffects.screenShake.active = true
    UIEffects.screenShake.intensity = intensity
    UIEffects.screenShake.duration = duration
end

--[[
    Startet einen Fade-Effekt
    @param direction number - Richtung (1 für fade in, -1 für fade out)
    @param speed number - Geschwindigkeit des Fade-Effekts
]]
function UIEffects.startFade(direction, speed)
    UIEffects.fadeEffect.active = true
    UIEffects.fadeEffect.direction = direction
    UIEffects.fadeEffect.speed = speed or 2
    if direction == 1 then
        UIEffects.fadeEffect.alpha = 0
    else
        UIEffects.fadeEffect.alpha = 1
    end
end

--[[
    Fügt eine neue Animation hinzu
    @param animationType string - Typ der Animation
    @param x number - X-Position
    @param y number - Y-Position
    @param duration number - Dauer der Animation
]]
function UIEffects.addAnimation(animationType, x, y, duration)
    table.insert(UIEffects.animations, {
        type = animationType,
        x = x,
        y = y,
        time = 0,
        duration = duration or 1
    })
end

--[[
    Wendet den Bildschirm-Shake-Effekt an
]]
function UIEffects.applyScreenShake()
    if UIEffects.screenShake.active then
        local shakeX = (math.random() - 0.5) * UIEffects.screenShake.intensity
        local shakeY = (math.random() - 0.5) * UIEffects.screenShake.intensity
        love.graphics.push()
        love.graphics.translate(shakeX, shakeY)
    end
end

--[[
    Beendet den Bildschirm-Shake-Effekt
]]
function UIEffects.endScreenShake()
    if UIEffects.screenShake.active then
        love.graphics.pop()
    end
end

--[[
    Zeichnet den Fade-Effekt
]]
function UIEffects.drawFadeEffect()
    if UIEffects.fadeEffect.active then
        love.graphics.setColor(0, 0, 0, UIEffects.fadeEffect.alpha)
        love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1) -- Farbe zurücksetzen
    end
end

--[[
    Zeichnet alle aktiven Animationen
]]
function UIEffects.drawAnimations()
    for _, anim in ipairs(UIEffects.animations) do
        if anim.type == "scorePopup" then
            local progress = anim.time / anim.duration
            local alpha = 1 - progress
            local scale = 1 + progress * 0.5
            
            love.graphics.push()
            love.graphics.setColor(1, 1, 0, alpha)
            love.graphics.translate(anim.x, anim.y - progress * 30)
            love.graphics.scale(scale, scale)
            love.graphics.print("+100", 0, 0)
            love.graphics.pop()
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
end

--[[
    Zeichnet einen Glow-Effekt um Text
    @param text string - Text zum Zeichnen
    @param x number - X-Position
    @param y number - Y-Position
    @param color table - Farbe {r, g, b, a}
]]
function UIEffects.drawGlowText(text, x, y, color)
    color = color or {1, 1, 1, 1}
    
    -- Glow-Effekt (mehrere leicht versetzte Kopien)
    love.graphics.setColor(color[1], color[2], color[3], 0.03)
    for dx = -4, 4 do
        for dy = -4, 4 do
            if dx ~= 0 or dy ~= 0 then
                love.graphics.print(text, x + dx, y + dy)
            end
        end
    end
    
    -- Haupttext
    love.graphics.setColor(color[1], color[2], color[3], color[4])
    love.graphics.print(text, x, y)
    
    love.graphics.setColor(1, 1, 1, 1) -- Farbe zurücksetzen
end

--[[
    Zeichnet einen Button mit Hover-Effekt
    @param text string - Button-Text
    @param x number - X-Position
    @param y number - Y-Position
    @param width number - Button-Breite
    @param height number - Button-Höhe
    @param isHovered boolean - Ist der Button gehovered
    @return boolean - Ist der Button geklickt worden
]]
function UIEffects.drawButton(text, x, y, width, height, isHovered)
    local color = isHovered and {0.3, 0.7, 1} or {0.2, 0.2, 0.8}
    local alpha = isHovered and 0.8 or 0.6
    
    -- Button-Hintergrund
    love.graphics.setColor(color[1], color[2], color[3], alpha)
    love.graphics.rectangle('fill', x, y, width, height)
    
    -- Button-Rand
    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle('line', x, y, width, height)
    
    -- Button-Text
    local font = love.graphics.getFont()
    local textWidth = font:getWidth(text)
    local textHeight = font:getHeight()
    local textX = x + (width - textWidth) / 2
    local textY = y + (height - textHeight) / 2
    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(text, textX, textY)
    
    love.graphics.setColor(1, 1, 1, 1) -- Farbe zurücksetzen
end

--[[
    Erstellt einen Puls-Effekt für wichtige UI-Elemente
    @param time number - Aktuelle Zeit
    @return number - Puls-Wert zwischen 0.85 und 1.15
]]
function UIEffects.getPulseValue(time)
    return 0.85 + 0.15 * math.sin(time * 3)
end

return UIEffects
