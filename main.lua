--[[
    Game One - Ein einfaches 2D-Schießspiel
    
    Spielmechanik:
    - Spieler steuert ein Raumschiff am unteren Bildschirmrand
    - Gegner erscheinen von oben und bewegen sich nach unten
    - Spieler und Gegner können schießen
    - Kollisionen führen zu Schaden
    - Highscore-System speichert die besten Ergebnisse
]]

-- Importiere benötigte Module
local Player = require 'entities.Player'
local Enemy = require 'entities.Enemy'
local UI = require 'entities.UI'
local Highscore = require 'highscore'
local UIConstants = require('constants.UI')
local Graphics = require('graphics.Graphics') -- Neues Grafik-System
local UIEffects = require('graphics.UIEffects') -- UI-Effekte

--[[
    Prüft Kollision zwischen zwei Rechtecken
    @param a table - Erstes Rechteck {x, y, width, height}
    @param b table - Zweites Rechteck {x, y, width, height}
    @return boolean - true wenn Kollision, false wenn nicht
]]
function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.width > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end

-- Lokale Variablen für den Spielzustand
local game = {
    state = {
        currentState = "start",  -- "start", "playing", "paused", "gameOver", "restart"
        previousBestScore = 0
    },
    player = nil,
    enemy = nil,
    ui = nil,
    bullets = {},
    enemyBullets = {},
    score = 0,
    currentHighscore = 0
}

--[[
    Initialisiert das Spiel
    Erstellt Spielobjekte und lädt Highscores
    Wird einmal beim Start des Spiels aufgerufen
]]
function love.load()
    -- Spielzustand zurücksetzen
    game.state.currentState = "start"
    game.score = 0
    
    -- Grafik-System initialisieren
    Graphics.init()
    UIEffects.init()
    -- Audio.init()
    
    -- Spielobjekte erstellen
    game.player = Player.new()
    game.enemy = Enemy.new()
    game.ui = UI.new()
    
    -- Highscores laden
    Highscore.load()
    
    -- Initialisiere den Highscore-Cache
    game.currentHighscore = Highscore.getBestScore()
end

--[[
    Aktualisiert den Spielzustand
    Wird in jedem Frame aufgerufen
    dt ist die Zeit seit dem letzten Frame in Sekunden
    @param dt number - Delta-Zeit seit dem letzten Update
]]
function love.update(dt)
    -- Aktualisiere Grafik-System
    Graphics.update(dt)
    UIEffects.update(dt)
    
    if game.state.currentState == "playing" then
        -- Aktualisiere Spieler
        game.player:update(dt)
        
        -- Aktualisiere Gegner
        game.enemy:update(dt)
        
        -- Aktualisiere Spielergeschosse
        for i = #game.bullets, 1, -1 do
            local bullet = game.bullets[i]
            bullet.y = bullet.y - bullet.speed * dt
            
            -- Entferne Geschosse außerhalb des Bildschirms
            if bullet.y < 0 then
                table.remove(game.bullets, i)
            end
        end
        
        -- Aktualisiere Gegnergeschosse
        for i = #game.enemyBullets, 1, -1 do
            local bullet = game.enemyBullets[i]
            bullet.y = bullet.y + bullet.speed * dt
            
            -- Entferne Geschosse außerhalb des Bildschirms
            if bullet.y > love.graphics.getHeight() then
                table.remove(game.enemyBullets, i)
            end
        end
        
        -- Prüfe Kollisionen zwischen Spielergeschossen und Gegner
        for i = #game.bullets, 1, -1 do
            local bullet = game.bullets[i]
            if checkCollision(bullet, game.enemy) then
                table.remove(game.bullets, i)
                if game.enemy:takeDamage() then
                    game.score = game.score + 100
                    -- Explosion erstellen
                    Graphics.createExplosion(game.enemy.x + game.enemy.width/2, game.enemy.y + game.enemy.height/2)
                    -- Score-Animation hinzufügen
                    UIEffects.addAnimation("scorePopup", game.enemy.x + game.enemy.width/2, game.enemy.y, 1)
                    -- Kurzer Screen-Shake
                    UIEffects.startScreenShake(5, 0.1)
                    -- Explosions-Sound abspielen
                    -- Audio.playExplosion()
                else
                    -- Treffer-Sound abspielen
                    -- Audio.playHit()
                end
            end
        end
        
        -- Prüfe Kollisionen zwischen Gegnergeschossen und Spieler
        for i = #game.enemyBullets, 1, -1 do
            local bullet = game.enemyBullets[i]
            if checkCollision(bullet, game.player) then
                table.remove(game.enemyBullets, i)
                -- Explosion bei Geschoss-Treffer (folgt dem Spieler)
                Graphics.createExplosion(game.player.x + game.player.width/2, game.player.y + game.player.height/2, game.player)
                if game.player:takeDamage() then
                    if game.player.health <= 0 then
                        game.state.currentState = "gameOver"
                        game.state.previousBestScore = game.currentHighscore
                        if game.score > game.currentHighscore then
                            Highscore.addScore(game.score)
                            game.currentHighscore = game.score
                        end
                    end
                end
            end
        end
        
        -- Prüfe Kollision zwischen Spieler und Gegner
        if checkCollision(game.player, game.enemy) then
            if game.player:takeDamage() then
                if game.player.health <= 0 then
                    game.state.currentState = "gameOver"
                    game.state.previousBestScore = game.currentHighscore
                    if game.score > game.currentHighscore then
                        Highscore.addScore(game.score)
                        game.currentHighscore = game.score
                    end
                    -- Starker Screen-Shake bei Game Over
                    UIEffects.startScreenShake(15, 0.5)
                else
                    -- Leichter Screen-Shake bei Schaden
                    UIEffects.startScreenShake(8, 0.2)
                end
            end
            -- Explosion bei Kollision (folgt dem Spieler)
            Graphics.createExplosion(game.player.x + game.player.width/2, game.player.y + game.player.height/2, game.player)
            -- Kollisions-Screen-Shake
            UIEffects.startScreenShake(10, 0.3)
            game.enemy:reset()
        end
        
        -- Gegner schießt
        local enemyBullet = game.enemy:shoot()
        if enemyBullet then
            table.insert(game.enemyBullets, enemyBullet)
        end
    end
