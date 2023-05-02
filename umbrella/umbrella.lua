function register()
	--声明一个名叫"umbrella"的动画
	local ani = ldc.animation("umbrella")
	--设置动画时长为3秒
	ani:setLength(3)
	--设置frame事件触发后要调用的函数为onFrame
	ani:setEvent('frame', 'onFrame')
end

function onFrame()
	--在这里实现每一帧的动画运算

	--创建animation对象
	local ani = ldc.animation()
	--获取主文件对象
	local mainSF = ldc.subfile()
	--获取下巢lower nest的引用
	local lowerNestRef = mainSF:getRef('lower-nest.ldr')
	--创建一个向量对象
	local vec = ldc.vector()
	--将lower nest位置向量赋值给vec
	vec = lowerNestRef:getPos()
	--每运行一帧就将vec的Y坐标值减1
	vec:setY(vec:getY() - 1)
	--将修改后的坐标向量回写至lower nest
	lowerNestRef:setPos(vec)

	--获取伞骨ribs子模块的引用和subfile对象
	local ribsRef = mainSF:getRef('ribs.ldr')
	local ribsRF = ribsRef:getSubfile()

	--获取伞撑stretcher子模块的引用
	local stretcherRef = ribsRF:getRef('stretcher.ldr')
    --每运行一帧就将stretcher的Y坐标值减1，跟lower nest同步
	local stretcherVec = stretcherRef:getPos()
	stretcherVec:setY(stretcherVec:getY() - 1)
	stretcherRef:setPos(stretcherVec)

    --在ribs子模块中可以直接取stretcher的Y坐标值来计算a角
	--具体可看ribs子模块的原点坐标设置
	local L = stretcherVec:getY()/2
	--stretcher短臂长度为80
	cosa = L/80;
	sina = math.sqrt(80*80 - math.pow(L, 2))/80

	--设置stretcher的旋转矩阵，让stretcher旋转与Y轴形成夹角a
	local tmpMat = ldc.matrix()
	tmpMat:setOri(cosa, -sina, 0, sina, cosa, 0, 0, 0, 1)
	stretcherRef:setOri(tmpMat)

	local x, y, z, a, b, c, d, e, f, g, h, i = tmpMat:get()
	x, y, z = stretcherVec:get()

	local stretcherEndSF = stretcherRef:getSubfile()
	--获取stretcher末端32013零件的引用，这是stretcher子模块中的第6个零件
	local stretcherEndRef = stretcherEndSF:getRef(6)
	--获取stretcher末端32013零件的初始位置坐标
	local stretcherEndVec = stretcherEndRef:getPos()
	local stcEx, stcEy, stcEz = stretcherEndVec:get()
	--计算旋转后stretcher末端32013零件的坐标，也就是32013零件的通孔圆心坐标
	vec:setX(a*stcEx + b*stcEy + c*stcEz + x)
	vec:setY(d*stcEx + e*stcEy + f*stcEz + y)
	vec:setZ(z + 20)
	--因为建模时让rib中原点坐标上的插销与stretcher末端32013零件装配在一起
	--所以需要将rib的位置赋值为stretcher末端32013零件的位置坐标
	local ribRef = ribsRF:getRef('rib.ldr')
	ribRef:setPos(vec)

	--获取连杆link子模块的引用
	local linkRef = ribsRF:getRef('link.ldr')
	--因为link子模块的原始朝向跟stretcher一样，且运动时跟stretcher平行
	--所以可以直接跟stretcher使用相同的旋转矩阵
	linkRef:setOri(tmpMat)

	--获取连动骨linkage rib子模块的引用
	local linkageRibRef = ribsRF:getRef('linkage-rib.ldr')
	--设置linkage rib的旋转矩阵
	tmpMat:setOri(-cosa, -sina, 0, sina, -cosa, 0, 0, 0, 1)
	linkageRibRef:setOri(tmpMat)
	--因为rib子模块的原始朝向跟linkage rib一样，且运动时跟rib平行
	--所以可以直接跟rib使用相同的旋转矩阵
	ribRef:setOri(tmpMat)

	--计算link的基准坐标，即linkage rib中点位置插销的坐标
	local linkBaseSF = linkageRibRef:getSubfile()
	--获取linkage rib中点位置插销32002的引用
	local linkBaseRef = linkBaseSF:getRef(3)

	local linkBaseVec = linkBaseRef:getPos()
	local lkBx, lkBy, lkBz = linkBaseVec:get()
	local linkageRibVec = linkageRibRef:getPos()
	x, y, z, a, b, c, d, e, f, g, h, i = tmpMat:get()
	x, y, z = linkageRibVec:get()
	--计算旋转后linkage rib中点位置插销32002的坐标
	vec:setX(a*lkBx + b*lkBy + c*lkBz + x)
	vec:setY(d*lkBx + e*lkBy + f*lkBz + y)
	vec:setZ(z - 15)
	--因为建模时让link中原点坐标上的32013与linkage rib中点位置插销32002装配在一起
	--所以需要将link的位置赋值为linkage rib中点位置插销32002的位置坐标
	linkRef:setPos(vec)

	--连接ribs子模块跟lower-nest的4个插销3673也需要跟lower-nest同步运动
	for i = 1, 4
	do
		local pinRef = mainSF:getRef('3673.dat', i)
		vec = pinRef:getPos()
		vec:setY(vec:getY() - 1)
		pinRef:setPos(vec)
	end
end
register()