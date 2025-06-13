local Highscore = require('highscore')
local originalSave = Highscore.save -- Original-Funktion sichern

describe('Highscore', function()
    before_each(function()
        -- Zurücksetzen des Highscore-Moduls vor jedem Test
        Highscore.scores = {}
        -- Mock für die Speicherfunktion erstellen, um Tests nicht zu beeinträchtigen
        Highscore.save = function() end
    end)
    
    after_each(function()
        -- Original-Funktion wiederherstellen
        Highscore.save = originalSave
    end)
    
    it('should add a new score to the list', function()
        Highscore.addScore(100)
        
        assert.are.equal(1, #Highscore.scores)
        assert.are.equal(100, Highscore.scores[1])
    end)
    
    it('should return best score', function()
        Highscore.addScore(100)
        Highscore.addScore(200)
        Highscore.addScore(150)
        
        local bestScore = Highscore.getBestScore()
        
        assert.are.equal(200, bestScore)
    end)
    
    it('should handle empty score list', function()
        local bestScore = Highscore.getBestScore()
        
        assert.are.equal(0, bestScore)
    end)
    
    it('should sort scores in descending order', function()
        Highscore.addScore(100)
        Highscore.addScore(300)
        Highscore.addScore(200)
        
        -- Tests bereits sortierte Scores
        assert.are.equal(300, Highscore.scores[1])
        assert.are.equal(200, Highscore.scores[2])
        assert.are.equal(100, Highscore.scores[3])
    end)
    
    it('should limit scores to maxScores', function()
        Highscore.maxScores = 3
        
        Highscore.addScore(100)
        Highscore.addScore(200)
        Highscore.addScore(150)
        Highscore.addScore(300)
        Highscore.addScore(50)
        
        assert.are.equal(3, #Highscore.scores)
        assert.are.equal(300, Highscore.scores[1])
        assert.are.equal(200, Highscore.scores[2])
        assert.are.equal(150, Highscore.scores[3])
    end)
end)
