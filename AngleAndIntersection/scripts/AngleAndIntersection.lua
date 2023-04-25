
--Start of Global Scope---------------------------------------------------------

print('AppEngine Version: ' .. Engine.getVersion())

local DELAY = 1000 -- ms between visualization steps for demonstration purpose

-- Creating viewer
local viewer = View.create()

-- Setting up graphical overlay attributes
local regionDecoration = View.ShapeDecoration.create():setLineWidth(4)
regionDecoration:setLineColor(230, 230, 0) -- Yellow

local featureDecoration = View.ShapeDecoration.create():setLineWidth(4)
featureDecoration:setPointType('DOT'):setPointSize(5):setLineColor(75, 75, 255) -- Blue

local dotDecoration = View.ShapeDecoration.create():setPointSize(10)
dotDecoration:setPointType('DOT'):setLineColor(230, 0, 0) -- Red

local angleTextDeco = View.TextDecoration.create():setSize(20)

local intersectionTextDeco = View.TextDecoration.create():setSize(15)

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

local function main()
  local img = Image.load('resources/AngleAndIntersection.bmp')
  viewer:clear()
  viewer:addImage(img)
  viewer:present()
  Script.sleep(DELAY) -- for demonstration purpose only

  -- Creating common edge fitter
  local edgeFitter = Image.ShapeFitter.create()

  -- Fitting edge1 (left)
  local edgeCenter1 = Point.create(180, 170)
  local edgeRect1 = Shape.createRectangle(edgeCenter1, 90, 40, math.rad(-25))
  local angle1 = math.rad(90 - 25)
  local edge1segm, _ = edgeFitter:fitLine(img, edgeRect1:toPixelRegion(img), angle1)
  local line1 = edge1segm:toLine()
  viewer:addShape(edge1segm, featureDecoration)
  viewer:addShape(edgeRect1, regionDecoration)

  -- Fitting edge2 (right)
  local edgeCenter2 = Point.create(450, 170)
  local edgeRect2 = Shape.createRectangle(edgeCenter2, 90, 40, math.rad(25))
  local angle2 = math.rad(-90 + 25)
  local edge2segm, _ = edgeFitter:fitLine(img, edgeRect2:toPixelRegion(img), angle2)
  local line2 = edge2segm:toLine()
  viewer:addShape(edge2segm, featureDecoration)
  viewer:addShape(edgeRect2, regionDecoration)

  -- Finding intersection and measuring angle
  local intersection = line1:getIntersectionPoints(line2)
  local angle = line1:getIntersectionAngle(line2)

  -- Graphics
  local endpoints1 = edge1segm:getContourPoints()
  local endpoints2 = edge2segm:getContourPoints()
  local lineSegm1 = Shape.createLineSegment(endpoints1[1], intersection[1])
  local lineSegm2 = Shape.createLineSegment(endpoints2[1], intersection[1])
  viewer:addShape(lineSegm1, featureDecoration)
  viewer:addShape(lineSegm2, featureDecoration)
  viewer:addShape(intersection, dotDecoration)

  angleTextDeco:setPosition(260, 140)
  viewer:addText('a = ' .. (180 - math.floor(10 * math.deg(angle)) / 10), angleTextDeco)

  local x = math.floor(intersection[1]:getX() * 10) / 10
  local y = math.floor(intersection[1]:getY() * 10) / 10
  intersectionTextDeco:setPosition(285, 75)
  viewer:addText('(x,y) = ' .. x .. ',' .. y, intersectionTextDeco)
  viewer:present()

  print('Intersection (x,y): ' ..  x .. ',' .. y .. ' Angle: ' .. (180 - math.floor(10 * math.deg(angle)) / 10))
  print('App finished.')
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register('Engine.OnStarted', main)

--End of Function and Event Scope--------------------------------------------------
