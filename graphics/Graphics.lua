local Graphics = {}

-- Grafiken-Manager für das Spiel
-- Verwaltet Sprites, Texturen und visuelle Effekte

Graphics.sprites = {}
Graphics.particleSystems = {}

--[[
    Initialisiert das Grafik-System
    Erstellt einfache prozedurale Sprites
]]
function Graphics.init()
    -- Erstelle Spieler-Sprite (Dreieck als Raumschiff)
    Graphics.sprites.player = Graphics.createPlayerSprite()
    
    -- Erstelle Gegner-Sprite (umgedrehtes Dreieck)
    Graphics.sprites.enemy = Graphics.createEnemySprite()
    
    -- Erstelle Geschoss-Sprites
    Graphics.sprites.playerBullet = Graphics.createPlayerBulletSprite()
    Graphics.sprites.enemyBullet = Graphics.createEnemyBulletSprite()
    
    -- Erstelle Hintergrund-Elemente
    Graphics.stars = Graphics.createStarField()
    
    -- Initialisiere Partikel-Systeme
    Graphics.initParticleSystems()
end

--[[
    Erstellt ein Spieler-Sprite (Dreieck als Raumschiff)
    @return userdata - LÖVE2D Canvas mit dem Sprite
]]
function Graphics.createPlayerSprite()
    local size = 50
    local canvas = love.graphics.newCanvas(size, size)
    
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    
    -- Hauptschiff (hellblau)
    love.graphics.setColor(0.4, 0.8, 1, 1)
    love.graphics.polygon('fill', 
        size/2, 5,           -- Spitze oben
        size - 10, size - 5, -- Rechts unten
        size/2, size - 15,   -- Mitte unten
        10, size - 5         -- Links unten
    )
    
    -- Triebwerke (orange Glow)
    love.graphics.setColor(1, 0.5, 0, 0.8)
    love.graphics.polygon('fill',
        15, size - 5,        -- Links
        size/2 - 5, size - 15, -- Mitte links
        size/2, size - 2,    -- Mitte
        size/2 + 5, size - 15, -- Mitte rechts
        size - 15, size - 5  -- Rechts
    )
    
    -- Cockpit (dunkelblau)
    love.graphics.setColor(0.2, 0.4, 0.8, 1)
    love.graphics.circle('fill', size/2, size/3, 8)
    
    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1, 1) -- Farbe zurücksetzen
    
    return canvas
end

--[[
    Erstellt ein Gegner-Sprite (umgedrehtes Dreieck)
    @return userdata - LÖVE2D Canvas mit dem Sprite
]]
function Graphics.createEnemySprite()
    local size = 40
    local canvas = love.graphics.newCanvas(size, size)
    
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    
    -- Hauptschiff (rot)
    love.graphics.setColor(1, 0.3, 0.3, 1)
    love.graphics.polygon('fill',
        5, 5,                -- Links oben
        size - 5, 5,         -- Rechts oben
        size/2 + 5, size - 15, -- Mitte rechts unten
        size/2, size - 5,    -- Spitze unten
        size/2 - 5, size - 15  -- Mitte links unten
    )
    
    -- Triebwerke (dunkelrot)
    love.graphics.setColor(0.8, 0.1, 0.1, 1)
    love.graphics.polygon('fill',
        8, 5,                -- Links
        size/2 - 3, 15,      -- Mitte links
        size/2, 2,           -- Mitte
        size/2 + 3, 15,      -- Mitte rechts
        size - 8, 5          -- Rechts
    )
    
    -- Cockpit (sehr dunkelrot)
    love.graphics.setColor(0.5, 0.1, 0.1, 1)
    love.graphics.circle('fill', size/2, size - 25, 6)
    
    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1, 1) -- Farbe zurücksetzen
    
    return canvas
end

--[[
    Erstellt ein Spieler-Geschoss-Sprite
    @return userdata - LÖVE2D Canvas mit dem Sprite
]]
function Graphics.createPlayerBulletSprite()
    local width, height = 4, 10
    local canvas = love.graphics.newCanvas(width, height)
    
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    
    -- Hauptgeschoss (hellgrün)
    love.graphics.setColor(0.4, 1, 0.4, 1)
    love.graphics.rectangle('fill', 0, 0, width, height)
    
    -- Glow-Effekt
    love.graphics.setColor(0.8, 1, 0.8, 0.5)
    love.graphics.rectangle('fill', -1, -1, width + 2, height + 2)
    
    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1, 1)
    
    return canvas
end

--[[
    Erstellt ein Gegner-Geschoss-Sprite
    @return userdata - LÖVE2D Canvas mit dem Sprite
]]
function Graphics.createEnemyBulletSprite()
    local width, height = 4, 10
    local canvas = love.graphics.newCanvas(width, height)
    
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    
    -- Hauptgeschoss (rot)
    love.graphics.setColor(1, 0.3, 0.3, 1)
    love.graphics.rectangle('fill', 0, 0, width, height)
    
    -- Glow-Effekt
    love.graphics.setColor(1, 0.6, 0.6, 0.5)
    love.graphics.rectangle('fill', -1, -1, width + 2, height + 2)
    
    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1, 1)
    
    return canvas
end

