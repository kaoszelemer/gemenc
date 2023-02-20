local ShotGun = Weapon:extend('ShotGun')

function ShotGun:init()

    Weapon.init(
    self,
    player.x + 4,
    player.y,
    love.graphics.newImage("assets/sgitem.png"),
    3
  
)


end



function ShotGun:shoot(x, y)
    local instance = SOUNDS.bullet:play()
    local angle = 45 -- in degrees
    local bullet_distance = 16
    if player.munition > 4 then
        player.munition = player.munition - 4
        for i = 1, 5 do
            local offset_x = bullet_distance * math.cos(math.rad(angle)) * -(i - 3)
            local offset_y = bullet_distance * math.sin(math.rad(angle)) * -(i - 3)
            table.insert(BULLETS, Bullet(player.x + 4 , player.y + 4 , x + offset_x, y + offset_y, player))
        end
    end
end




return ShotGun