require 'cloud127/vm'

class Vm < ActiveRecord::Base
  before_destroy :delete_vm
  before_create :create_vm

  belongs_to :image, :class_name => "Vm"
  attr_accessible :uuid, :name, :status, :template_uuid
  validates :name, :presence => true

  def self.all
    list = Cloud127::Vm.all_with_status
    list.collect {|item|
      vm = Vm.find_by_uuid(item[:uuid])
      if vm
        vm.update_attributes(item)
      else
        vm = Vm.create(item)
        vm.save
      end
      vm
    }
  end

  def start
    Cloud127::Vm.start uuid
  end

  def stop
    Cloud127::Vm.stop uuid
  end

  def details
    Cloud127::Vm.info uuid
  end

  def to_s
    name
  end

private
  def create_vm
    if !self.uuid
      self.uuid = Cloud127::Vm.clone(template_uuid, name)
    end
  end

  def delete_vm
    Cloud127::Vm.delete uuid if uuid
  end
end
