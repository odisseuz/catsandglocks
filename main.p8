--main loop

function _init()
  plr = {
    x = 15,
    y = 15, 
    spr = 1,
    vy = 0,
    ammo = 8,
    hp = 9
  }
  bullets = {}
  enemies = {} 
end

function _update()
  local bullets_to_del = {}

  if btn(⬅️) then
    plr.x -= 1
  end
  if btn(➡️) then
    plr.x += 1
  end

  plr.vy += 0.5
  plr.y += plr.vy
 
  local tile_left = mget(flr(plr.x / 8), flr((plr.y + 8) / 8))
  local tile_right = mget(flr((plr.x + 7) / 8), flr((plr.y + 8) / 8))

  if fget(tile_left, 0) or fget(tile_right, 0) then
    plr.y = flr(plr.y / 8) * 8
    plr.vy = 0

    if btnp(5) then
      plr.vy = -4
    end
  end
 
  if btnp(4) and plr.ammo > 0 then
    plr.ammo -= 1
    sfx(0)
    local b = bullet:new(plr.x + 5, plr.y + 1)
    add(bullets, b)
  end

  for b in all(bullets) do
    b:update()
    if b.x > plr.x + 128 then
      add(bullets_to_del, b)
    end
  end

  if btnp(4) and plr.ammo == 0 then
    sfx(1)
  end

  local map_x = flr((plr.x + 4) / 8)
  local map_y = flr((plr.y + 4) / 8)
  local tile_under_player = mget(map_x, map_y)
  
  if tile_under_player == 10 then
    plr.ammo += 6
    sfx(5)
    mset(map_x, map_y, 0)
  end

  for b in all(bullets_to_del) do
    del(bullets, b)
  end
end

function _draw()

  camera(plr.x - 60, 0)
  cls()
  map()
  spr(plr.spr, plr.x, plr.y)
  for b in all(bullets) do
    b:draw() 
  end
  for e in all(enemies) do
    e:draw()
  end
  
  --hud
  camera(0,0)
  print("ammo:"..plr.ammo, 5, 5, 7) 
  
end

--bullets

bullet = {
	x= 0,
	y=0,
	spr = 9,
	vx = 4
}

function bullet:new(x,y)
	local b = {}
	setmetatable(b, self)
	self.__index = self
	b.x = x
	b.y = y
	return b
end

function bullet:update()
  local tile_ahead = mget(flr((self.x + self.vx) / 8), flr((self.y + 4) / 8))

  if fget(tile_ahead, 0) then
    del(bullets, self)
  else
    self.x += self.vx
  end
end

function bullet:draw()
  spr(self.spr, self.x, self.y)
end

--enemies

enemy = {
  x = 0,
  y = 0,
  spr = 11
}

function enemy:new(x, y)
  local e = {}
  setmetatable(e, self)
  self.__index = self
  e.x = x
  e.y = y
  return e
end

function enemy:update()
end

function enemy:draw()
  spr(self.spr, self.x, self.y)
end
