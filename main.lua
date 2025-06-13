-- Importiere die Klassen
local Player = require('entities.Player')
local Enemy = require('entities.Enemy')
local UI = require('entities.UI')
local Highscore = require('highscore')
local UIConstants = require('constants.UI')

-- Cache für den Highscore
local currentHighscore = 0

-- Diese Funktion prüft, ob zwei Rechtecke sich überlappen
function checkCollision(rect1, rect2)
    return rect1.x < rect2.x + rect2.width and
           rect1.x + rect1.width > rect2.x and
           rect1.y < rect2.y + rect2.height and
           rect1.y + rect1.height > rect2.y
end

-- Diese Funktion wird einmal beim Start des Spiels aufgerufen
function love.load()
    -- Spielzustand
    gameState = {
        currentState = "start",  -- "start", "playing", "paused", "gameOver", "restart"
        previousBestScore = 0
    }
    
    -- Spielobjekte erstellen
    player = Player.new()
    enemy = Enemy.new()
    ui = UI.new()
    
    -- Tabelle für alle Geschosse
    bullets = {}
    
    -- Tabelle für alle Gegner-Geschosse
    enemyBullets = {}
    
    -- Punktestand
    score = 0
    
    -- Highscores laden
    Highscore.load()
    
    -- Initialisiere den Highscore-Cache
    currentHighscore = Highscore.getBestScore()
end

-- Diese Funktion wird in jedem Frame aufgerufen
-- dt ist die Zeit seit dem letzten Frame in Sekunden
function love.update(dt)
    if gameState.currentState == "start" or gameState.currentState == "paused" or gameState.currentState == "gameOver" then
        return
    end
    
--[[     if gameState.currentState == "gameOver" then
        if love.keyboard.isDown('r') then
            love.load()  -- Spiel neu starten
        end
        return
    end ]]
    
    -- Spieler aktualisieren
    player:update(dt)
    
    -- Schießen mit Leertaste
    if love.keyboard.isDown('space') then
        local bullet = player:shoot()
        if bullet then
            table.insert(bullets, bullet)
        end
    end
    
    -- Geschosse aktualisieren
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        -- Geschoss nach oben bewegen
        bullet.y = bullet.y - bullet.speed * dt
        
        -- Kollisionserkennung mit Feind
        if checkCollision(bullet, enemy) then
            -- Geschoss entfernen
            table.remove(bullets, i)
            if enemy:takeDamage() then
                score = score + 100
            end
        -- Geschoss entfernen, wenn es den Bildschirm verlässt
        elseif bullet.y + bullet.height < 0 then
            table.remove(bullets, i)
        end
    end
    
    -- Feind aktualisieren
    enemy:update(dt)
    
    -- Feind kann schießen
    local enemyBullet = enemy:shoot()
    if enemyBullet then
        table.insert(enemyBullets, enemyBullet)
    end
    
    -- Gegner-Geschosse aktualisieren
    for i = #enemyBullets, 1, -1 do
        local bullet = enemyBullets[i]
        -- Geschoss nach unten bewegen
        bullet.y = bullet.y + bullet.speed * dt
        
        -- Kollisionserkennung mit Spieler
        if checkCollision(bullet, player) then
            -- Geschoss entfernen
            table.remove(enemyBullets, i)
            if player:takeDamage() and player.health <= 0 then
                gameState.previousBestScore = Highscore.getBestScore() -- Merke alten Bestwert
                gameState.currentState = "gameOver"
                -- Speichere den Score, wenn das Spiel vorbei ist
                Highscore.addScore(score)
                -- Aktualisiere den Highscore-Cache
                currentHighscore = Highscore.getBestScore()
            end
        -- Geschoss entfernen, wenn es den Bildschirm verlässt
        elseif bullet.y > love.graphics.getHeight() then
            table.remove(enemyBullets, i)
        end
    end
    
    -- Kollisionserkennung zwischen Spieler und Feind
    if checkCollision(player, enemy) then
        if player:takeDamage() then
            enemy:reset()
            if player.health <= 0 then
                gameState.previousBestScore = Highscore.getBestScore() -- Merke alten Bestwert
                gameState.currentState = "gameOver"
                -- Speichere den Score, wenn das Spiel vorbei ist
                Highscore.addScore(score)
                -- Aktualisiere den Highscore-Cache
                currentHighscore = Highscore.getBestScore()
            end
        end
    end
    
    -- Pause mit P-Taste
    if love.keyboard.isDown('p') then
        gameState.currentState = "paused"
    end
