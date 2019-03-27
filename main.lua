-- require('perlin')

require('catui')

local map = {}
map.sizeX = 1000
map.sizeY = 1000
map.tileSize = 1

function mapVal(x_in, in_min, in_max, out_min, out_max)
    return ((x_in - in_min) * (out_max - out_min)) / ((in_max - in_min) + out_min)
end

function generateNoiseMap(width, height, seed, scale, octaves, persistance, lacunarity)
    if scale <= 0 then
        scale = 0.0001
    end

    local rng = love.math.newRandomGenerator( seed )
    local ox = rng:random(100000)
    local oy = rng:random(100000)

    local lowest = 0
    local highest = 0
    -- generate noise
    local noiseMap = {}
    for x = 1, width do
        noiseMap[x] = {}
        for y = 1, height do
            local amplitude = 1
            local frequency = 1
            local noiseHeight = 0

            for o = 1, octaves do
              local sampleX = ((ox + x + rng:random())/ scale) * frequency
              local sampleY = ((oy + y + rng:random())/ scale) * frequency
              local noiseVal = (love.math.noise(sampleX, sampleY) * 2) - 1
              noiseHeight = noiseHeight + (noiseVal * amplitude)
              amplitude = amplitude * persistance
              frequency = frequency * lacunarity
            end

            if noiseHeight < lowest then
                lowest = noiseHeight
            elseif noiseHeight > highest then
                highest = noiseHeight
            end
            noiseMap[x][y] = noiseHeight
        end
    end

    for x = 1, width do
        for y = 1, height do
            noiseMap[x][y] = mapVal(noiseMap[x][y], lowest, highest, 0, 1)
        end
    end

    print('Highest: ' .. highest)
    print('Lowest: ' .. lowest)
    return noiseMap
end

function lerp(start, ending, amt)
    return (1 - amt) * start + amt * ending
end

function createButton(btnConfig)
  local btn = UIButton:new()
  btn:setPos(btnConfig.x, btnConfig.y)
  btn:setSize(btnConfig.w, btnConfig.h)
  btn:setText(btnConfig.text)
  btn:setAnchor(0, 0)
  btnConfig.parent:addChild(btn)
  return btn
end

function createLabel(lblConfig)
  local lbl = UILabel:new(lblConfig.font or "font/visat.ttf", tostring(lblConfig.text), lblConfig.fontSize or 12)
  lbl:setPos(lblConfig.x, lblConfig.y)
  lbl:setSize(lblConfig.w, lblConfig.h)
  lbl:setText(lblConfig.text)
  lbl:setAnchor(lblConfig.ax or 0, lblConfig.ay or 0)
  lbl:setAutoSize(lblConfig.autoSize or false)
  lbl:setFontColor(lblConfig.fontColor or {1, 1, 1, 1})
  lblConfig.parent:addChild(lbl)
  return lbl
end

function createInput(inConfig)
  local inp = UIEditText:new()
  inp:setPos(inConfig.x, inConfig.y)
  inp:setSize(inConfig.w, inConfig.h)
  inp:setText(tostring(inConfig.text))
  inConfig.parent:addChild(inp)
  return inp
end

function love.load()
    -- local noiseMap = {}
    -- perlin:load()
    noiseMap = generateNoiseMap(map.sizeX, map.sizeY, 11234, 140, 4, 0.4, 2)
    mgr = UIManager:getInstance()

    local content = UIContent:new()
    content:setPos(love.graphics.getWidth() - 150, 0)
    content:setSize(150, love.graphics.getHeight())
    content:setContentSize(150, love.graphics.getHeight())
    mgr.rootCtrl.coreContainer:addChild(content)

    local theme = {
      height = 20
    }
    local btnGenerate = createButton({
      x = 10,
      y = 50,
      w = 100,
      h = theme.height,
      text = 'Generate',
      parent = content
    })
    local mapConfig = createLabel({
      x = 10,
      y = 0,
      w = 100,
      h = theme.height,
      text = "Map Config",
      parent = content
    })
    local mapConfigXLabel = createLabel({
      x = 10,
      y = 25,
      w = 10,
      h = theme.height,
      text = "X:",
      parent = content
    })
    local mapConfigX = createInput({
      x = 35,
      y = 25,
      w = 40,
      h = theme.height,
      text = map.sizeX,
      parent = content
    })
    local mapConfigYLabel = createLabel({
      x = 75,
      y = 25,
      w = 10,
      h = theme.height,
      text = "Y:",
      parent = content
    })
    local mapConfigY = createInput({
      x = 100,
      y = 25,
      w = 40,
      h = theme.height,
      text = map.sizeY,
      parent = content
    })

    -- local MapEditSizeX = UIEditText:new()
    -- MapEditSizeX:setPos(100, 50)
    -- MapEditSizeX:setSize(35, 25)
    -- MapEditSizeX:setText(tostring(map.sizeX))
    -- content:addChild(MapEditSizeX)
    -- mgr.rootCtrl.coreContainer:addChild(MapEditSizeX)

    -- local MapEditSizeY = UIEditText:new()
    -- MapEditSizeY:setPos(60, 50)
    -- MapEditSizeY:setSize(35, 25)
    -- MapEditSizeY:setText(tostring(map.sizeY))
    -- content:addChild(MapEditSizeY)
    -- mgr.rootCtrl.coreContainer:addChild(MapEditSizeY)

    -- x = 1
    -- y = 1
    -- noiseMap[x][y] = noise:noise(1,1,0)
    -- noise:noise(139,254,0)
end

function love.update(dt)
    mgr:update(dt)
end

function love.draw()
    for x = 1, #noiseMap do
        for y = 1, #noiseMap[x] do
            -- local colorVal = mapVal(noiseMap[x][y], lowest, highest, 0, 1)
            local colorVal = noiseMap[x][y]
            love.graphics.setColor(colorVal, colorVal, colorVal)
            -- print('NoiseMap - X:' .. x .. ' Y: ' .. y .. ' : ' .. noiseMap[x][y])
            love.graphics.rectangle('fill', (x - 1) * map.tileSize, (y - 1) * map.tileSize, map.tileSize, map.tileSize)
        end
    end

    mgr:draw()
end

function love.mousemoved(x, y, dx, dy)
    mgr:mouseMove(x, y, dx, dy)
end

function love.mousepressed(x, y, button, isTouch)
    mgr:mouseDown(x, y, button, isTouch)
end

function love.mousereleased(x, y, button, isTouch)
    mgr:mouseUp(x, y, button, isTouch)
end

function love.keypressed(key, scancode, isrepeat)
    mgr:keyDown(key, scancode, isrepeat)
end

function love.keyreleased(key)
    mgr:keyUp(key)
end

function love.wheelmoved(x, y)
    mgr:whellMove(x, y)
end

function love.textinput(text)
    mgr:textInput(text)
end
