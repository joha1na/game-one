local UI = {}
local Highscore = require('highscore')
local UIConstants = require('constants.UI')
local UIEffects = require('graphics.UIEffects')

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
    Zeichnet einen Button auf dem Bildschirm mit verbessertem Design
    @param button table - Button-Objekt mit Position, Größe und Text
    @param isHovered boolean - Ist der Button gehovered (optional)
]]
--[[ function UI:drawButton(button)
    love.graphics.setColor(0.2, 0.6, 1)
    love.graphics.rectangle('fill', button.x, button.y, button.width, button.height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(button.text, 
        button.x, button.y + button.height/4, 
        button.width, "center") ]]
function UI:drawButton(button, isHovered)
    -- Verwende die neuen UI-Effekte für bessere Buttons
    UIEffects.drawButton(button.text, button.x, button.y, button.width, button.height, isHovered or false)
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
    Zeichnet den Startbildschirm mit verbesserter Grafik
    Zeigt Titel, Highscore und Start-Button
]]
function UI:drawStartScreen()
    -- Setze die Farbe auf Weiß
    love.graphics.setColor(1, 1, 1)
    
    -- Zeichne den Titel mit Glow-Effekt
    love.graphics.setFont(self.fonts.title)
--[[     love.graphics.printf("Game One", 
        0, love.graphics.getHeight()/4, 
        love.graphics.getWidth(), "center") ]]
    local titleText = "Game One"
    local titleX = love.graphics.getWidth()/2 - self.fonts.title:getWidth(titleText)/2
    local titleY = love.graphics.getHeight()/4
    
    -- Animierter Puls-Effekt für den Titel
    local pulseValue = UIEffects.getPulseValue(love.timer.getTime())
    love.graphics.push()
    love.graphics.translate(titleX + self.fonts.title:getWidth(titleText)/2, titleY + self.fonts.title:getHeight()/2)
    love.graphics.scale(pulseValue, pulseValue)
    love.graphics.translate(-self.fonts.title:getWidth(titleText)/2, -self.fonts.title:getHeight()/2)
    
    UIEffects.drawGlowText(titleText, 0, 0, {0.4, 0.8, 1, 1})
    love.graphics.pop()
    
    -- Zeichne den Highscore und die Herausforderung mit Glow
    love.graphics.setFont(self.fonts.text)
--[[     love.graphics.printf("Bisheriger Highscore: " .. Highscore.getBestScore(), 
        0, love.graphics.getHeight()/4 + UIConstants.LINE_HEIGHT * 2,
        love.graphics.getWidth(), "center")
    love.graphics.printf("Wirst du den Highscore knacken?", 
        0, love.graphics.getHeight()/4 + UIConstants.LINE_HEIGHT * 3,
        love.graphics.getWidth(), "center") ]]
    local highscoreText = "Bisheriger Highscore: " .. Highscore.getBestScore()
    local challengeText = "Wirst du den Highscore knacken?"
    
    local highscoreX = love.graphics.getWidth()/2 - self.fonts.text:getWidth(highscoreText)/2
    local challengeX = love.graphics.getWidth()/2 - self.fonts.text:getWidth(challengeText)/2
    
    UIEffects.drawGlowText(highscoreText, highscoreX, titleY + UIConstants.LINE_HEIGHT * 3, {1, 1, 0, 1})
    UIEffects.drawGlowText(challengeText, challengeX, titleY + UIConstants.LINE_HEIGHT * 4, {0.8, 0.8, 0.8, 1})
    
    -- Zeichne den Start-Button mit Hover-Effekt
    self:drawButton(self.startButton)
end

--[[
    Zeichnet den Pausebildschirm mit verbesserter Grafik
    Zeigt Pause-Text und Zurück-Button
]]
function UI:drawPauseScreen()
    -- Halbtransparenter Overlay-Hintergrund
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(self.fonts.title)
--[[     love.graphics.printf("Kurz durchatmen", 
        0, love.graphics.getHeight()/4, 
        love.graphics.getWidth(), "center") ]]
    
    local pauseText = "Kurz durchatmen"
    local textX = love.graphics.getWidth()/2 - self.fonts.title:getWidth(pauseText)/2
    local textY = love.graphics.getHeight()/4
    
    UIEffects.drawGlowText(pauseText, textX, textY, {0.8, 0.8, 1, 1})

    love.graphics.setFont(self.fonts.text)
    self:drawButton(self.backButton)
end

