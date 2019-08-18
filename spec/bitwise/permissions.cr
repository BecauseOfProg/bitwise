require "../spec_helper"

class Permissions < Bitwise::Permissions
  READ = 0
  WRITE = 1
  EDIT = 2
  DELETE = 3
end

describe Bitwise::Permissions do
  perms : Permissions?

  describe "#new" do
    it "should be a Permissions object" do
      perms = Permissions.new(Permissions::READ, Permissions::WRITE)
      perms.class.should eq Permissions
    end
    it "should be create a Permissions object with bitwise" do
      perms = Permissions.new(7)
      perms.class.should eq Permissions
      perms.has_perm(Permissions::READ).should be_true
      perms.has_perm(Permissions::WRITE).should be_true
      perms.has_perm(Permissions::EDIT).should be_true
      perms.has_perm(Permissions::DELETE).should be_false
    end
    it "should raise an error" do
      begin
        Permissions.new(Permissions::READ, 4)
        false.should be_true
      rescue ArgumentError
        true.should be_true
      end
    end
  end

  perms = Permissions.new(Permissions::READ, Permissions::WRITE)

  describe "#has_perm" do
    it "should be true" do
      perms.has_perm(Permissions::READ).should be_true
    end
    it "should be false" do
      perms.has_perm(Permissions::DELETE).should be_false
    end
    it "should raise an error" do
      begin
        perms.has_perm(4)
        false.should be_true
      rescue ArgumentError
        true.should be_true
      end
    end
  end

  describe "#has_perms" do
    it "should be true" do
      perms.has_perms(Permissions::READ, Permissions::WRITE).should be_true
    end
    it "should be false" do
      perms.has_perms(Permissions::READ, Permissions::DELETE).should be_false
    end
    it "should raise an error" do
      begin
        perms.has_perms(4, 5)
        false.should be_true
      rescue ArgumentError
        true.should be_true
      end
    end
  end

  describe "#add_perm" do
    it "should add perm" do
      perms.has_perm(Permissions::DELETE).should be_false
      perms.add_perm(Permissions::DELETE)
      perms.has_perm(Permissions::DELETE).should be_true
    end

    it "should add perm (strict)" do
      perms.has_perm(Permissions::EDIT).should be_false
      perms.add_perm(Permissions::EDIT, strict: true)
      perms.has_perm(Permissions::EDIT).should be_true
    end

    it "should raise an error" do
      begin
        perms.add_perm(4)
        false.should be_true
      rescue ArgumentError
        true.should be_true
      end
    end

    it "should raise an error (strict)" do
      perms.has_perm(Permissions::EDIT).should be_true
      begin
        perms.add_perm(Permissions::EDIT, strict: true)
        false.should be_true
      rescue ArgumentError
        true.should be_true
      end
    end
  end

  describe "#del_perm" do
    it "should del perm" do
      perms.has_perm(Permissions::DELETE).should be_true # Added in last test
      perms.del_perm(Permissions::DELETE)
      perms.has_perm(Permissions::DELETE).should be_false
    end

    it "should del perm (strict)" do
      perms.has_perm(Permissions::EDIT).should be_true # Added in last test
      perms.del_perm(Permissions::EDIT, strict: true)
      perms.has_perm(Permissions::EDIT).should be_false
    end

    it "should raise an error" do
      begin
        perms.del_perm(4)
        false.should be_true
      rescue ArgumentError
        true.should be_true
      end
    end

    it "should raise an error (strict)" do
      perms.has_perm(Permissions::EDIT).should be_false
      begin
        perms.del_perm(Permissions::EDIT, strict: true)
        false.should be_true
      rescue ArgumentError
        true.should be_true
      end
    end
  end

  describe "#add_perms" do
    it "should add multiple perms" do
      perms.has_perm(Permissions::EDIT).should be_false
      perms.has_perm(Permissions::DELETE).should be_false
      perms.add_perms(Permissions::EDIT, Permissions::DELETE)
      perms.has_perm(Permissions::EDIT).should be_true
      perms.has_perm(Permissions::DELETE).should be_true
    end

    it "should raise an error" do
      begin
        perms.add_perms(4, 5)
        false.should be_true
      rescue ArgumentError
        true.should be_true
      end
    end

    it "should raise an error (strict)" do
      perms.has_perm(Permissions::EDIT).should be_true
      perms.has_perm(Permissions::DELETE).should be_true
      begin
        perms.add_perms(Permissions::EDIT, Permissions::DELETE, strict: true)
        false.should be_true
      rescue ArgumentError
        true.should be_true
      end
    end
  end

  describe "#del_perms" do
    it "should del multiple perms" do
      perms.has_perm(Permissions::EDIT).should be_true # Added in last test
      perms.has_perm(Permissions::DELETE).should be_true
      perms.del_perms(Permissions::EDIT, Permissions::DELETE)
      perms.has_perm(Permissions::EDIT).should be_false
      perms.has_perm(Permissions::DELETE).should be_false
    end

    it "should raise an error" do
      begin
        perms.del_perms(4, 5)
        false.should be_true
      rescue ArgumentError
        true.should be_true
      end
    end

    it "should raise an error (strict)" do
      perms.has_perm(Permissions::EDIT).should be_false
      begin
        perms.del_perms(Permissions::EDIT, Permissions::DELETE, strict: true)
        false.should be_true
      rescue ArgumentError
        true.should be_true
      end
    end
  end

  describe "#to_i (doesn't work if #add_perm or #del_perm failed)" do
    it "should return bitwise" do
      perms.to_i.should eq 3
    end
  end

  describe "#bitwise (doesn't work if #add_perm or #del_perm failed)" do
    it "should return bitwise" do
      perms.bitwise.should eq 3
    end
  end

  describe "#bitwise_value (doesn't work if #add_perm or #del_perm failed)" do
    it "should return bitwise" do
      perms.bitwise_value.should eq 3
    end
  end

  describe "#to_a (doesn't work if #add_perm or #del_perm failed)" do
    it "should return array of perms" do
      perms.to_a.should eq [0, 1]
    end
  end

end
