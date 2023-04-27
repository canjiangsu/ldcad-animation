require("math")

function register()
	local ani = ldc.animation("umbrella")

	ani:setLength(3)
	ani:setEvent('frame', 'onFrame')
end

function onFrame()
	local ani = ldc.animation()
	local mainSF = ldc.subfile()
	local ribsRef = mainSF:getRef('ribs.ldr')
	local ribsRF = ribsRef:getSubfile()
	local lianganRef = ribsRF:getRef('liangan')
	local liangan2BaseSF = lianganRef:getSubfile()
	local liangan2BaseRef = liangan2BaseSF:getRef(3)
	local liangan2Ref = ribsRF:getRef('liangan2.ldr')
	
	local changguRef = ribsRF:getRef('changgu.ldr')
	local xiaoRef = mainSF:getRef(2)
	local yaoganRef = ribsRF:getRef('yaogan')
	local yaoganEndSF = yaoganRef:getSubfile()
	local yaoganEndRef = yaoganEndSF:getRef(6)
	local zuoRef = mainSF:getRef('jiaojiezuo')
	local zhongbanRef = mainSF:getRef('zhongban')
	local baseSF = zhongbanRef:getSubfile()
	local baseRef = baseSF:getRef(3)
	local tmpMat = ldc.matrix()

	local vec = ldc.vector()

	local yaoganVec = yaoganRef:getPos()
	yaoganVec:setY(yaoganVec:getY() - 1)
	yaoganRef:setPos(yaoganVec)

	local L = yaoganVec:getY()

	cosa = L/160;
	sina = math.sqrt(6400 - math.pow(L, 2)/4)/80
	
	vec = zuoRef:getPos()
	vec:setY(vec:getY() - 1)
	zuoRef:setPos(vec)
	
	for i = 1, 4
	do
		xiaoRef = mainSF:getRef('3673.dat', i)
		vec = xiaoRef:getPos()
		vec:setY(vec:getY() - 1)
		xiaoRef:setPos(vec)
	end

	tmpMat:setOri(cosa, -sina, 0, sina, cosa, 0, 0, 0, 1)
	yaoganRef:setOri(tmpMat)
	liangan2Ref:setOri(tmpMat)
    --print(tmpMat)
	local x, y, z, a, b, c, d, e, f, g, h, i = tmpMat:get()
	
	local yaoganEndVec = yaoganEndRef:getPos()
	local yaoEx, yaoEy, yaoEz = yaoganEndVec:get()
	vec:setX(a*yaoEx + b*yaoEy + c*yaoEz + yaoganVec:getX())
	vec:setY(d*yaoEx + e*yaoEy + f*yaoEz + yaoganVec:getY())
	vec:setZ(yaoganVec:getZ() + 20)
	changguRef:setPos(vec)
	--print(vec)
	tmpMat:setOri(-cosa, -sina, 0, sina, -cosa, 0, 0, 0, 1)
	x, y, z, a, b, c, d, e, f, g, h, i = tmpMat:get()
	
	local liangan2BaseVec = liangan2BaseRef:getPos()
	local l2Bx, l2By, l2Bz = liangan2BaseVec:get()
	local lianganVec = lianganRef:getPos()
	vec:setX(a*l2Bx + b*l2By + c*l2Bz + lianganVec:getX())
	vec:setY(d*l2Bx + e*l2By + f*l2Bz + lianganVec:getY())
	vec:setZ(lianganVec:getZ() - 15)
	liangan2Ref:setPos(vec)
	lianganRef:setOri(tmpMat)
	changguRef:setOri(tmpMat)
	
end

register()