local Control = require "control"

function love.load()
    x = 0
    y = 0
    p1 = Control(1)
    p1:addButton("blue", {"space"}, {15})
    p1:addAxis("x", {{"a", "left"}, {"d", "right"}}, {{1}, {8}, {6}})
    p1:addAxis("y", {{"w", "up"}, {"s", "down"}}, {{2}, {5}, {7}})
end

function love.update(dt)
    x = x + p1:getAxis("x") * dt * 100
    y = y + p1:getAxis("y") * dt * 100
end

function love.draw()
    if p1:getButton("blue") then
        love.graphics.setColor(0, 0, 255)
    else
        love.graphics.setColor(255, 255, 255)
    end
    love.graphics.rectangle("fill", x, y, 10, 10)
end
