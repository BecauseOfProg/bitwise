module Bitwise

  class Permissions

    def initialize(*perms : Int)
      @perms_array = [] of Int32
      {% for perm, k in @type.constants %}
        {% if @type.constant(perm).class_name == "NumberLiteral" %}
          @perms_array << {{@type.constant(perm)}}.to_i
        {% end %}
      {% end %}
      @perms = [] of Int32
      perms.each do |perm|
        if !@perms_array.includes?(perm)
          raise ArgumentError.new("Unknown permission")
        end
        @perms << perm
      end
    end

    def initialize(bitwise : Int)
      @perms_array = [] of Int32
      {% for perm, k in @type.constants %}
        {% if @type.constant(perm).class_name == "NumberLiteral" %}
          @perms_array << {{@type.constant(perm)}}.to_i
        {% end %}
      {% end %}
      @perms = [] of Int32
      @perms_array.each do |perm|
        if (bitwise & 2**perm) == 2**perm
          @perms << perm
        end
      end
    end

    def has_perm(perm : Int)
      if !@perms_array.includes?(perm)
        raise ArgumentError.new("Unknown permission")
      end
      if @perms.includes?(perm)
        return true
      end
      return false
    end

    def to_i : Int32
      return_i = 0
      @perms.each do |perm|
        return_i += 2**perm
      end
      return return_i
    end

    def to_a : Array(Int32)
      return @perms
    end

  end

end
