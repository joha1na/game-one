local UI = {}
UI.__index = UI

local Highscore = require('highscore')

function UI.new()
    local self = setmetatable({}, UI)
    
    -- Button-Konfiguration
    local buttonWidth = 200
    local buttonHeight = 50
    local buttonX = love.graphics.getWidth() / 2 - buttonWidth / 2
    local buttonY = love.graphics.getHeight() / 2 - buttonHeight / 2
    
    -- Start-Button
    self.startButton = {
        x = buttonX,
        y = buttonY,
        width = buttonWidth,
        height = buttonHeight,
        text = "Spiel starten"
    }
    
    -- Zurück-Button
    self.backButton = {
        x = buttonX,
        y = buttonY,
        width = buttonWidth,
        height = buttonHeight,
        text = "Zurück zum Spiel"
    }
    
    return self
end

function UI:drawButton(button)
    love.graphics.setColor(0.2, 0.6, 1)
    love.graphics.rectangle('fill', button.x, button.y, button.width, button.height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(button.text, 
        button.x, button.y + button.height/4, 
        button.width, "center")
end

function UI:isPointInButton(x, y, button)
    return x >= button.x and x <= button.x + button.width and
           y >= button.y and y <= button.y + button.height
end

function UI:drawStartScreen()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Game One", 
        0, love.graphics.getHeight()/4, 
        love.graphics.getWidth(), "center")
    
    self:drawButton(self.startButton)
end

function UI:drawPauseScreen()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Kurz durchatmen",
        0, love.graphics.getHeight()/4,
        love.graphics.getWidth(), "center")

    self:drawButton(self.backButton)
end

function UI:drawGameOverScreen()
    -- Debug-Ausgaben
    local bestScore = Highscore.getBestScore()
    local previousBestScore = gameState.previousBestScore or 0
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Debug - Aktueller Score: " .. score, 10, 10, 300, "left")
    love.graphics.printf("Debug - Bester Score: " .. bestScore, 10, 30, 300, "left")
    love.graphics.printf("Debug - Vorheriger Bestwert: " .. previousBestScore, 10, 50, 300, "left")
    love.graphics.printf("Debug - Ist neuer Highscore: " .. tostring(score > previousBestScore), 10, 70, 300, "left")
    
    love.graphics.setColor(1, 0, 0)
    love.graphics.printf("GAME OVER", 
        0, love.graphics.getHeight()/4, 
        love.graphics.getWidth(), "center")
    
    -- Zeige den aktuellen Score
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Dein Score: " .. score,
        0, love.graphics.getHeight()/4 + 50,
        love.graphics.getWidth(), "center")
    
    -- Prüfe, ob ein neuer Highscore erreicht wurde
    if score > 0 and score > previousBestScore then
        love.graphics.setColor(1, 0.8, 0)  -- Goldene Farbe für die Nachricht
        love.graphics.printf("NEUER HIGHSCORE!",
            0, love.graphics.getHeight()/4 + 80,
            love.graphics.getWidth(), "center")
    end
    
    -- Zeige die Highscores
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Highscores:", 
        0, love.graphics.getHeight()/4 + 120,
        love.graphics.getWidth(), "center")
    
    local scores = Highscore.getAllScores()
    for i, highscore in ipairs(scores) do
        -- Hebe den aktuellen Score hervor, wenn es ein neuer Highscore ist
        if highscore == score and score > previousBestScore then
            love.graphics.setColor(1, 0.8, 0)  -- Goldene Farbe für den neuen Highscore
        else
            love.graphics.setColor(1, 1, 1)    -- Weiße Farbe für andere Scores
        end
        love.graphics.printf(i .. ". " .. highscore,
            0, love.graphics.getHeight()/4 + 140 + (i-1)*30,
            love.graphics.getWidth(), "center")
    end

    self.startButton.text = "Neustart"
    self.startButton.y = love.graphics.getHeight() - love.graphics.getHeight() / 4
    self:drawButton(self.startButton)
end

function UI:handleClick(x, y, gameState)
    if gameState.currentState == "start" and self:isPointInButton(x, y, self.startButton) then
        return "playing"
    elseif gameState.currentState == "paused" and self:isPointInButton(x, y, self.backButton) then
        return "playing"
    elseif gameState.currentState == "gameOver" and self:isPointInButton(x, y, self.startButton) then
        return "restart"
    end
    return gameState.currentState
end

return UI 