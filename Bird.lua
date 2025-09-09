--[[
    Bird Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Bird is what we control in the game via clicking or the space bar; whenever we press either,
    the bird will flap and go up a little bit, where it will then be affected by gravity. If the bird hits
    the ground or a pipe, the game is over.
]]

Bird = Class{}

local TARGET_FPS = 60  -- FPS mục tiêu
local GRAVITY = 20
local JUMP_FORCE = -5

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.x = VIRTUAL_WIDTH / 2 - 8
    self.y = VIRTUAL_HEIGHT / 2 - 8

    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.dy = 0
    -- Chuẩn hóa trọng lực và lực nhảy theo FPS hiện tại
    self.gravity = GRAVITY / TARGET_FPS
    self.jumpForce = JUMP_FORCE / TARGET_FPS
end

--[[
    AABB collision that expects a pipe, which will have an X and Y and reference
    global pipe width and height values.
]]
function Bird:collides(pipe)
    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function Bird:update(dt)
    -- Điều chỉnh giá trị dựa trên FPS của dt hiện tại
    local fpsFactor = 1 / dt / TARGET_FPS

    -- Tính toán trọng lực với FPS hiện tại
    self.dy = self.dy + (self.gravity * fpsFactor) * dt

    -- Nếu nhấn phím nhảy
    if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
        -- Nhảy với lực nhảy được điều chỉnh
        self.dy = self.jumpForce * fpsFactor
        sounds['jump']:play()
    end
    
    -- Cập nhật vị trí của chim
    if self.y < 0 then
	self.y = 0
    else
        self.y = self.y + self.dy
    end
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end