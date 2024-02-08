module ApplicationHelper
  def page_class
    controller.class.name.split("::").first.sub("Controller", "").downcase
  end
end
