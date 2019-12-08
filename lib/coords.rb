class Coords
	attr_reader :x, :y

    def initialize(x, y)
        @x, @y = x, y
    end

    def incx(increment=1)
        @x += increment
    end

    def incy(increment=1)
        @y += increment
    end

    def decx(decrement=1)
        @x -= decrement
    end

    def decy(decrement=1)
        @y -= decrement
    end

	def eql?(other)
		self == other
	end

	def hash
		[@x,@y].hash
	end

	def h
		"[#@x,#@y]"
	end

	def ==(other)
		self.class === other and
			other.x == @x and
			other.y == @y
	end

	def to_s
		"[#@x,#@y]"
	end

	def setxy(new_x,new_y)
		@x = new_x
		@y = new_y
	end

	def manhattan_distance (c1, c2)
		return abs(c1.x-c2.x) + abs(c1.y-c2.y)
	end
end

class Coords3 < Coords
	attr_reader :x, :y, :z

    def initialize(x, y, z)
        @x, @y, @z = x, y, z
    end

    def incz(increment=1)
        @z += increment
    end

    def decz(decrement=1)
        @z -= decrement
    end

	def hash
		[@x,@y,@z].hash
	end

	def h
		"[#@x,#@y,#@z]"
	end

	def ==(other)
		self.class === other and
			other.x == @x and
			other.y == @y and
			other.z == @z
	end

	def to_s
		"[Coords:#@x,#@y,#@z]"
	end
end

class Coords4 < Coords3
	attr_reader :x, :y, :z, :w

    def initialize(x, y, z, w)
        @x, @y, @z, @w = x, y, z, w
    end

    def incw(increment=1)
        @w += increment
    end

    def decw(decrement=1)
        @w -= decrement
    end

	def hash
		[@x,@y,@z,@w].hash
	end

	def h
		"[#@x,#@y,#@z,#@w]"
	end

	def ==(other)
		self.class === other and
			other.x == @x and
			other.y == @y and
			other.z == @z and
			other.w == @w
	end

	def to_s
		"[Coords:#@x,#@y,#@z,#@w]"
	end
end

