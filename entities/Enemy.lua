local Enemy = {}
Enemy.__index = Enemy

local GameConstants = require 'constants.Game'

--[[
    Enemy-Klasse: Repräsentiert den Gegner im Spiel
    Verantwortlich für:
    - Bewegung des Gegners (horizontal und vertikal)
    - Schießen mit zufälliger Wahrscheinlichkeit
    - Kollisionserkennung
    - Gesundheit und Reset-Logik
]]

function Enemy.new()
    local self = setmetatable({}, Enemy)
    
    -- Initialisierung der Gegner-Eigenschaften
    self.x = 375  -- Start in der Mitte
    self.y = 0    -- Start oben
    self.width = 40
    self.height = 40
    self.verticalSpeed = math.random(100, 150)  -- Langsamere Geschwindigkeit als der Spieler
    self.horizontalSpeed = math.random(20, 80)  -- Geschwindigkeit zwischen 20 und 80
    self.direction = math.random() < 0.5 and -1 or 1  -- Zufällige Richtung (-1 für links, 1 für rechts)
    self.health = 3   -- Feind hat 3 Leben
    self.shootCooldown = GameConstants.ENEMY_SHOOT_COOLDOWN -- Cooldown für das Schießen
    self.shootChance = 0.03  -- Wahrscheinlichkeit zu schießen (je höher, desto wahrscheinlicher)
    
    return self
end

--[[
    Aktualisiert den Gegner-Status
    @param dt number - Delta-Zeit seit dem letzten Update
]]
function Enemy:update(dt)
    -- Vertikale Bewegung
    self.y = self.y + self.verticalSpeed * dt
    
    -- Horizontale Bewegung
    self.x = self.x + self.horizontalSpeed * self.direction * dt
    
    -- Richtungswechsel wenn der Feind den Bildschirmrand erreicht
    if self.x <= 0 then
        self.x = 0
        self.direction = 1
    elseif self.x + self.width >= love.graphics.getWidth() then
        self.x = love.graphics.getWidth() - self.width
        self.direction = -1
    end
    
    -- Zurücksetzen, wenn der Feind den Bildschirm verlässt
    if self.y > love.graphics.getHeight() then
        self:reset()
    end
    
    -- Cooldown für das Schießen aktualisieren
    if self.shootCooldown > 0 then
        self.shootCooldown = self.shootCooldown - dt
    end
end

--[[
    Zeichnet den Gegner auf dem Bildschirm
    Verwendet rote Farbe für den Gegner
]]
function Enemy:draw()
    love.graphics.setColor(1, 0, 0)  -- Rot
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1)  -- Zurück zu Weiß
end

--[[
    Setzt den Gegner zurück
    Wird aufgerufen, wenn der Gegner den Bildschirm verlässt oder zerstört wird
    Setzt Position, Gesundheit und Geschwindigkeiten neu
]]
function Enemy:reset()
    self.y = 0
    self.x = math.random(0, love.graphics.getWidth() - self.width)
    self.health = 3
    self.shootCooldown = GameConstants.ENEMY_SHOOT_COOLDOWN
    self.verticalSpeed = math.random(100, 150)  -- Langsamere Geschwindigkeit als der Spieler
    self.horizontalSpeed = math.random(20, 80)  -- Auch beim Reset zufällig
end

--[[
    Behandelt Schaden am Gegner
    @return boolean - true wenn der Gegner zerstört wurde, false wenn noch am Leben
]]
function Enemy:takeDamage()
    self.health = self.health - 1
    if self.health <= 0 then
        self:reset()
        return true
    end
    return false
end

--[[
    Erzeugt ein neues Projektil mit zufälliger Wahrscheinlichkeit
    @return table|nil - Projektil-Objekt oder nil wenn nicht geschossen wird
]]
function Enemy:shoot()
    if self.shootCooldown <= 0 and math.random() < self.shootChance then
        self.shootCooldown = GameConstants.ENEMY_SHOOT_COOLDOWN
        return {
            x = self.x + self.width / 2 - 2,  -- Zentriert unter dem Feind
            y = self.y + self.height,
            width = 4,
            height = 10,
            speed = 200  -- Langsamere Geschwindigkeit als Spielergeschosse
        }
    end
    return nil
end

return Enemy