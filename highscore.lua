local json = require('json')

local Highscore = {
    scores = {},
    maxScores = 5  -- Anzahl der gespeicherten Highscores
}

-- Lädt die Highscores aus der Datei
function Highscore.load()
    local file = io.open("highscores.json", "r")
    if file then
        local content = file:read("*all")
        file:close()
        Highscore.scores = json.decode(content) or {}
    end
end

-- Speichert die Highscores in der Datei
function Highscore.save()
    local file = io.open("highscores.json", "w")
    if file then
        file:write(json.encode(Highscore.scores))
        file:close()
    end
end

-- Fügt einen neuen Score hinzu, wenn er zu den Top-Scores gehört
function Highscore.addScore(score)
    table.insert(Highscore.scores, score)
    table.sort(Highscore.scores, function(a, b) return a > b end)
    
    -- Behalte nur die besten Scores
    while #Highscore.scores > Highscore.maxScores do
        table.remove(Highscore.scores)
    end
    
    Highscore.save()
end

-- Gibt den besten Score zurück
function Highscore.getBestScore()
    return Highscore.scores[1] or 0
end

-- Gibt alle Scores zurück
function Highscore.getAllScores()
    return Highscore.scores
end

return Highscore 