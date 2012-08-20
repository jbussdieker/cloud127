require 'cloud127/vm'

class Vm < ActiveRecord::Base
  include Cloud127::Vm

  before_destroy :delete
  after_create :create_vm

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
    super
  end

  def to_s
    name
  end

private
  def create_vm
    if !self.uuid
      status = "creating"
      save
      VmWorker.perform_async(self.id)
    end
  end
end
