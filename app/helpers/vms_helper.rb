module VmsHelper
  def status_badge status
    return content_tag(:b, status, class: "badge") if status == "stopped"
    return content_tag(:b, status, class: "badge badge-info") if status == "creating"
    return content_tag(:b, status, class: "badge badge-warning") if status == "starting"
    return content_tag(:b, status, class: "badge badge-success") if status == "running"
  end
end
