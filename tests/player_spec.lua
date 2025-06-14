-- Test-Helper laden (setzt LÖVE-Mock global)
require('tests.test_helper')

-- Player-Modul laden
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
            assert.are.equal(0.1, player.shootCooldown)
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

        it('should not move beyond left screen boundary', function()
            -- Mock für love.keyboard.isDown
            local originalIsDown = love.keyboard.isDown
            love.keyboard.isDown = function(key)
                return key == 'left'
            end
            
            -- Setze Spieler an den linken Rand
            player.x = 0
            player:update(1)
            
            assert.are.equal(0, player.x)
            
            -- Mock zurücksetzen
            love.keyboard.isDown = originalIsDown
        end)

        it('should not move beyond right screen boundary', function()
            -- Mock für love.keyboard.isDown
            local originalIsDown = love.keyboard.isDown
            love.keyboard.isDown = function(key)
                return key == 'right'
            end
            
            -- Setze Spieler an den rechten Rand
            player.x = love.graphics.getWidth() - player.width
            player:update(1)
            
            assert.are.equal(love.graphics.getWidth() - player.width, player.x)
            
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

        it('should have correct invincibility duration', function()
            player:takeDamage()
            assert.are.equal(2, player.invincibleTime)
            assert.are.equal(0.1, player.flashTime)
        end)

        it('should end invincibility after duration', function()
            player:takeDamage()
            player:update(2.1) -- Warte länger als die Unverwundbarkeitszeit
            assert.is_false(player.invincible)
        end)
    end)

    describe('shooting', function()
        it('should create a bullet with correct properties', function()
            -- Stelle sicher, dass der Cooldown abgelaufen ist
            player.shootCooldown = 0
            
            local bullet = player:shoot()
            assert.is_not_nil(bullet)
            assert.are.equal(player.x + player.width / 2 - 2, bullet.x)
            assert.are.equal(player.y, bullet.y)
            assert.are.equal(4, bullet.width)
            assert.are.equal(10, bullet.height)
            assert.are.equal(400, bullet.speed)
        end)

        it('should not shoot when cooldown is active', function()
            player.shootCooldown = 0.05
            local bullet = player:shoot()
            assert.is_nil(bullet)
        end)

        it('should reset cooldown after shooting', function()
            player.shootCooldown = 0
            local bullet = player:shoot()
            assert.are.equal(0.1, player.shootCooldown)
        end)
    end)

    describe('update mechanism', function()
        it('should update cooldown correctly', function()
            player.shootCooldown = 0.1
            player:update(0.05)
            assert.are.equal(0.05, player.shootCooldown)
        end)

        it('should update invincibility time correctly', function()
            player:takeDamage()
            player:update(1)
            assert.are.equal(1, player.invincibleTime)
        end)

        it('should update flash time correctly', function()
            player:takeDamage()
            player:update(0.05)
            assert.are.equal(0.05, player.flashTime)
        end)
    end)
end)
