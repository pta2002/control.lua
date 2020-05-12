# control.lua - A library for easily supporting different input methods

There's an example file in main.lua

## Usage
First clone the library into your project:

```bash
# --recursive is required because this depends on git submodules
$ git clone https://github.com/pta2002/control.lua.git --recursive
```

Require the library and create a Control object:

```lua
local Control = require "control.control"

function love.load()
    p1 = Control:new(1) -- 1 is the controller you want to use
end
```

### Axes
To add a new axis, we use the Control:addAxis method:

```lua
Control:addAxis(label, {negative_keys, positive_keys}, {controller_axis, negative_buttons, positive_buttons})
```

Keys, buttons and axis are provided as a table of alternatives. For example, to have both W and the up arrow return -1, you would say

```lua
{"w", "up"}
```

Here's an example of the addAxis function:

```lua
p1:addAxis("x", -- Add an axis named 'x'
    {
        {"a", "left"}, -- A and the left arrow will return -1 
        {"d", "right"} -- D and the right arrow will return 1
    },{
        {1}, -- Use controller axis 1 (on a dualshock3 controller, this is the horizontal axis on the left thumbstick))
        {}, {} -- No controller buttons will alter the X axis
    }
)
```

You can then get the axis by using the Control:getAxis function:

```lua
Control:getAxis(label) -- Returns a value ranging from -1 to 1
```

Full example:

```lua
local Control = require "control"

function love.load()
    x = 0
    y = 0
    p1 = Control:new(1) -- Use the first controller
    -- WASD for moving, left thumbstick, or the controller D-pad
    p1:addAxis("x", {{"a", "left"}, {"d", "right"}}, {{1}, {8}, {6}})
    p1:addAxis("y", {{"w", "up"}, {"s", "down"}}, {{2}, {5}, {7}})
end

function love.update(dt)
    -- Move using the x and y axes
    x = x + p1:getAxis("x") * dt * 100
    y = y + p1:getAxis("y") * dt * 100
end

function love.draw()
    -- Draw a rectangle on the x and y coordinates
    love.graphics.rectangle("fill", x, y, 10, 10)
end
```

### Buttons
You can add a button using the Control:addButton method:

```lua
Control:addButton(label, keyboard_keys, controller_keys)
```

Example:

```lua
Control:addButton("jump", -- Add a button labeled 'jump'
                  {"space", "w", "up"}, -- Use the space, up and w keys for this
                  {16}) -- Use the controller button with the ID of 16, or the X button on a PS3 controller
```

You can then check wether the button is pressed using the Control:getButton method:

```lua
Control:getButton(label) -- Returns either true or false
```

Example:

```lua
jumping = p1:getButton("jump")
```

Full example:

```lua
local Control = require "control"

function love.init()
    p1 = Control:new(1) -- Create a new control using the first controller
    p1:addButton("blue", {"space", "w", "up"}, {16}) -- Pressing space, w or up on a keyboard and the button with ID 16 on a controller will trigger the 'blue' button
end

function love.draw()
    if p1:getButton("blue") then -- if the button 'blue' is pressed
        love.graphics.setBackgroundColor(0, 0, 255) -- Set the color blue
    else
        love.graphics.setBackgroundColor(0, 0, 0) -- Otherwise, the background is white
    end
end
```
### Events
You can specify functions to be run on button press and button release, with the
Control:addOnPressed and Control:addOnReleased methods:

```lua
p1:addOnPressed(keys, controllerbuttons, func)
p1:addOnReleased(keys, controllerbuttons, func)
```

This will call func when one of keys or controllerbuttons is pressed. You also need
to call Control:keypressed, Control:keyreleased, Control:joystickpressed and Control:joystickreleased
on their respective events:

```lua
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
```

# LICENSE
```
Copyright (c) 2017 Pedro Alves (pta2002)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
