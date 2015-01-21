require 'gosu'
require 'pry'
include Gosu

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Jump 'n Run"
    @bomb, @walk1, @walk2, @jump = Gosu::Image.load_tiles(self, "images/bullet.png", 20, 20, false)
    @standing, @walk1, @walk2, @jump = Gosu::Image.load_tiles(self, "images/car.png", 38, 15, false)
    @explosion, @walk1, @walk2, @jump = Gosu::Image.load_tiles(self, "images/explosion.png", 50, 50, false)
    @points_font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @lives_font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @game_over = Gosu::Font.new(self, Gosu::default_font_name, 40)
    @restart = Gosu::Font.new(self, Gosu::default_font_name, 11)
    @car_x, @car_y = 300, 400
    set_bomb_position
    @points=0
    @lives=3
    @etime = 0
    @lost = false
  end

  def set_bomb_position
    @bomb1_x, @bomb1_y = rand(640), 0
    @bomb2_x, @bomb2_y = rand(700), 20
    @bomb3_x, @bomb3_y = rand(500), 60
    @bomb4_x, @bomb4_y = rand(400), 90
    @bomb5_x, @bomb5_y = rand(100), 0
  end

  def calculate_car_position

    case @pressed
      when 123 then @car_x = @car_x-3
      when 124 then @car_x = @car_x+3
      when 125 then @car_y = @car_y+3
      when 126 then @car_y = @car_y-3
      when 45 then restart_game
    end

  end

  def restart_game
    @car_x,@car_y=300,400
    set_bomb_position
    @lost = false
    @lives = 3  
  end

  def draw

    calculate_car_position

    unless @lost

      increment_bomb_y_position

      increment_ponits_on_missing_bomb 

      bombs = [[@bomb1_x, @bomb1_y],[@bomb2_x, @bomb2_y],[@bomb3_x, @bomb3_y],[@bomb4_x, @bomb4_y],[@bomb5_x, @bomb5_y]]

      bombs.each do |bomb|
        reduce_life_on_collision(bomb)
      end

      if @etime > 0
        @explosion.draw(@ex,@ey,1)
        @etime =@etime -1
      else
        bombs.each do |bomb|
          @bomb.draw(bomb[0], bomb[1], 0.5)
        end
          @standing.draw(@car_x, @car_y, 1)
      end
    else
      @game_over.draw("Game Over", 220, 220, 3.0, 1.0, 1.0, 0xffffffff)
      @game_over.draw("restart press 'n' ", 250, 250, 3.0, 1.0, 1.0, 0xffffffff)
    end

    @points_font.draw("Points: #{@points}", 10, 10, 3.0, 1.0, 1.0, 0xffffffff)
    @lives_font.draw("Lives: #{(1..@lives).map{|l| "X" }.join(" ")}", 450, 10, 3.0, 1.0, 1.0, 0xffffffff)
  end

  def increment_bomb_y_position
    @bomb1_y = @bomb1_y+4
    @bomb2_y = @bomb2_y+4
    @bomb3_y = @bomb3_y+4
    @bomb4_y = @bomb4_y+4
    @bomb5_y = @bomb5_y+4
  end

  def increment_ponits_on_missing_bomb
    if (@bomb1_y > 480 || @bomb2_y > 480 || @bomb3_y > 480 || @bomb4_y > 480 || @bomb5_y >480)
      set_bomb_position
      @points = @points +1
    end
  end

  def check_car_and_bomb_collision(bomb)
   if (bomb[1]+20 > @car_y && @car_y+15 > bomb[1]) && (bomb[0]+20 > @car_x && bomb[0] < @car_x+38 )
      return true 
    end    
  end

  def reduce_life_on_collision(bomb)
    if check_car_and_bomb_collision(bomb)
      @ex,@ey=@car_x,@car_y-25
      @car_x,@car_y=300,400
      set_bomb_position
      @etime = 20
      @lives= @lives-1
      game_lost
    end
  end

  def game_lost
    if @lives < 1
      @lost = true
      @points = 0
    end
  end

  def button_down(id)
    @pressed = id
  end

  def button_up(id)
    @pressed = nil
  end


end

window = GameWindow.new
window.show