local Player = {}
Player.__index = Player

local GameConstants = require 'constants.Game'

--[[
    Player-Klasse: Repräsentiert den Spieler im Spiel
    Verantwortlich für:
    - Bewegung des Spielers
    - Schießen
    - Kollisionserkennung
    - Gesundheit und Unverwundbarkeit
]]

function Player.new()
    local self = setmetatable({}, Player)
    
    -- Initialisierung der Spieler-Eigenschaften
    self.x = 375  -- (800 - 50) / 2 = 375, um das 50 Pixel breite Rechteck zu zentrieren
    self.y = 500  -- y-Position etwas über dem unteren Rand
    self.width = 50
    self.height = 50
    self.speed = 200  -- Geschwindigkeit in Pixeln pro Sekunde
    self.health = 3  -- Spieler*in hat 3 Leben
    self.invincible = false  -- Unverwundbarkeitsstatus
    self.invincibleTime = 0  -- Zeit der Unverwundbarkeit
    self.flashTime = 0  -- Zeit für den Blitzeffekt
    self.shootCooldown = GameConstants.PLAYER_SHOOT_COOLDOWN -- Cooldown für das Schießen
    
    return self
end

--[[
    Aktualisiert den Spieler-Status
    @param dt number - Delta-Zeit seit dem letzten Update
]]
function Player:update(dt)
    -- Bewegung nach links mit der linken Pfeiltaste
    if love.keyboard.isDown('left') then
        self.x = self.x - self.speed * dt
    end
    
    -- Bewegung nach rechts mit der rechten Pfeiltaste
    if love.keyboard.isDown('right') then
        self.x = self.x + self.speed * dt
    end
    
    -- Verhindern, dass der Spieler den Bildschirm verlässt
    self.x = math.max(0, math.min(love.graphics.getWidth() - self.width, self.x))
    
    -- Unverwundbarkeitszeit aktualisieren
    if self.invincible then
        self.invincibleTime = self.invincibleTime - dt
        self.flashTime = self.flashTime - dt
        
        if self.invincibleTime <= 0 then
            self.invincible = false
        end
        
        -- Blitzeffekt zurücksetzen
        if self.flashTime <= 0 then
            self.flashTime = 0.1  -- FLASH_DURATION
        end
    end
    
    -- Cooldown aktualisieren
    if self.shootCooldown > 0 then
        self.shootCooldown = self.shootCooldown - dt
    end
end

--[[
    Zeichnet den Spieler auf dem Bildschirm
    Implementiert einen Blitzeffekt während der Unverwundbarkeitsphase
    Hinweis: Das Zeichnen wird jetzt vom Graphics-System übernommen
]]
function Player:draw()
--[[     if not self.invincible or math.floor(self.flashTime * 10) % 2 == 0 then
        love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    end ]]
    -- Diese Funktion wird für Kompatibilität beibehalten, 
    -- aber das Zeichnen erfolgt jetzt über das Graphics-System
    -- Der Blitzeffekt kann über Transparenz im Graphics-System implementiert werden
end

--[[
    Erzeugt ein neues Projektil, wenn der Cooldown abgelaufen ist
    @return table|nil - Projektil-Objekt oder nil wenn Cooldown noch aktiv
]]
function Player:shoot()
    if self.shootCooldown <= 0 then
        self.shootCooldown = GameConstants.PLAYER_SHOOT_COOLDOWN
        return {
            x = self.x + self.width / 2 - 2,  -- Zentriert über dem Spieler
            y = self.y,
            width = 4,
            height = 10,
            speed = 400  -- BULLET_SPEED
        }
    end
    return nil
end

--[[
    Behandelt Schaden am Spieler
    Aktiviert Unverwundbarkeit für eine kurze Zeit
    @return boolean - true wenn Schaden genommen wurde, false wenn unverwundbar
]]
function Player:takeDamage()
    if not self.invincible then
        self.health = self.health - 1
        self.invincible = true
        self.invincibleTime = 2  -- INVINCIBLE_DURATION
        self.flashTime = 0.1     -- FLASH_DURATION
        return true
    end
    return false
end

return Player 