end

-- Diese Funktion wird in jedem Frame aufgerufen
-- Hier zeichnen wir alles auf den Bildschirm
function love.draw()
    if gameState.currentState == "start" then
        ui:drawStartScreen()
        return
    end
    
    if gameState.currentState == "paused" then
        ui:drawPauseScreen()
        return
    end
    
    if gameState.currentState == "gameOver" then
        ui:drawGameOverScreen()
        return
    end
    
    -- Spieler zeichnen
    player:draw()
    
    -- Spieler-Geschosse zeichnen
    for _, bullet in ipairs(bullets) do
        love.graphics.setColor(0, 1, 0)  -- Grün für Spielergeschosse
        love.graphics.rectangle('fill', bullet.x, bullet.y, bullet.width, bullet.height)
    end
    
    -- Gegner-Geschosse zeichnen
    for _, bullet in ipairs(enemyBullets) do
        love.graphics.setColor(1, 0.5, 0)  -- Orange/Rot für Gegnergeschosse
        love.graphics.rectangle('fill', bullet.x, bullet.y, bullet.width, bullet.height)
    end
    
    -- Feind zeichnen
    enemy:draw()
    
    -- Setze die Farbe zurück auf Weiß für den Text
    love.graphics.setColor(1, 1, 1)
    
    -- Setze die Schriftgröße für Debug-Texte
    love.graphics.setFont(ui.fonts.subtext)
    
    -- Zeichne die aktuelle Position als Text (für Debugging)
    love.graphics.print('Position: ' .. math.floor(player.x), UIConstants.PADDING, UIConstants.START_Y)
    love.graphics.print('Spieler-Geschosse: ' .. #bullets, UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT)
    love.graphics.print('Gegner-Geschosse: ' .. #enemyBullets, UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 2)
    love.graphics.print('Feind Position X: ' .. math.floor(enemy.x), UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 3)
    love.graphics.print('Feind Position Y: ' .. math.floor(enemy.y), UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 4)
    love.graphics.print('Feind Leben: ' .. enemy.health, UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 5)
    love.graphics.print('Feind Cooldown: ' .. string.format("%.1f", enemy.shootCooldown), UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 6)
    love.graphics.print('Punkte: ' .. score, UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 7)
    love.graphics.print('Spieler*in Leben: ' .. player.health, UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 8)
    
    -- Zeige den aktuellen Highscore an
    love.graphics.print('Bisheriger Highscore: ' .. currentHighscore, UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 9)
    
    -- Zeige Unverwundbarkeitszeit an
    if player.invincible then
        love.graphics.print('Unverwundbar: ' .. string.format("%.1f", player.invincibleTime), UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 10)
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then  -- 1 ist der linke Mausbutton
        local newState = ui:handleClick(x, y, gameState)
        if newState == "restart" then
            love.load()
        else
            gameState.currentState = newState
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

-- TODO:
-- - Begrüßungsbildschirm mit Start-Button -> done
-- - Pause-Funktion mit Bildschirm -> done
-- - Game-Over-Bildschirm mit Start-Button -> done
-- - Highscore implementieren -> done
-- - Highscore im Game Over Bildschirm anzeigen -> done
-- - Highscore auf der Spielseite anzeigen -> done
-- - Highscore auf der Startseite anzeigen -> done
-- - Spiel beenden
-- - Spiel speichern
-- - Spiel laden
-- - Spielstand bzw. Highscore löschen
-- - Feinde schießen lassen -> done
-- - Feinde bewegen sich nicht nur nach unten, sondern auch nach links und rechts
-- - unterschiedliche Feinde mit unterschiedlicher Geschwindigkeit und Leben
-- - unterschiedliche Geschosse mit unterschiedlicher Geschwindigkeit und Schaden
-- - unterschiedliche Level
-- - Musik und Soundeffekte
-- - Grafiken
-- - Englische Übersetzung
-- - Sprachauswahl
-- - Spieler*in bewegt sich auch nach oben und unten
-- - Sterne können gesammelt werden
-- - Sterne bewirken verschiedene Bonus-Effekte für die Spieler*in
-- - Code-Struktur verbessern
-- - Dokumentation erstellen
-- - Unit-Tests erstellen? (in Lua nicht üblich?)
-- - Auf GitHub hochladen -> done
-- - Veröffentlichen auf itch.io prüfen
-- - Release-Notes löschen
-- - Mit Branches arbeiten -> done
-- - README.md anpassen