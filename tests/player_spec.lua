local Player = require('entities.Player')

describe('Player', function()
    local player
    
    before_each(function()
        -- Vor jedem Test einen neuen Player erstellen
        player = Player.new()
    end)
    
    describe('initialization', function()
        it('should create a player with correct default values', function()
            assert.are.equal(375, player.x)
            assert.are.equal(500, player.y)
            assert.are.equal(50, player.width)
            assert.are.equal(50, player.height)
            assert.are.equal(200, player.speed)
            assert.are.equal(0, player.cooldown)
            assert.are.equal(3, player.health)
            assert.are.equal(false, player.invincible)
        end)
    end)
    
    describe('movement', function()
        it('should move left when left key is pressed', function()
            -- Mock für love.keyboard.isDown
            local originalIsDown = love.keyboard.isDown
            love.keyboard.isDown = function(key)
                return key == 'left'
            end
            
            local initialX = player.x
            player:update(1) -- 1 Sekunde update
            
            assert.is_true(player.x < initialX)
            
            -- Mock zurücksetzen
            love.keyboard.isDown = originalIsDown
        end)
        
        it('should move right when right key is pressed', function()
            -- Mock für love.keyboard.isDown
            local originalIsDown = love.keyboard.isDown
            love.keyboard.isDown = function(key)
                return key == 'right'
            end
            
            local initialX = player.x
            player:update(1) -- 1 Sekunde update
            
            assert.is_true(player.x > initialX)
            
            -- Mock zurücksetzen
            love.keyboard.isDown = originalIsDown
        end)
    end)
    
    describe('damage handling', function()
        it('should decrease health when taking damage and not invincible', function()
            local initialHealth = player.health
            player:takeDamage()
            
            assert.are.equal(initialHealth - 1, player.health)
            assert.is_true(player.invincible)
        end)
        
        it('should not decrease health when invincible', function()
            player.invincible = true
            local initialHealth = player.health
            
            player:takeDamage()
            
            assert.are.equal(initialHealth, player.health)
        end)
    end)
end)
