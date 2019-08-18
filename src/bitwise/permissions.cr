module Bitwise

  # A library to handle permissions bitwisely
  # NOTE: More examples in the documentation
  #
  #```crystal
  #require "bitwise"
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
  #
  # # More examples in the documentation
  #```
  class Permissions

    # Create instance with permission constant
    #
    #```crystal
    #require "bitwise"
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
        perm_exist? perm
        @perms << perm
      end
    end

    # Create instance with bitwise value
    #
    #```crystal
    #require "bitwise"
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
    #
    #```crystal
    #require "bitwise"
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

    # Check if instance has all the perms
    #
    #```crystal
    #require "bitwise"
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
    #perms.has_perms Permissions::READ, Permission::WRITE #=> true
    #perms.has_perms Permissions::READ, Permissions::DELETE #=> false```
    def has_perms(*perms : Int)
      perms.each do |perm|
        perm_exist? perm
        if !@perms.includes? perm
          return false
        end
      end
      return true
    end

    # Add permission to instance
    # NOTE: Add strict: true if you want that the code raise an error if perm already added
    #
    #```crystal
    #require "bitwise"
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
    #
    #perms.add_perm Permissions::DELETE, strict: true #=> ArgumentError("Perm already added")
    #```
    def add_perm(perm : Int, strict = false)
      perm_exist? perm
      if !@perms.includes? perm
        @perms << perm
      elsif strict
        raise ArgumentError.new("Perm already added")
      end
    end

    # Add multiple permissions to instance
    # NOTE: Add strict: true if you want that the code raise an error if one perm is already added
    #
    #```crystal
    #require "bitwise"
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
    #perms.add_perms Permissions::EDIT, Permissions::DELETE # Add the permissions EDIT and DELETE to the instance
    #
    #perms.add_perms Permissions::EDIT, Permissions::DELETE, strict: true #=> ArgumentError("Perm \"2\" already added")
    #```
    def add_perms(*perms : Int, strict = false)
      perms.each do |perm|
        perm_exist? perm
        if !@perms.includes? perm
          @perms << perm
        elsif strict
          raise ArgumentError.new("Perm \"#{perm}\" already added")
        end
      end
    end

    # Remove permission to instance
    # NOTE: Add strict: true if you want that the code raise an error if perm already deleted
    #
    #```crystal
    #require "bitwise"
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
    #
    #perms.del_perm Permissions::WRITE, strict: true #=> ArgumentError("Instance doesn't have this perm")
    #```
    def del_perm(perm : Int, strict = false)
      perm_exist? perm
      if @perms.includes? perm
        @perms.delete perm
      elsif strict
        raise ArgumentError.new("Instance doesn't have this perm")
      end
    end

    # Remove multiple permissions to instance
    # NOTE: Add strict: true if you want that the code raise an error if one perm is already deleted
    #
    #```crystal
    #require "bitwise"
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
    #perms.del_perm Permissions::READ, Permissions::WRITE # Remove the permission WRITE to the instance
    #
    #perms.del_perm Permissions::READ, Permissions::WRITE, strict: true #=> ArgumentError("Instance doesn't have the perm\"0\"")
    #```
    def del_perms(*perms : Int, strict = false)
      perms.each do |perm|
        perm_exist? perm
        if @perms.includes? perm
          @perms.delete perm
        elsif strict
          raise ArgumentError.new("Instance doesn't have the perm \"#{perm}\"")
        end
      end
    end

    # Return bitwise value
    # Example:
    #```crystal
    #require "bitwise"
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
    #```crystal
    #require "bitwise"
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
    #```crystal
    #require "bitwise"
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
