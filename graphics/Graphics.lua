local Graphics = {}

-- Grafiken-Manager für das Spiel
-- Verwaltet Sprites, Texturen und visuelle Effekte

Graphics.sprites = {}
Graphics.particleSystems = {}
Graphics.movingExplosions = {}

-- Particle system pools for performance optimization
Graphics.particlePools = {
    normal = {}, -- Pool for normal explosions
    moving = {}, -- Pool for moving explosions
    death = {}   -- Pool for death explosions
}

-- Pre-created textures for particle systems
Graphics.explosionTextures = {}

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
    
    -- Initialisiere Partikel-Pools
    Graphics.initParticlePools()
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
    Initialisiert die Partikel-Pools für bessere Performance
    Erstellt wiederverwendbare Partikel-Systeme und Texturen
]]
function Graphics.initParticlePools()
    -- Erstelle Texturen für verschiedene Explosionstypen
    
    -- Normale Explosion (4x4)
    Graphics.explosionTextures.normal = love.graphics.newCanvas(4, 4)
    love.graphics.setCanvas(Graphics.explosionTextures.normal)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle('fill', 2, 2, 2)
    love.graphics.setCanvas()
    
    -- Todes-Explosion (6x6)
    Graphics.explosionTextures.death = love.graphics.newCanvas(6, 6)
    love.graphics.setCanvas(Graphics.explosionTextures.death)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle('fill', 3, 3, 3)
    love.graphics.setCanvas()
    
    -- Erstelle Pools mit vorkonfigurierten Partikel-Systemen
    local poolSize = 10 -- Anzahl der Systeme pro Pool
    
    -- Pool für normale bewegte Explosionen
    for i = 1, poolSize do
        local system = love.graphics.newParticleSystem(Graphics.explosionTextures.normal, 32)
        system:setParticleLifetime(0.2, 0.6)
        system:setEmissionRate(100)
        system:setSizeVariation(1)
        system:setLinearAcceleration(-100, -100, 100, 100)
        system:setColors(1, 1, 0, 1, 1, 0.5, 0, 1, 1, 0, 0, 0)
        
        table.insert(Graphics.particlePools.moving, {
            system = system,
            inUse = false
        })
    end
    
    -- Pool für Todes-Explosionen
    for i = 1, poolSize do
        local system = love.graphics.newParticleSystem(Graphics.explosionTextures.death, 64)
        system:setParticleLifetime(0.5, 1.5)
        system:setEmissionRate(150)
        system:setSizeVariation(1.0)
        system:setLinearAcceleration(-150, -150, 150, 150)
        system:setColors(1, 1, 0, 1, 1, 0.5, 0, 1, 1, 0, 0, 0)
        
        table.insert(Graphics.particlePools.death, {
            system = system,
            inUse = false
        })
    end
    
    love.graphics.setColor(1, 1, 1, 1) -- Farbe zurücksetzen
end

--[[
    Holt ein wiederverwendbares Partikel-System aus dem Pool
    @param poolType string - Typ des Pools ('moving', 'death')
    @return table|nil - Partikel-System oder nil wenn Pool leer
]]
function Graphics.getPooledParticleSystem(poolType)
    local pool = Graphics.particlePools[poolType]
    if not pool then return nil end
    
    for i, entry in ipairs(pool) do
        if not entry.inUse then
            entry.inUse = true
            return entry.system
        end
    end
    
    return nil -- Pool ist voll
end

--[[
    Gibt ein Partikel-System an den Pool zurück
    @param system userdata - Das Partikel-System
    @param poolType string - Typ des Pools ('moving', 'death')
]]
function Graphics.returnToPool(system, poolType)
    local pool = Graphics.particlePools[poolType]
    if not pool then return end
    
    for i, entry in ipairs(pool) do
        if entry.system == system then
            entry.inUse = false
            system:stop() -- Stoppe das System
            return
        end
    end
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
    
    -- Aktualisiere bewegte Explosionen
    for i = #Graphics.movingExplosions, 1, -1 do
        local explosion = Graphics.movingExplosions[i]
        if explosion.target then
            explosion.system:setPosition(
                explosion.target.x + explosion.target.width/2,
                explosion.target.y + explosion.target.height/2
            )
        end
        
        explosion.system:update(dt)
        
        -- Entferne abgelaufene Explosionen
        if love.timer.getTime() - explosion.startTime > explosion.duration then
            -- Gib das Partikel-System an den Pool zurück
            if explosion.poolType then
                Graphics.returnToPool(explosion.system, explosion.poolType)
            end
            table.remove(Graphics.movingExplosions, i)
        end
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
    @param followTarget table - Objekt dem die Explosion folgen soll (optional)
    @param isDeathExplosion boolean - Ist es eine Todes-Explosion (größer und länger)
]]
function Graphics.createExplosion(x, y, followTarget, isDeathExplosion)
    if followTarget then
        -- Erstelle eine bewegte Explosion mit Pool-System
        local movingSystem = Graphics.getPooledParticleSystem('moving')
        if not movingSystem then
            -- Fallback: Verwende das statische System
            Graphics.particleSystems.explosion:setPosition(x, y)
            Graphics.particleSystems.explosion:emit(25)
            return
        end
        
        local explosion = {
            system = movingSystem,
            target = followTarget,
            startTime = love.timer.getTime(),
            duration = 1.5, -- Dauer der Explosion in Sekunden
            poolType = 'moving' -- Für Pool-Rückgabe
        }
        explosion.system:setPosition(x, y)
        explosion.system:emit(25)
        table.insert(Graphics.movingExplosions, explosion)
    else
        -- Statische Explosion
        if isDeathExplosion then
            -- Große Todes-Explosion mit Pool-System
            local deathSystem = Graphics.getPooledParticleSystem('death')
            if not deathSystem then
                -- Fallback: Verwende das statische System
                Graphics.particleSystems.explosion:setPosition(x, y)
                Graphics.particleSystems.explosion:emit(25)
                return
            end
            
            local explosion = {
                system = deathSystem,
                target = nil,
                startTime = love.timer.getTime(),
                duration = 1.5,
                poolType = 'death' -- Für Pool-Rückgabe
            }
            explosion.system:setPosition(x, y)
            explosion.system:emit(50)
            table.insert(Graphics.movingExplosions, explosion)
        else
            -- Normale kleine Explosion (verwendet weiterhin statisches System)
            Graphics.particleSystems.explosion:setPosition(x, y)
            Graphics.particleSystems.explosion:emit(25)
        end
    end
end

--[[
    Entfernt alle Explosionen, die einem bestimmten Ziel folgen
    @param target table - Das Ziel, dessen Explosionen entfernt werden sollen
]]
function Graphics.removeExplosionsForTarget(target)
    for i = #Graphics.movingExplosions, 1, -1 do
        local explosion = Graphics.movingExplosions[i]
        if explosion.target == target then
            -- Gib das Partikel-System an den Pool zurück
            if explosion.poolType then
                Graphics.returnToPool(explosion.system, explosion.poolType)
            end
            table.remove(Graphics.movingExplosions, i)
        end
    end
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
    
    -- Zeichne normale Partikel-Systeme
    for _, system in pairs(Graphics.particleSystems) do
        love.graphics.draw(system)
    end
    
    -- Zeichne bewegte Explosionen
    for _, explosion in pairs(Graphics.movingExplosions) do
        love.graphics.draw(explosion.system)
    end
    
    love.graphics.setBlendMode('alpha') -- Zurück zu normalem Blending
end

return Graphics
