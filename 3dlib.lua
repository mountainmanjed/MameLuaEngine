--based off the armored core wall hack lua script
--you will need to know how to set up a camera matrix
--or read the matrix from the game

--function getcamera() needs to return
--{Pos		= Vector(camx,camy,camz)
-- Right	= Vector(camscaled[],camscaled[],camscaled[])
-- Up		= Vector(camscaled[],camscaled[],camscaled[])
-- Forward	= Vector(camscaled[],camscaled[],camscaled[])};


function maketable_i16(location,num)
	local table = {};
	for v=0,num,1 do
		table[v] = mem:read_i16(location+(v*2))
	end
	return table;
end

function maketable_u16(location,num)
	local table = {};
	for v=0,num,1 do
		table[v] = mem:read_u16(location+(v*2))
	end
	return table;
end

function maketable_i32(location,num)
	local table = {};
	for v=0,num,1 do
		table[v] = mem:read_i32(location+(v*4))
	end
	return table;
end

function maketable_u32(location,num)
	local table = {};
	for v=0,num,1 do
		table[v] = mem:read_u32(location+(v*4))
	end
	return table;
end
--VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
--Wireframe functions
--VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
function rect_draw_lines(box,color)
	gui:draw_line(box[1].X,box[1].Y,box[2].X,box[2].Y,color);
	gui:draw_line(box[1].X,box[1].Y,box[4].X,box[4].Y,color);
	gui:draw_line(box[1].X,box[1].Y,box[5].X,box[5].Y,color);
	gui:draw_line(box[2].X,box[2].Y,box[3].X,box[3].Y,color);
	gui:draw_line(box[2].X,box[2].Y,box[6].X,box[6].Y,color);
	gui:draw_line(box[3].X,box[3].Y,box[4].X,box[4].Y,color);
	gui:draw_line(box[3].X,box[3].Y,box[7].X,box[7].Y,color);
	gui:draw_line(box[4].X,box[4].Y,box[8].X,box[8].Y,color);
	gui:draw_line(box[6].X,box[6].Y,box[5].X,box[5].Y,color);
	gui:draw_line(box[6].X,box[6].Y,box[7].X,box[7].Y,color);
	gui:draw_line(box[8].X,box[8].Y,box[5].X,box[5].Y,color);
	gui:draw_line(box[8].X,box[8].Y,box[7].X,box[7].Y,color);	
end

function sphere_draw_lines(s,color)
	--gui:draw_line(s[1].X,s[1].Y,s[3].X,s[3].Y,color);
	--gui:draw_line(s[1].X,s[1].Y,s[4].X,s[4].Y,color);
	--gui:draw_line(s[1].X,s[1].Y,s[5].X,s[5].Y,color);
	--gui:draw_line(s[1].X,s[1].Y,s[6].X,s[6].Y,color);
	--gui:draw_line(s[1].X,s[1].Y,s[7].X,s[7].Y,color);
	--gui:draw_line(s[1].X,s[1].Y,s[8].X,s[8].Y,color);
	
end

function diamond_draw_lines(s,color)
	gui:draw_line(s[1].X,s[1].Y,s[3].X,s[3].Y,color);
	gui:draw_line(s[1].X,s[1].Y,s[4].X,s[4].Y,color);
	gui:draw_line(s[1].X,s[1].Y,s[5].X,s[5].Y,color);
	gui:draw_line(s[1].X,s[1].Y,s[6].X,s[6].Y,color);
	gui:draw_line(s[3].X,s[3].Y,s[5].X,s[5].Y,color);
	gui:draw_line(s[3].X,s[3].Y,s[6].X,s[6].Y,color);
	gui:draw_line(s[4].X,s[4].Y,s[5].X,s[6].Y,color);
	gui:draw_line(s[4].X,s[4].Y,s[5].X,s[6].Y,color);
	gui:draw_line(s[2].X,s[2].Y,s[3].X,s[3].Y,color);
	gui:draw_line(s[2].X,s[2].Y,s[4].X,s[4].Y,color);
	gui:draw_line(s[2].X,s[2].Y,s[5].X,s[5].Y,color);
	gui:draw_line(s[2].X,s[2].Y,s[6].X,s[6].Y,color);
end

--VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
--draw3d function
--VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
function draw3d_line(x1,y1,z1,x2,y2,z2,color)
	fpos = {};
	pos1 = Vector(x1,y1,z1);
	pos2 = Vector(x2,y2,z2);
	camera = getcamera();

	table.insert(fpos,ProjectVertex(pos1,camera,false,false)); 
	table.insert(fpos,ProjectVertex(pos2,camera,false,false)); 

	gui:draw_line(fpos[1].X,fpos[1].Y,fpos[2].X,fpos[2].Y,color);
end

function draw3d_axis(x,y,z,size)
	draw3d_line(x-size,y,z,x+size,y,z,0xffff1111);
	draw3d_line(x,y-size,z,x,y+size,z,0xff11ff11);
	draw3d_line(x,y,z-size,x,y,z+size,0xff1111ff);

end

function draw3d_sphere(x,y,z,radius,color)
	pv = {};
	cam = getcamera();
	pv.Pos = Vector(x,y,z);
	shape = sphere_projection(cam,pv,radius);
	--sphere_draw_lines(shape,color);
end

function draw3d_simple(x,y,z,radius,color)
	pv = {};
	cam = getcamera();
	pv.Pos = Vector(x,y,z);
	shape = diamond_projection(cam,pv,radius);
	diamond_draw_lines(shape,color);
end

function draw3d_box(x,y,z,sizew,sizeh,color)
	pv = {};
	cam = getcamera();
	pv.Pos = Vector(x,y,z);
	AABB = box_projection(cam, pv,sizew,sizeh);
	rect_draw_lines(AABB,color)
