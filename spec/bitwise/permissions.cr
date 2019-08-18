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

  describe "#add_perm" do
    it "should add perm" do
      perms.has_perm(Permissions::DELETE).should be_false
      perms.add_perm(Permissions::DELETE)
      perms.has_perm(Permissions::DELETE).should be_true
    end

    it "should raise an error" do
      begin
        perms.add_perm(4)
        false.should be_true
      rescue ArgumentError
        true.should be_true
      end
    end
  end

  describe "#del_perm" do
    it "should add perm" do
      perms.has_perm(Permissions::DELETE).should be_true # Added in last test
      perms.del_perm(Permissions::DELETE)
      perms.has_perm(Permissions::DELETE).should be_false
    end

    it "should raise an error" do
      begin
        perms.add_perm(4)
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
