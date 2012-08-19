module VmsHelper
  def status_badge status
    return content_tag(:b, status, class: "badge") if status == "stopped"
    return content_tag(:b, status, class: "badge badge-success") if status == "running"
  end
end