--[[
    Erstellt ein Sternenfeld für den Hintergrund
    @return table - Array von Sternen mit Position und Helligkeit
]]
function Graphics.createStarField()
    local stars = {}
    local numStars = 150
    
    for i = 1, numStars do
        stars[i] = {
            x = math.random(0, love.graphics.getWidth()),
            y = math.random(0, love.graphics.getHeight()),
            brightness = math.random() * 0.8 + 0.2, -- 0.2 bis 1.0
            size = math.random() * 2 + 1, -- 1 bis 3 Pixel
            speed = math.random() * 50 + 25 -- 25 bis 75 Pixel pro Sekunde
        }
    end
    
    return stars
end

--[[
    Initialisiert Partikel-Systeme für Effekte
]]
function Graphics.initParticleSystems()
    -- Explosions-Partikel-System
    local explosionTexture = love.graphics.newCanvas(4, 4)
    love.graphics.setCanvas(explosionTexture)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle('fill', 2, 2, 2)
    love.graphics.setCanvas()
    
    Graphics.particleSystems.explosion = love.graphics.newParticleSystem(explosionTexture, 32)
    Graphics.particleSystems.explosion:setParticleLifetime(0.2, 0.6)
    Graphics.particleSystems.explosion:setEmissionRate(100)
    Graphics.particleSystems.explosion:setSizeVariation(1)
    Graphics.particleSystems.explosion:setLinearAcceleration(-100, -100, 100, 100)
    Graphics.particleSystems.explosion:setColors(1, 1, 0, 1, 1, 0.5, 0, 1, 1, 0, 0, 0)
    
    -- Triebwerk-Partikel-System
    Graphics.particleSystems.thruster = love.graphics.newParticleSystem(explosionTexture, 16)
    Graphics.particleSystems.thruster:setParticleLifetime(0.1, 0.3)
    Graphics.particleSystems.thruster:setEmissionRate(60)
    Graphics.particleSystems.thruster:setSizeVariation(0.5)
    Graphics.particleSystems.thruster:setLinearAcceleration(-20, 50, 20, 150)
    Graphics.particleSystems.thruster:setColors(1, 0.5, 0, 1, 1, 0.2, 0, 0.5, 0.5, 0.1, 0, 0)
end

--[[
    Aktualisiert animierte Grafik-Elemente
    @param dt number - Delta-Zeit seit dem letzten Update
]]
function Graphics.update(dt)
    -- Aktualisiere Sternenfeld
    for _, star in ipairs(Graphics.stars) do
        star.y = star.y + star.speed * dt
        if star.y > love.graphics.getHeight() then
            star.y = -5
            star.x = math.random(0, love.graphics.getWidth())
        end
    end
    
    -- Aktualisiere Partikel-Systeme
    for _, system in pairs(Graphics.particleSystems) do
        system:update(dt)
    end
end

--[[
    Zeichnet den animierten Hintergrund
]]
function Graphics.drawBackground()
    love.graphics.setColor(0.05, 0.05, 0.15, 1) -- Dunkelblaue Basis
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
    -- Zeichne Sterne
    for _, star in ipairs(Graphics.stars) do
        love.graphics.setColor(star.brightness, star.brightness, star.brightness, star.brightness)
        love.graphics.circle('fill', star.x, star.y, star.size)
    end
    
    love.graphics.setColor(1, 1, 1, 1) -- Farbe zurücksetzen
end

--[[
    Zeichnet ein Sprite an der angegebenen Position
    @param spriteType string - Typ des Sprites ('player', 'enemy', 'playerBullet', 'enemyBullet')
    @param x number - X-Position
    @param y number - Y-Position
    @param rotation number - Rotation in Radiant (optional)
    @param scale number - Skalierung (optional, Standard: 1)
]]
function Graphics.drawSprite(spriteType, x, y, rotation, scale)
    local sprite = Graphics.sprites[spriteType]
    if not sprite then return end
    
    rotation = rotation or 0
    scale = scale or 1
    
    local width = sprite:getWidth() * scale
    local height = sprite:getHeight() * scale
    
    love.graphics.draw(sprite, x + width/2, y + height/2, rotation, scale, scale, sprite:getWidth()/2, sprite:getHeight()/2)
end

--[[
    Erstellt eine Explosion an der angegebenen Position
    @param x number - X-Position der Explosion
    @param y number - Y-Position der Explosion
]]
function Graphics.createExplosion(x, y)
    Graphics.particleSystems.explosion:setPosition(x, y)
    Graphics.particleSystems.explosion:emit(25)
end

--[[
    Erstellt Triebwerk-Effekte
    @param x number - X-Position
    @param y number - Y-Position
]]
function Graphics.createThrusterEffect(x, y)
    Graphics.particleSystems.thruster:setPosition(x, y)
    Graphics.particleSystems.thruster:emit(5)
end

--[[
    Zeichnet alle aktiven Partikel-Systeme
]]
function Graphics.drawParticles()
    love.graphics.setBlendMode('add') -- Additives Blending für Glow-Effekte
    for _, system in pairs(Graphics.particleSystems) do
        love.graphics.draw(system)
    end
    love.graphics.setBlendMode('alpha') -- Zurück zu normalem Blending
end

return Graphics
