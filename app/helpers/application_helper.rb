module ApplicationHelper
  def controller_name
    controller.class.name.split("::").last.sub("Controller", "").downcase
  end
end
