
--Start of Global Scope---------------------------------------------------------

print('AppEngine Version: ' .. Engine.getVersion())

local DELAY = 1000 -- ms between visualization steps for demonstration purpose

-- Creating viewer
local viewer = View.create("viewer2D1")

-- Setting up graphical overlay attributes
local regionDecoration = View.ShapeDecoration.create()
regionDecoration:setLineColor(230, 230, 0) -- Yellow
regionDecoration:setLineWidth(4)

local featureDecoration = View.ShapeDecoration.create()
featureDecoration:setLineColor(75, 75, 255) -- Blue
featureDecoration:setLineWidth(4)
featureDecoration:setPointType('DOT')
featureDecoration:setPointSize(5)

local dotDecoration = View.ShapeDecoration.create()
dotDecoration:setLineColor(230, 0, 0) -- Red
dotDecoration:setPointType('DOT')
dotDecoration:setPointSize(10)

local angleTextDeco = View.TextDecoration.create()
angleTextDeco:setSize(20)

local intersectionTextDeco = View.TextDecoration.create()
intersectionTextDeco:setSize(15)

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

local function main()
  local img = Image.load('resources/AngleAndIntersection.bmp')
  viewer:clear()
  local imageID = viewer:addImage(img)
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
  viewer:addShape(edge1segm, featureDecoration, nil, imageID)
  viewer:addShape(edgeRect1, regionDecoration, nil, imageID)

  -- Fitting edge2 (right)
  local edgeCenter2 = Point.create(450, 170)
  local edgeRect2 = Shape.createRectangle(edgeCenter2, 90, 40, math.rad(25))
  local angle2 = math.rad(-90 + 25)
  local edge2segm, _ = edgeFitter:fitLine(img, edgeRect2:toPixelRegion(img), angle2)
  local line2 = edge2segm:toLine()
  viewer:addShape(edge2segm, featureDecoration, nil, imageID)
  viewer:addShape(edgeRect2, regionDecoration, nil, imageID)

  -- Finding intersection and measuring angle
  local intersection = line1:getIntersectionPoints(line2)
  local angle = line1:getIntersectionAngle(line2)

  -- Graphics
  local endpoints1 = edge1segm:getContourPoints()
  local endpoints2 = edge2segm:getContourPoints()
  local lineSegm1 = Shape.createLineSegment(endpoints1[1], intersection[1])
  local lineSegm2 = Shape.createLineSegment(endpoints2[1], intersection[1])
  viewer:addShape(lineSegm1, featureDecoration, nil, imageID)
  viewer:addShape(lineSegm2, featureDecoration, nil, imageID)
  for _, point in ipairs(intersection) do
    viewer:addShape(point, dotDecoration, nil, imageID)
  end

  angleTextDeco:setPosition(260, 140)
  viewer:addText('a = ' .. (180 - math.floor(10 * math.deg(angle)) / 10), angleTextDeco, nil, imageID)

  local x = math.floor(intersection[1]:getX() * 10) / 10
  local y = math.floor(intersection[1]:getY() * 10) / 10
  intersectionTextDeco:setPosition(285, 75)
  viewer:addText('(x,y) = ' .. x .. ',' .. y, intersectionTextDeco, nil, imageID)
  viewer:present()

  print('Intersection (x,y): ' ..  x .. ',' .. y .. ' Angle: ' .. (180 - math.floor(10 * math.deg(angle)) / 10))
  print('App finished.')
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register('Engine.OnStarted', main)

--End of Function and Event Scope--------------------------------------------------