end

--VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
--Projection math
--VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

function sphere_projection(camera,projVert,r)
	local shape = {};
	local pos = projVert.Pos;
	
	--northpole
	Vert = vector(pos.X + r);
		table.insert(shape,ProjectVertex(Vert, camera, false, false));  
	
	--southpole
	Vert = vector(pos.X - r);
		table.insert(shape,ProjectVertex(Vert, camera, false, false));  

	--for lg=0,3,1 do
	--for ln
	--end

	for _,Vert in ipairs(shape) do
		if Vert.Z < 0 then
			Vert.X = -Vert.X;
			Vert.Y = -Vert.Y;
			Vert.Z = 0;
		end
	end

	return shape;
end


function diamond_projection(camera,projVert,r)
	local shape = {};
	local pos = projVert.Pos;
	
	--northpole
	Vert = Vector(pos.X,pos.Y+r,pos.Z);
		table.insert(shape,ProjectVertex(Vert, camera, false, false));  
	
	--southpole
	Vert = Vector(pos.X,pos.Y-r,pos.Z);
		table.insert(shape,ProjectVertex(Vert, camera, false, false));  
	
	Vert = Vector(pos.X+r,pos.Y,pos.Z+r)
		table.insert(shape,ProjectVertex(Vert, camera, false, false));  
	Vert = Vector(pos.X-r,pos.Y,pos.Z-r)
		table.insert(shape,ProjectVertex(Vert, camera, false, false));  
	Vert = Vector(pos.X+r,pos.Y,pos.Z-r)
		table.insert(shape,ProjectVertex(Vert, camera, false, false));  
	Vert = Vector(pos.X-r,pos.Y,pos.Z+r)
		table.insert(shape,ProjectVertex(Vert, camera, false, false));  



	for _,Vert in ipairs(shape) do
		if Vert.Z < 0 then
			Vert.X = -Vert.X;
			Vert.Y = -Vert.Y;
			Vert.Z = 0;
		end
	end

	return shape;
end

function box_projection(camera, projVert, w, h)
	local aabb = {};
	for j=0,1,1 do
		local pos = projVert.Pos;
		local floorY = pos.Y + h/2;                                     -- Entity pos is reset to the floor, where it actually is
		local b = Vector(pos.X + w, floorY-h*j, pos.Z+w);
		table.insert(aabb, ProjectVertex(b, camera, false, false));     -- Calculate 4+4 vertices to create the AABB.

		b = Vector(pos.X + w, floorY-h*j, pos.Z-w);
		table.insert(aabb, ProjectVertex(b, camera, false, false));

		b = Vector(pos.X - w, floorY-h*j, pos.Z-w);
		table.insert(aabb, ProjectVertex(b, camera, false, false));

		b = Vector(pos.X - w, floorY-h*j, pos.Z+w);
		table.insert(aabb, ProjectVertex(b, camera, false, false));
	end

	-- Laughably bad """clipping""" trick to make sure that AABB points that end up behind the camera due to entity points that are already behind
	-- the near clipping plane don't get mirrored onto the screen. This works badly, but it *works* and requires 0 effort.
	for _,b in ipairs(aabb) do
		if b.Z < 0 then
			b.X = -b.X;
			b.Y = -b.Y;
			b.Z = 0;
		end
	end

	return aabb;
end



function ProjectVertex(point, camera, cullOffscreen, cullBehind)
	cullOffscreen = cullOffscreen and true;
	cullBehind = cullBehind and true;
	local p = VectorSubtract(point, camera.Pos);                        -- Move to camera space

	local IR3 =  DotProduct(camera.Forward, p);                         -- Project point's distance to the camera
	if cullBehind and (IR3 <= HALF_H) then return nil end;              -- Exit early if the point is too close to the camera
	local pScale = H/IR3;                                               -- Perspective adjustment

	local IR1 =  DotProduct(camera.Right, p);                           -- Project point's x position to screen's right vector
	local SX = X_OFF + IR1 * pScale;                                    -- Adjust projected point for perspective
	if cullOffscreen and (0 > SX or SX > X_MAX) then return nil end;    -- Exit early if the point is outside of the screen

	local IR2 =  DotProduct(camera.Up, p);                              -- Project point's y position to the screen's up vector
	local SY = Y_OFF + IR2 * pScale;                                    -- Adjust projected point for perspective
	if cullOffscreen and (0 > SY or SY > Y_MAX) then return nil end;    -- Exit early if the point is outside of the screen

	return {X=SX, Y=SY, Z=IR3};
end

function Vector(x,y,z)
	return {X=x,Y=y,Z=z}
end

function VectorLength(v)
	return math.sqrt(v.X * v.X + v.Y * v.Y + v.Z * v.Z);
end

function VectorSubtract(v, w)
	return Vector(v.X - w.X, v.Y - w.Y, v.Z - w.Z);
end

function ScaleVector(v, a)
	return Vector(v.X * a, v.Y * a, v.Z * a);
end

function DotProduct(v, w)
	return v.X * w.X + v.Y * w.Y + v.Z * w.Z;
end

function ScaleMatrix(m,a,s)
	local scaledMatrix = {};
	for i=0,s,1 do
		scaledMatrix[i] = m[i] * a;
	end
	return scaledMatrix;
end

-- LINEAR ALGEBRA (IN-PLACE)
function VectorSubtract_IP(v,w)
	v.X = v.X - w.X;
	v.Y = v.Y - w.Y;
	v.Z = v.Z - w.Z;
end

function ScaleVector_IP(v,a)
	v.X = v.X * a;
	v.Y = v.Y * a;
	v.Z = v.Z * a;
end
