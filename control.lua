--
-- control.lua
--
-- Copyright (c) 2017 Pedro Alves (pta2002)
--
-- This library is free software; you can redistribute it and/or modify it under
-- the terms of the MIT license. See LICENSE for details
--

local folderOfThisFile = (...):match("(.-)[^%.]+$")
local Object = require(folderOfThisFile .. "classic.classic")
local Control = Object:extend()

Control.version = "0.2.0"

function Control:new(controller)
    self.controller = controller
    self.buttons = {}
    self.axes = {}
    self.keypress = {}
    self.keyrelease = {}
    self.joypressed = {}
    self.joyreleased = {}
end

function Control:addAxis(label, keyboard, controller)
    self.axes[label] = {label=label, keyboard=keyboard, controller=controller}
end

function Control:getAxis(axis)
    if self.axes[axis] ~= nil then
        local axis = self.axes[axis]
        local move = 0

        if axis.keyboard ~= nil then
            for i,key in ipairs(axis.keyboard[1]) do
                if love.keyboard.isDown(key) then
                    move = move - 1
                    break
                end
            end
            for i,key in ipairs(axis.keyboard[2]) do
                if love.keyboard.isDown(key) then
                    move = move + 1
                    break
                end
            end
        end

        local joysticks = love.joystick.getJoysticks()
        local controller = 0
        if self.mobiletype ~= "tilt" and (love.system.getOS() == "Android" or love.system.getOS() == "iOS") then
            controller = self.controller + 1
        else
            controller = self.controller
        end
        if axis.controller ~= nil and joysticks[controller] ~= nil then
            for i,ax in ipairs(axis.controller[1]) do
                move = move + joysticks[controller]:getAxis(ax)
            end
            for i,btn in ipairs(axis.controller[2]) do
                if joysticks[controller]:isDown(btn) then
                    move = move - 1
                    break
                end
            end
            for i,btn in ipairs(axis.controller[3]) do
                if joysticks[controller]:isDown(btn) then
                    move = move + 1
                    break
                end
            end
        end

        return clamp(move, -1, 1)
    else
        print("WARNING: Axis " .. axis .. " not set!")
        return 0
    end
end

function Control:addButton(label, keyboard, controller, mobile)
    self.buttons[label] = {keyboard, controller, mobile}
end

function Control:getButton(label)
    if self.buttons[label] ~= nil then
        for i,key in ipairs(self.buttons[label][1]) do
            if love.keyboard.isDown(key) then
                return true
            end
        end

        -- There used to be a TODO here but I completely forgot what it was for
        -- ... so if you notice something missing here, contact me.
        for i,button in ipairs(self.buttons[label][2]) do
            local joysticks = love.joystick.getJoysticks()
            if joysticks[self.controller] ~= nil then
                if joysticks[self.controller]:isDown(button) then
                    return true
                end
            end
        end

        return false
    else
        print("WARNING: " .. label .. " hasn't been mapped!")
        return false
    end
end

function Control:addOnPressed(keyboard, joystick, func)
    for i,key in ipairs(keyboard) do
        if self.keypress[string.lower(key)] == nil then self.keypress[string.lower(key)] = {} end
        table.insert(self.keypress[string.lower(key)], func)
    end
    for i,button in ipairs(joystick) do
        if self.joypressed[button] == nil then self.joypressed[button] = {} end
        table.insert(self.joypressed[button], func)
    end
end

function Control:keypressed(key, scancode, isrepeat)
    if self.keypress[key] ~= nil then
        for i,f in ipairs(self.keypress[key]) do
            f()
        end
    end
end

function Control:joystickpressed(joystick, button)
    local joysticks = love.joystick.getJoysticks()
    local controller = 0
        if self.mobiletype ~= "tilt" and (love.system.getOS() == "Android" or love.system.getOS() == "iOS") then
            controller = self.controller + 1
        else
            controller = self.controller
        end
    if joysticks[controller] == joystick and self.joypressed[button] ~= nil then
        for i,f in ipairs(self.joypressed[button]) do
            f()
        end
    end
end

function Control:addOnReleased(keyboard, joystick, func)
    for i,key in ipairs(keyboard) do
        if self.keyrelease[string.lower(key)] == nil then self.keyrelease[string.lower(key)] = {} end
        table.insert(self.keyrelease[string.lower(key)], func)
    end
    for i,button in ipairs(joystick) do
        if self.joyreleased[button] == nil then self.joyreleased[button] = {} end
        table.insert(self.joyreleased[button], func)
    end
end

function Control:keyreleased(key, scancode, isrepeat)
    if self.keyrelease[key] ~= nil then
        for i,f in ipairs(self.keyrelease[key]) do
            f()
        end
    end
end

function Control:joystickreleased(joystick, button)
    local joysticks = love.joystick.getJoysticks()
    local controller = 0
        if self.mobiletype ~= "tilt" and (love.system.getOS() == "Android" or love.system.getOS() == "iOS") then
            controller = self.controller + 1
        else
            controller = self.controller
        end
    if joysticks[controller] == joystick and self.joyreleased[button] ~= nil then
        for i,f in ipairs(self.joyreleased[button]) do
            f()
        end
    end
end


function clamp(val, lower, upper)
    assert(val and lower and upper, "all arguments are required")
    if lower > upper then lower, upper = upper, lower end
    return math.max(lower, math.min(upper, val))
end

return Control
