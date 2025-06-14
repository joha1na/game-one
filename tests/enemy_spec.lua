-- Test-Helper laden (setzt LÖVE-Mock global)
require('tests.test_helper')

-- Enemy-Modul laden
local Enemy = require('entities.Enemy')

describe('Enemy', function()
    local enemy
    
    before_each(function()
        -- Vor jedem Test einen neuen Enemy erstellen
        enemy = Enemy.new()
    end)
    
    describe('initialization', function()
        it('should create an enemy with correct default values', function()
            assert.are.equal(375, enemy.x)
            assert.are.equal(0, enemy.y)
            assert.are.equal(40, enemy.width)
            assert.are.equal(40, enemy.height)
            assert.is_true(enemy.verticalSpeed >= 100 and enemy.verticalSpeed <= 150)
            assert.is_true(enemy.horizontalSpeed >= 20 and enemy.horizontalSpeed <= 80)
            assert.is_true(enemy.direction == -1 or enemy.direction == 1)
            assert.are.equal(3, enemy.health)
            assert.are.equal(0.03, enemy.shootChance)
        end)
    end)
    
    describe('movement', function()
        it('should move vertically', function()
            local initialY = enemy.y
            enemy:update(1)
            assert.is_true(enemy.y > initialY)
        end)
        
        it('should move horizontally based on direction', function()
            local initialX = enemy.x
            local initialDirection = enemy.direction
            enemy:update(1)
            
            if initialDirection == 1 then
                assert.is_true(enemy.x > initialX)
            else
                assert.is_true(enemy.x < initialX)
            end
        end)
        
        it('should change direction at left boundary', function()
            enemy.x = 0
            enemy.direction = -1
            enemy:update(1)
            assert.are.equal(1, enemy.direction)
        end)
        
        it('should change direction at right boundary', function()
            enemy.x = love.graphics.getWidth() - enemy.width
            enemy.direction = 1
            enemy:update(1)
            assert.are.equal(-1, enemy.direction)
        end)
        
        it('should reset when leaving screen bottom', function()
            enemy.y = love.graphics.getHeight() + 1
            local initialX = enemy.x
            enemy:update(1)
            assert.are.equal(0, enemy.y)
            assert.is_true(enemy.x >= 0 and enemy.x <= love.graphics.getWidth() - enemy.width)
        end)
    end)
    
    describe('damage handling', function()
        it('should decrease health when taking damage', function()
            local initialHealth = enemy.health
            local wasDestroyed = enemy:takeDamage()
            
            assert.are.equal(initialHealth - 1, enemy.health)
            assert.is_false(wasDestroyed)
        end)
        
        it('should reset when health reaches zero', function()
            enemy.health = 1
            local wasDestroyed = enemy:takeDamage()
            
            assert.is_true(wasDestroyed)
            assert.are.equal(3, enemy.health)
            assert.are.equal(0, enemy.y)
        end)
    end)
    
    describe('shooting', function()
        it('should create a bullet with correct properties when shooting', function()
            -- Mock math.random um sicherzustellen, dass geschossen wird
            local originalRandom = math.random
            math.random = function() return 0 end
            
            enemy.shootCooldown = 0
            local bullet = enemy:shoot()
            
            assert.is_not_nil(bullet)
            assert.are.equal(enemy.x + enemy.width / 2 - 2, bullet.x)
            assert.are.equal(enemy.y + enemy.height, bullet.y)
            assert.are.equal(4, bullet.width)
            assert.are.equal(10, bullet.height)
            assert.are.equal(200, bullet.speed)
            
            -- Mock zurücksetzen
            math.random = originalRandom
        end)
        
        it('should not shoot when cooldown is active', function()
            enemy.shootCooldown = 0.1
            local bullet = enemy:shoot()
            assert.is_nil(bullet)
        end)
        
        it('should respect shoot chance', function()
            -- Mock math.random um sicherzustellen, dass nicht geschossen wird
            local originalRandom = math.random
            math.random = function() return 1 end
            
            enemy.shootCooldown = 0
            local bullet = enemy:shoot()
            assert.is_nil(bullet)
            
            -- Mock zurücksetzen
            math.random = originalRandom
        end)
    end)
    
    describe('reset mechanism', function()
        it('should reset all properties correctly', function()
            -- Setze einige Werte
            enemy.health = 1
            enemy.y = 100
            enemy.x = 100
            
            enemy:reset()
            
            assert.are.equal(3, enemy.health)
            assert.are.equal(0, enemy.y)
            assert.is_true(enemy.x >= 0 and enemy.x <= love.graphics.getWidth() - enemy.width)
            assert.is_true(enemy.verticalSpeed >= 100 and enemy.verticalSpeed <= 150)
            assert.is_true(enemy.horizontalSpeed >= 20 and enemy.horizontalSpeed <= 80)
        end)
    end)
end) 