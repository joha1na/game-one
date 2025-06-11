-- Importiere die Klassen
local Player = require('entities.Player')
local Enemy = require('entities.Enemy')
local UI = require('entities.UI')
local Highscore = require('highscore')

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
    
    -- Punktestand
    score = 0
    
    -- Highscores laden
    Highscore.load()
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
    
    -- Kollisionserkennung zwischen Spieler und Feind
    if checkCollision(player, enemy) then
        if player:takeDamage() then
            enemy:reset()
            if player.health <= 0 then
                gameState.previousBestScore = Highscore.getBestScore() -- Merke alten Bestwert
                gameState.currentState = "gameOver"
                -- Speichere den Score, wenn das Spiel vorbei ist
                Highscore.addScore(score)
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
    
    -- Geschosse zeichnen
    for _, bullet in ipairs(bullets) do
        love.graphics.rectangle('fill', bullet.x, bullet.y, bullet.width, bullet.height)
    end
    
    -- Feind zeichnen
    enemy:draw()
    
    -- Setze die Farbe zurück auf Weiß für den Text
    love.graphics.setColor(1, 1, 1)
    
    -- Zeichne die aktuelle Position als Text (für Debugging)
    love.graphics.print('Position: ' .. math.floor(player.x), 10, 10)
    love.graphics.print('Geschosse: ' .. #bullets, 10, 30)
    love.graphics.print('Feind Position X: ' .. math.floor(enemy.x), 10, 50)
    love.graphics.print('Feind Position Y: ' .. math.floor(enemy.y), 10, 70)
    love.graphics.print('Feind Leben: ' .. enemy.health, 10, 90)
    love.graphics.print('Punkte: ' .. score, 10, 110)
    love.graphics.print('Spieler*in Leben: ' .. player.health, 10, 130)
    
    -- Zeige Unverwundbarkeitszeit an
    if player.invincible then
        love.graphics.print('Unverwundbar: ' .. string.format("%.1f", player.invincibleTime), 10, 150)
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
-- - Highscore auf der Startseite anzeigen
-- - Highscore auf der Spielseite anzeigen
-- - Spiel beenden
-- - Spiel speichern
-- - Spiel laden
-- - Spielstand bzw. Highscore löschen
-- - Feinde schießen lassen
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
-- - Auf GitHub hochladen
-- - Veröffentlichen auf itch.io prüfen