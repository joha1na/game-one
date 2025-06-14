-- Importiere die Klassen
local Player = require('entities.Player')
local Enemy = require('entities.Enemy')
local UI = require('entities.UI')
local Highscore = require('highscore')
local UIConstants = require('constants.UI')

-- Diese Funktion prüft, ob zwei Rechtecke sich überlappen
function checkCollision(rect1, rect2)
    return rect1.x < rect2.x + rect2.width and
           rect1.x + rect1.width > rect2.x and
           rect1.y < rect2.y + rect2.height and
           rect1.y + rect1.height > rect2.y
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

-- Diese Funktion wird einmal beim Start des Spiels aufgerufen
function love.load()
    -- Spielzustand zurücksetzen
    game.state.currentState = "start"
    game.score = 0
    
    -- Spielobjekte erstellen
    game.player = Player.new()
    game.enemy = Enemy.new()
    game.ui = UI.new()
    
    -- Highscores laden
    Highscore.load()
    
    -- Initialisiere den Highscore-Cache
    game.currentHighscore = Highscore.getBestScore()
end

-- Diese Funktion wird in jedem Frame aufgerufen
-- dt ist die Zeit seit dem letzten Frame in Sekunden
function love.update(dt)
    if game.state.currentState == "start" or game.state.currentState == "paused" or game.state.currentState == "gameOver" then
        return
    end
    
    -- Spieler aktualisieren
    game.player:update(dt)
    
    -- Schießen mit Leertaste
    if love.keyboard.isDown('space') then
        local bullet = game.player:shoot()
        if bullet then
            table.insert(game.bullets, bullet)
        end
    end
    
    -- Geschosse aktualisieren
    for i = #game.bullets, 1, -1 do
        local bullet = game.bullets[i]
        -- Geschoss nach oben bewegen
        bullet.y = bullet.y - bullet.speed * dt
        
        -- Kollisionserkennung mit Feind
        if checkCollision(bullet, game.enemy) then
            -- Geschoss entfernen
            table.remove(game.bullets, i)
            if game.enemy:takeDamage() then
                game.score = game.score + 100
            end
        -- Geschoss entfernen, wenn es den Bildschirm verlässt
        elseif bullet.y + bullet.height < 0 then
            table.remove(game.bullets, i)
        end
    end
    
    -- Feind aktualisieren
    game.enemy:update(dt)
    
    -- Feind kann schießen
    local enemyBullet = game.enemy:shoot()
    if enemyBullet then
        table.insert(game.enemyBullets, enemyBullet)
    end
    
    -- Gegner-Geschosse aktualisieren
    for i = #game.enemyBullets, 1, -1 do
        local bullet = game.enemyBullets[i]
        -- Geschoss nach unten bewegen
        bullet.y = bullet.y + bullet.speed * dt
        
        -- Kollisionserkennung mit Spieler
        if checkCollision(bullet, game.player) then
            -- Geschoss entfernen
            table.remove(game.enemyBullets, i)
            if game.player:takeDamage() and game.player.health <= 0 then
                game.state.previousBestScore = Highscore.getBestScore() -- Merke alten Bestwert
                game.state.currentState = "gameOver"
                -- Speichere den Score, wenn das Spiel vorbei ist
                Highscore.addScore(game.score)
                -- Aktualisiere den Highscore-Cache
                game.currentHighscore = Highscore.getBestScore()
            end
        -- Geschoss entfernen, wenn es den Bildschirm verlässt
        elseif bullet.y > love.graphics.getHeight() then
            table.remove(game.enemyBullets, i)
        end
    end
    
    -- Kollisionserkennung zwischen Spieler und Feind
    if checkCollision(game.player, game.enemy) then
        if game.player:takeDamage() then
            game.enemy:reset()
            if game.player.health <= 0 then
                game.state.previousBestScore = Highscore.getBestScore() -- Merke alten Bestwert
                game.state.currentState = "gameOver"
                -- Speichere den Score, wenn das Spiel vorbei ist
                Highscore.addScore(game.score)
                -- Aktualisiere den Highscore-Cache
                game.currentHighscore = Highscore.getBestScore()
            end
        end
    end
    
    -- Pause mit P-Taste
    if love.keyboard.isDown('p') then
        game.state.currentState = "paused"
    end
end

-- Diese Funktion wird in jedem Frame aufgerufen
-- Hier zeichnen wir alles auf den Bildschirm
function love.draw()
    if game.state.currentState == "start" then
        game.ui:drawStartScreen()
        return
    end
    
    if game.state.currentState == "paused" then
        game.ui:drawPauseScreen()
        return
    end
    
    if game.state.currentState == "gameOver" then
        game.ui:drawGameOverScreen(game)
        return
    end
    
    -- Spieler zeichnen
    game.player:draw()
    
    -- Spieler-Geschosse zeichnen
    for _, bullet in ipairs(game.bullets) do
        love.graphics.setColor(0, 1, 0)  -- Grün für Spielergeschosse
        love.graphics.rectangle('fill', bullet.x, bullet.y, bullet.width, bullet.height)
    end
    
    -- Gegner-Geschosse zeichnen
    for _, bullet in ipairs(game.enemyBullets) do
        love.graphics.setColor(1, 0.5, 0)  -- Orange/Rot für Gegnergeschosse
        love.graphics.rectangle('fill', bullet.x, bullet.y, bullet.width, bullet.height)
    end
    
    -- Feind zeichnen
    game.enemy:draw()
    
    -- Setze die Farbe zurück auf Weiß für den Text
    love.graphics.setColor(1, 1, 1)
    
    -- Setze die Schriftgröße für Debug-Texte
    love.graphics.setFont(game.ui.fonts.subtext)
    
    -- Zeichne die aktuelle Position als Text (für Debugging)
    love.graphics.print('Position: ' .. math.floor(game.player.x), UIConstants.PADDING, UIConstants.START_Y)
    love.graphics.print('Spieler-Geschosse: ' .. #game.bullets, UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT)
    love.graphics.print('Gegner-Geschosse: ' .. #game.enemyBullets, UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 2)
    love.graphics.print('Feind Position X: ' .. math.floor(game.enemy.x), UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 3)
    love.graphics.print('Feind Position Y: ' .. math.floor(game.enemy.y), UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 4)
    love.graphics.print('Feind Leben: ' .. game.enemy.health, UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 5)
    love.graphics.print('Feind Cooldown: ' .. string.format("%.1f", game.enemy.shootCooldown), UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 6)
    love.graphics.print('Punkte: ' .. game.score, UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 7)
    love.graphics.print('Spieler*in Leben: ' .. game.player.health, UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 8)
    
    -- Zeige den aktuellen Highscore an
    love.graphics.print('Bisheriger Highscore: ' .. game.currentHighscore, UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 9)
    
    -- Zeige Unverwundbarkeitszeit an
    if game.player.invincible then
        love.graphics.print('Unverwundbar: ' .. string.format("%.1f", game.player.invincibleTime), UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 10)
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then  -- 1 ist der linke Mausbutton
        local newState = game.ui:handleClick(x, y, game.state)
        if newState == "restart" then
            love.load()
        else
            game.state.currentState = newState
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end