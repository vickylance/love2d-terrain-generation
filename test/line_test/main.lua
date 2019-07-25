
local inspect = require("inspect")


local grid = {}
grid.size = {
  x = 500,
  y = 500
}
grid.tileSize = {
  x = 5,
  y = 5
}
grid.offset = {
  x = 50,
  y = 50
}
grid.generatePts = function(self)
  self.gridLines = {}
  for x = 0, self.size.x, self.tileSize.x do
    local verticalLine = {{x + grid.offset.x, 0 + grid.offset.y}, {x + grid.offset.x, self.size.y + grid.offset.y}}
    table.insert( self.gridLines, verticalLine )
  end
  for y = 0, self.size.y, self.tileSize.y do
    local horizontalLine = {{0 + grid.offset.x, y + grid.offset.y}, {self.size.x + grid.offset.x, y + grid.offset.y}}
    table.insert( self.gridLines, horizontalLine )
  end
end
grid.draw = function (self)
  love.graphics.setColor(1, 1, 1, 0.3)
  for i=1, #self.gridLines do
    local linePts = self.gridLines[i]
    love.graphics.line(linePts[1][1], linePts[1][2], linePts[2][1], linePts[2][2])
  end
end

function love.load()
  grid:generatePts()
end

function love.update(dt)
end

function love.draw()
  grid:draw()
end