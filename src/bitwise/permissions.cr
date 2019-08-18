module Bitwise

  # A library to handle permissions bitwisely
  # Example:
  #```require "bitwise"
  #
  #class Permissions < Bitwise::Permissions
  #  READ = 0
  #  WRITE = 1
  #  EDIT = 2
  #  DELETE = 3
  #end
  #
  #perms = Permissions.new(Permissions::READ, Permissions::WRITE)
  #
  #perms.has_perm Permissions::READ # true
  #perms.has_perm Permissions::DELETE # false
  #
  #perms.add_perm Permissions::DELETE
  #perms.has_perm Permissions::DELETE # true
  #
  #perms.del_perm Permissions::DELETE
  #perms.has_perm Permissions::DELETE # false
  #
  #perms.to_i #=> 3 | (bitwise value, easier to store)
  #
  #perms2 = Permission.new(3)
  #perms2.to_a #=> [0, 1] | (READ, WRITE)
  #```
  class Permissions

    # Create instance with permission constant
    # Example:
    #```require "bitwise"
    #
    #class Permissions < Bitwise::Permissions
    #  READ = 0
    #  WRITE = 1
    #  EDIT = 2
    #  DELETE = 3
    #end
    #
    #perms = Permissions.new(Permissions::READ, Permissions::WRITE) # Has perm READ and WRITE
    #```
    def initialize(*perms : Int)
      @perms_array = [] of Int32
      {% for perm, k in @type.constants %} # Some magic
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

    # Create instance with bitwise value
    # Example:
    #```require "bitwise"
    #
    #class Permissions < Bitwise::Permissions
    #  READ = 0
    #  WRITE = 1
    #  EDIT = 2
    #  DELETE = 3
    #end
    #
    #perms = Permissions.new(3) # Has perm READ and WRITE
    #```
    def initialize(bitwise : Int)
      @perms_array = [] of Int32
      {% for perm, k in @type.constants %} # Some magic too
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

    # Check if instance has the perm
    # Example:
    #```require "bitwise"
    #
    #class Permissions < Bitwise::Permissions
    #  READ = 0
    #  WRITE = 1
    #  EDIT = 2
    #  DELETE = 3
    #end
    #
    #perms = Permissions.new(Permissions::READ, Permissions::WRITE)
    #
    #perms.has_perm Permissions::READ # true
    #perms.has_perm Permissions::DELETE # false```
    def has_perm(perm : Int)
      perm_exist? perm
      if @perms.includes? perm
        return true
      end
      return false
    end

    # Add permission to instance
    # Example:
    #```require "bitwise"
    #
    #class Permissions < Bitwise::Permissions
    #  READ = 0
    #  WRITE = 1
    #  EDIT = 2
    #  DELETE = 3
    #end
    #
    #perms = Permissions.new(Permissions::READ, Permissions::WRITE)
    #
    #perms.add_perm Permissions::DELETE # Add the permission DELETE to the instance
    #```
    def add_perm(perm : Int)
      perm_exist? perm
      if !@perms.includes? perm
        @perms << perm
      end
    end

    # Remove permission to instance
    # Example:
    #```require "bitwise"
    #
    #class Permissions < Bitwise::Permissions
    #  READ = 0
    #  WRITE = 1
    #  EDIT = 2
    #  DELETE = 3
    #end
    #
    #perms = Permissions.new(Permissions::READ, Permissions::WRITE)
    #
    #perms.del_perm Permissions::WRITE # Remove the permission WRITE to the instance
    #```
    def del_perm(perm : Int)
      perm_exist? perm
      if @perms.includes? perm
        @perms.delete perm
      end
    end

    # Return bitwise value
    # Example:
    #```require "bitwise"
    #
    #class Permissions < Bitwise::Permissions
    #  READ = 0
    #  WRITE = 1
    #  EDIT = 2
    #  DELETE = 3
    #end
    #
    #perms = Permissions.new(Permissions::READ, Permissions::WRITE)
    #
    #perms.to_i #=> 3 # (bitwise value)
    #```
    def to_i : Int32
      return_i = 0
      @perms.each do |perm|
        return_i += 2**perm
      end
      return return_i
    end

    # Return bitwise value
    # Example:
    #```require "bitwise"
    #
    #class Permissions < Bitwise::Permissions
    #  READ = 0
    #  WRITE = 1
    #  EDIT = 2
    #  DELETE = 3
    #end
    #
    #perms = Permissions.new(Permissions::READ, Permissions::WRITE)
    #
    #perms.bitwise #=> 3 # (bitwise value)
    #```
    def bitwise : Int32
      to_i
    end

    # Return bitwise value
    # Example:
    #```require "bitwise"
    #
    #class Permissions < Bitwise::Permissions
    #  READ = 0
    #  WRITE = 1
    #  EDIT = 2
    #  DELETE = 3
    #end
    #
    #perms = Permissions.new(Permissions::READ, Permissions::WRITE)
    #
    #perms.bitwise_value #=> 3 # (bitwise value)
    #```
    def bitwise_value : Int32
      to_i
    end

    def to_a : Array(Int32)
      return @perms
    end

    private def perm_exist?(perm)
      if !@perms_array.includes?(perm)
        raise ArgumentError.new("Unknown permission")
      end
    end

  end

end
