local Control = require "control"

function love.load()
    x = 0
    y = 0
    w = 10
    h = 10
    p1 = Control:new(1)
    p1:addButton("blue", {"space"}, {15})
    p1:addAxis("x", {{"a", "left"}, {"d", "right"}}, {{1}, {8}, {6}})
    p1:addAxis("y", {{"w", "up"}, {"s", "down"}}, {{2}, {5}, {7}})
    p1:addOnPressed({"z", "q"}, {14}, grow)
    p1:addOnReleased({"z", "q"}, {14}, shrink)
end

function love.update(dt)
    x = x + p1:getAxis("x") * dt * 100
    y = y + p1:getAxis("y") * dt * 100
end

function love.keypressed(key, sc, isrepeat)
    p1:keypressed(key, sc, isrepeat)
end
function love.joystickpressed(js, btn)
    p1:joystickpressed(js, btn)
end
function love.keyreleased(key, sc, isrepeat)
    p1:keyreleased(key, sc, isrepeat)
end
function love.joystickreleased(js, btn)
    p1:joystickreleased(js, btn)
end

function grow()
    w = w + 5
    h = h + 5
end

function shrink()
    w = w - 5
    h = h - 5
end

function love.draw()
    if p1:getButton("blue") then
        love.graphics.setColor(0, 0, 255)
    else
        love.graphics.setColor(255, 255, 255)
    end
    love.graphics.rectangle("fill", x, y, w, h)
end