--[[
    Zeichnet den Game-Over-Bildschirm mit verbesserter Grafik
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
    -- love.graphics.setColor(1, 0, 0)
    -- Game Over Text mit dramatischem Effekt
    love.graphics.setFont(self.fonts.title)
--[[     love.graphics.printf("GAME OVER", 
        0, love.graphics.getHeight()/4, 
        love.graphics.getWidth(), "center")
    
    -- Zeige den aktuellen Score
    love.graphics.setColor(1, 1, 1) ]]
    local gameOverText = "GAME OVER"
    local gameOverX = love.graphics.getWidth()/2 - self.fonts.title:getWidth(gameOverText)/2
    local gameOverY = love.graphics.getHeight()/4
    
    -- Pulsierender Effekt für "GAME OVER"
    local pulseValue = 0.8 + 0.2 * math.sin(love.timer.getTime() * 4)
    love.graphics.push()
    love.graphics.translate(gameOverX + self.fonts.title:getWidth(gameOverText)/2, gameOverY + self.fonts.title:getHeight()/2)
    love.graphics.scale(pulseValue, pulseValue)
    love.graphics.translate(-self.fonts.title:getWidth(gameOverText)/2, -self.fonts.title:getHeight()/2)
    
    UIEffects.drawGlowText(gameOverText, 0, 0, {1, 0.3, 0.3, 1})
    love.graphics.pop()
    
    -- Zeige den aktuellen Score mit Glow
    love.graphics.setFont(self.fonts.text)
--[[     love.graphics.printf("Dein Score: " .. game.score,
        0, love.graphics.getHeight()/4 + 50,
        love.graphics.getWidth(), "center") ]]
    local scoreText = "Dein Score: " .. game.score
    local scoreX = love.graphics.getWidth()/2 - self.fonts.text:getWidth(scoreText)/2
    UIEffects.drawGlowText(scoreText, scoreX, gameOverY + 50, {1, 1, 1, 1})
    
    -- Prüfe, ob ein neuer Highscore erreicht wurde
    if game.score > 0 and game.score > previousBestScore then
--[[         love.graphics.setColor(1, 0.8, 0)  -- Goldene Farbe für die Nachricht
        love.graphics.printf("NEUER HIGHSCORE!",
            0, love.graphics.getHeight()/4 + 80,
            love.graphics.getWidth(), "center") ]]
        local newHighscoreText = "NEUER HIGHSCORE!"
        local newHighscoreX = love.graphics.getWidth()/2 - self.fonts.text:getWidth(newHighscoreText)/2
        
        -- Animierter Glow-Effekt für neuen Highscore
        local glowIntensity = 0.7 + 0.3 * math.sin(love.timer.getTime() * 6)
        UIEffects.drawGlowText(newHighscoreText, newHighscoreX, gameOverY + 80, {1, 0.8, 0, glowIntensity})
    end
    
    -- Zeige die Highscores
--[[     love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Highscores:", 
        0, love.graphics.getHeight()/4 + 120,
        love.graphics.getWidth(), "center") ]]
    -- Zeige die Highscores mit verbessertem Design
    local highscoresText = "Highscores:"
    local highscoresX = love.graphics.getWidth()/2 - self.fonts.text:getWidth(highscoresText)/2
    UIEffects.drawGlowText(highscoresText, highscoresX, gameOverY + 120, {0.8, 0.8, 1, 1})
    
    local scores = Highscore.getAllScores()
    for i, highscore in ipairs(scores) do
        local scoreDisplayText = i .. ". " .. highscore
        local scoreDisplayX = love.graphics.getWidth()/2 - self.fonts.text:getWidth(scoreDisplayText)/2
        
        -- Hebe den aktuellen Score hervor, wenn es ein neuer Highscore ist
        if highscore == game.score and game.score > previousBestScore then
            -- love.graphics.setColor(1, 0.8, 0)  -- Goldene Farbe für den neuen Highscore
            local glowIntensity = 0.8 + 0.2 * math.sin(love.timer.getTime() * 5)
            UIEffects.drawGlowText(scoreDisplayText, scoreDisplayX, gameOverY + 150 + (i-1)*30, {1, 0.8, 0, glowIntensity})
        else
            -- love.graphics.setColor(1, 1, 1)    -- Weiße Farbe für andere Scores
            UIEffects.drawGlowText(scoreDisplayText, scoreDisplayX, gameOverY + 150 + (i-1)*30, {1, 1, 1, 0.8})
        end
--[[         love.graphics.printf(i .. ". " .. highscore,
            0, love.graphics.getHeight()/4 + 150 + (i-1)*30,
            love.graphics.getWidth(), "center") ]]
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