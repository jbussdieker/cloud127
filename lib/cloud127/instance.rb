module Cloud127::Instance
  def self.all
    raw = `vboxmanage list vms`
    return [] if $?.to_i != 0
    raw_running = `vboxmanage list runningvms`
    return [] if $?.to_i != 0
    running_guids = raw_running.split("\n").collect {|item| item.split(" ").last}
    lines = raw.split("\n")
    lines.collect {|line| 
      name, guid = line.split(" ")
      status = "stopped"
      status = "running" if running_guids.include? guid
      {:name => eval(name), :guid => guid, :status => status}
    }
  end

  def self.modify guid, params
    args = ""
    params.each_with_key {|k,v| args << " --#{k.to_s} \"#{v}\""}
    p args
    `vboxmanage modifyvm \"#{guid}\" #{args}`
    $?.to_i == 0
  end

  def self.start guid
    `vboxmanage startvm \"#{guid}\" --type headless`
    $?.to_i == 0
  end

  def self.stop guid
    `vboxmanage controlvm \"#{guid}\" poweroff`
    $?.to_i == 0
  end
end
