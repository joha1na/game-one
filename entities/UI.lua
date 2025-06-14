local UI = {}
local Highscore = require('highscore')
local UIConstants = require('constants.UI')

--[[
    UI-Klasse: Verantwortlich für die Benutzeroberfläche des Spiels
    Verantwortlich für:
    - Anzeige aller Spielbildschirme (Start, Pause, Game Over)
    - Button-Handling
    - Highscore-Anzeige
    - Debug-Informationen
]]

function UI.new()
    local self = setmetatable({}, { __index = UI })
    
    -- Cache fonts für bessere Performance
    self.fonts = {
        title = love.graphics.newFont(UIConstants.TITLE_SIZE),
        text = love.graphics.newFont(UIConstants.TEXT_SIZE),
        subtext = love.graphics.newFont(UIConstants.SUBTEXT_SIZE)
    }
    
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

--[[
    Zeichnet einen Button auf dem Bildschirm
    @param button table - Button-Objekt mit Position, Größe und Text
]]
function UI:drawButton(button)
    love.graphics.setColor(0.2, 0.6, 1)
    love.graphics.rectangle('fill', button.x, button.y, button.width, button.height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(button.text, 
        button.x, button.y + button.height/4, 
        button.width, "center")
end

--[[
    Prüft, ob ein Punkt innerhalb eines Buttons liegt
    @param x number - X-Koordinate des Punktes
    @param y number - Y-Koordinate des Punktes
    @param button table - Button-Objekt
    @return boolean - true wenn der Punkt im Button liegt
]]
function UI:isPointInButton(x, y, button)
    return x >= button.x and x <= button.x + button.width and
           y >= button.y and y <= button.y + button.height
end

--[[
    Zeichnet den Startbildschirm
    Zeigt Titel, Highscore und Start-Button
]]
function UI:drawStartScreen()
    -- Setze die Farbe auf Weiß
    love.graphics.setColor(1, 1, 1)
    
    -- Zeichne den Titel
    love.graphics.setFont(self.fonts.title)
    love.graphics.printf("Game One", 
        0, love.graphics.getHeight()/4, 
        love.graphics.getWidth(), "center")
    
    -- Zeichne den Highscore und die Herausforderung
    love.graphics.setFont(self.fonts.text)
    love.graphics.printf("Bisheriger Highscore: " .. Highscore.getBestScore(), 
        0, love.graphics.getHeight()/4 + UIConstants.LINE_HEIGHT * 2,
        love.graphics.getWidth(), "center")
    love.graphics.printf("Wirst du den Highscore knacken?", 
        0, love.graphics.getHeight()/4 + UIConstants.LINE_HEIGHT * 3,
        love.graphics.getWidth(), "center")
    
    -- Zeichne den Start-Button
    self:drawButton(self.startButton)
end

--[[
    Zeichnet den Pausebildschirm
    Zeigt Pause-Text und Zurück-Button
]]
function UI:drawPauseScreen()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(self.fonts.title)
    love.graphics.printf("Kurz durchatmen", 
        0, love.graphics.getHeight()/4, 
        love.graphics.getWidth(), "center")

    love.graphics.setFont(self.fonts.text)
    self:drawButton(self.backButton)
end

--[[
    Zeichnet den Game-Over-Bildschirm
    @param game table - Spielobjekt mit aktuellem Zustand und Score
]]
function UI:drawGameOverScreen(game)
    -- Debug-Ausgaben für Entwicklungszwecke
    local bestScore = Highscore.getBestScore()
    local previousBestScore = game.state.previousBestScore or 0
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(self.fonts.subtext)
    love.graphics.printf("Debug - Aktueller Score: " .. game.score, UIConstants.PADDING, UIConstants.START_Y, 300, "left")
    love.graphics.printf("Debug - Bester Score: " .. bestScore, UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT, 300, "left")
    love.graphics.printf("Debug - Vorheriger Bester Score: " .. previousBestScore, UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 2, 300, "left")
    love.graphics.printf("Debug - Ist neuer Highscore: " .. tostring(game.score > previousBestScore), UIConstants.PADDING, UIConstants.START_Y + UIConstants.LINE_HEIGHT * 3, 300, "left")
    
    -- Game Over Text
    love.graphics.setColor(1, 0, 0)
    love.graphics.setFont(self.fonts.title)
    love.graphics.printf("GAME OVER", 
        0, love.graphics.getHeight()/4, 
        love.graphics.getWidth(), "center")
    
    -- Zeige den aktuellen Score
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(self.fonts.text)
    love.graphics.printf("Dein Score: " .. game.score,
        0, love.graphics.getHeight()/4 + 50,
        love.graphics.getWidth(), "center")
    
    -- Prüfe, ob ein neuer Highscore erreicht wurde
    if game.score > 0 and game.score > previousBestScore then
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
        if highscore == game.score and game.score > previousBestScore then
            love.graphics.setColor(1, 0.8, 0)  -- Goldene Farbe für den neuen Highscore
        else
            love.graphics.setColor(1, 1, 1)    -- Weiße Farbe für andere Scores
        end
        love.graphics.printf(i .. ". " .. highscore,
            0, love.graphics.getHeight()/4 + 150 + (i-1)*30,
            love.graphics.getWidth(), "center")
    end
    
    -- Neustart-Button
    self.startButton.text = "Neustart"
    self.startButton.y = love.graphics.getHeight() - love.graphics.getHeight() / 4
    self:drawButton(self.startButton)
end

--[[
    Behandelt Mausklicks auf Buttons
    @param x number - X-Koordinate des Klicks
    @param y number - Y-Koordinate des Klicks
    @param gameState table - Aktueller Spielzustand
    @return string - Neuer Spielzustand oder aktueller Zustand
]]
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