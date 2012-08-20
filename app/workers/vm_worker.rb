class VmWorker
  include Sidekiq::Worker

  def perform(vm_id)
    vm = Vm.find(vm_id)
    vm.uuid = Cloud127::Vm.clone(vm.template_uuid, vm.name)
    vm.status = "starting"
    vm["Image"] = "false"
    vm.save
    vm.start
  end
end
