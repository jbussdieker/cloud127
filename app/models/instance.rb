require 'cloud127/instance'

class Instance < ActiveRecord::Base
  attr_accessible :guid, :name, :status

  def self.all
    list = Cloud127::Instance.all
    list.collect {|item|
      instance = Instance.find_by_guid(item[:guid])
      if instance
        instance.update_attributes(item)
      else
        instance = Instance.create(item)
      end
      instance
    }
  end

  def start
    Cloud127::Instance.start guid
  end

  def stop
    Cloud127::Instance.stop guid
  end
end
