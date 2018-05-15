Class = require "core.lib.hump.class"



function love.load()
  -- body...
  love.graphics.setDefaultFilter("nearest", "nearest")
  font = love.graphics.newFont(50)
end


function love.update(dt)
  -- body...
end

function love.draw()
  love.graphics.setFont(font)
  love.graphics.print("Hello", 100, 100)
end
