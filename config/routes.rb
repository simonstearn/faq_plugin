# Configuring routing for plugin's controllers.

ActionController::Routing::Routes.draw do |map|
  map.connect "projects/:project_id/faq/:faq_id", :controller => "faqs", :action => "show"
end
