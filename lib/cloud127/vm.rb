module Cloud127::Vm
  def self.all_with_status
    raw_running = `vboxmanage list runningvms`
    return [] if $?.to_i != 0
    running_uuids = raw_running.split("\n").collect {|item| item.split(" ").last}
    self.all.collect {|instance|
      status = "stopped"
      status = "running" if running_uuids.include? instance[:uuid]
      {:name => instance[:name], :uuid => instance[:uuid], :status => status}
    }
  end

  def self.all
    raw = `vboxmanage list vms`
    return [] if $?.to_i != 0
    lines = raw.split("\n")
    lines.collect {|line| 
      uuid = line.split(" ").last
      name = line.split(" ")[0..-2].join(" ")
      {:name => eval(name), :uuid => uuid}
    }
  end

  def self.clone(uuid, name)
    new_uuid = self.generate_uuid
    `vboxmanage clonevm #{uuid} --uuid #{new_uuid} --name \"#{name}\" --register`
    return false if $?.to_i != 0
    new_uuid
  end

  def self.modify uuid, params
    args = ""
    params.each_with_key {|k,v| args << " --#{k.to_s} \"#{v}\""}
    p args
    `vboxmanage modifyvm #{uuid} #{args}`
    $?.to_i == 0
  end


  def delete
    return true if !uuid
    `vboxmanage unregistervm #{uuid} --delete`
    $?.to_i == 0
  end

  def start
    `vboxmanage startvm #{uuid} --type headless`
    $?.to_i == 0
  end

  def stop
    `vboxmanage controlvm #{uuid} poweroff`
    $?.to_i == 0
  end

  def details
    `vboxmanage showvminfo #{uuid} --machinereadable`
  end
  
  def guest_property
    `vboxmanage guestproperty enumerate #{uuid}`
  end
  
  def []= key, value
    `vboxmanage setextradata #{uuid} \"Cloud127/#{key}\" \"#{value}\"`
  end

  def [] key
    `vboxmanage getextradata #{uuid} \"Cloud127/#{key}\"`.split(" ").last
  end

private
  def self.hex_seg size
    (0..size-1).to_a.map{|a| rand(16).to_s(16)}.join
  end

  def self.generate_uuid
    "{#{hex_seg 8}-#{hex_seg 4}-#{hex_seg 4}-#{hex_seg 4}-#{hex_seg 12}}"
  end
end
