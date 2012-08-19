class VmWorker
  include Sidekiq::Worker

  def perform(vm_id)
    puts 'Doing hard work'
    vm = Vm.find(vm_id)
    vm.uuid = Cloud127::Vm.clone(vm.template_uuid, vm.name)
    vm.status = "stopped"
    vm.image = "false"
    vm.save
    puts 'Hard work done!'
  end
end