end

--[[
    Zeichnet den aktuellen Spielzustand
    Wird in jedem Frame aufgerufen
]]
function love.draw()
    -- Screen-Shake anwenden
    UIEffects.applyScreenShake()
    
    if game.state.currentState == "start" then
        -- Zeichne Hintergrund auch im Startscreen
        Graphics.drawBackground()
        game.ui:drawStartScreen()
    elseif game.state.currentState == "playing" then
        -- Zeichne Spieler
        -- game.player:draw()
        -- Zeichne animierten Hintergrund
        Graphics.drawBackground()
        
        -- Zeichne Triebwerk-Effekte für den Spieler
        Graphics.createThrusterEffect(game.player.x + game.player.width/2, game.player.y + game.player.height)
        
        -- Zeichne Gegner
        -- game.enemy:draw()
        
        -- Zeichne Spielergeschosse
        -- love.graphics.setColor(0, 1, 0)  -- Grün
        -- Zeichne Spieler mit neuem Sprite (mit Blitzeffekt bei Unverwundbarkeit)
        if not game.player.invincible or math.floor(game.player.flashTime * 10) % 2 == 0 then
            Graphics.drawSprite('player', game.player.x, game.player.y)
        end
        
        -- Zeichne Gegner mit neuem Sprite
        Graphics.drawSprite('enemy', game.enemy.x, game.enemy.y)
        
        -- Zeichne Spielergeschosse mit neuen Sprites
        for _, bullet in ipairs(game.bullets) do
            -- love.graphics.rectangle('fill', bullet.x, bullet.y, bullet.width, bullet.height)
            Graphics.drawSprite('playerBullet', bullet.x, bullet.y)
        end
        
        -- Zeichne Gegnergeschosse
        -- love.graphics.setColor(1, 0, 0)  -- Rot
        -- Zeichne Gegnergeschosse mit neuen Sprites
        for _, bullet in ipairs(game.enemyBullets) do
            -- love.graphics.rectangle('fill', bullet.x, bullet.y, bullet.width, bullet.height)
            Graphics.drawSprite('enemyBullet', bullet.x, bullet.y)
        end
        
        -- Zeichne Partikel-Effekte (Explosionen, etc.)
        Graphics.drawParticles()
        
        -- Zeichne UI-Animationen (Score-Popups, etc.)
        UIEffects.drawAnimations()
        
        -- Setze die Farbe für den Text
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(game.ui.fonts.text)

        -- Zeichne Score
        love.graphics.print("Score: " .. game.score, UIConstants.PADDING, UIConstants.START_Y)
        
        -- Zeichne Leben
        love.graphics.print("Leben: " .. game.player.health, UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT)

        -- Setze die Schriftgröße für Debug-Texte
        love.graphics.setFont(game.ui.fonts.subtext)

        -- Zeichne die aktuelle Position als Text (für Debugging)
        love.graphics.print('Position: ' .. math.floor(game.player.x), UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 2)
        love.graphics.print('Spieler-Geschosse: ' .. #game.bullets, UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 3)
        love.graphics.print('Gegner-Geschosse: ' .. #game.enemyBullets, UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 4)
        love.graphics.print('Feind Position X: ' .. math.floor(game.enemy.x), UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 5)
        love.graphics.print('Feind Position Y: ' .. math.floor(game.enemy.y), UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 6)
        love.graphics.print('Feind Leben: ' .. game.enemy.health, UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 7)
        love.graphics.print('Feind Cooldown: ' .. string.format("%.1f", game.enemy.shootCooldown), UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 8)
        love.graphics.print('Punkte: ' .. game.score, UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 9)
        love.graphics.print('Spieler*in Leben: ' .. game.player.health, UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 10)
        
        -- Zeige den aktuellen Highscore an
        love.graphics.print('Bisheriger Highscore: ' .. game.currentHighscore, UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 11)
        
        -- Zeige Unverwundbarkeitszeit an
        if game.player.invincible then
            love.graphics.print('Unverwundbar: ' .. string.format("%.1f", game.player.invincibleTime), UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 12)
        end
    elseif game.state.currentState == "paused" then
        -- Zeichne Hintergrund auch im Pause-Screen
        Graphics.drawBackground()
        -- Zeichne das Spiel gedimmt
        love.graphics.setColor(0.5, 0.5, 0.5, 0.7)
        Graphics.drawSprite('player', game.player.x, game.player.y)
        Graphics.drawSprite('enemy', game.enemy.x, game.enemy.y)
        for _, bullet in ipairs(game.bullets) do
            Graphics.drawSprite('playerBullet', bullet.x, bullet.y)
        end
        for _, bullet in ipairs(game.enemyBullets) do
            Graphics.drawSprite('enemyBullet', bullet.x, bullet.y)
        end
        love.graphics.setColor(1, 1, 1, 1) -- Farbe zurücksetzen
        game.ui:drawPauseScreen()
    elseif game.state.currentState == "gameOver" then
        -- Zeichne Hintergrund auch im Game Over Screen
        Graphics.drawBackground()
        game.ui:drawGameOverScreen(game)
    end
    
    -- Screen-Shake beenden
    UIEffects.endScreenShake()
    
    -- Fade-Effekt zeichnen
    UIEffects.drawFadeEffect()
    

end

--[[
    Behandelt Tastatureingaben
    @param key string - Gedrückte Taste
]]
function love.keypressed(key)
    if key == "escape" then
        if game.state.currentState == "playing" then
            game.state.currentState = "paused"
        elseif game.state.currentState == "paused" then
            game.state.currentState = "playing"
        elseif game.state.currentState == "start" or game.state.currentState == "gameOver" then
            love.event.quit()
        end
    elseif key == "p" then
        if game.state.currentState == "playing" then
            game.state.currentState = "paused"
        elseif game.state.currentState == "paused" then
            game.state.currentState = "playing"
        end
    elseif key == "space" and game.state.currentState == "playing" then
        local bullet = game.player:shoot()
        if bullet then
            table.insert(game.bullets, bullet)
        end
    end
end

--[[
    Behandelt Mausklicks
    @param x number - X-Koordinate des Klicks
    @param y number - Y-Koordinate des Klicks
    @param button number - Maustaste
    @param istouch boolean - Ist es ein Touch-Event
]]
function love.mousepressed(x, y, button, istouch)
    if button == 1 then  -- Linke Maustaste
        local newState = game.ui:handleClick(x, y, game.state)
        if newState == "restart" then
            love.load()  -- Spiel neu starten
        else
            game.state.currentState = newState
        end
    end
end