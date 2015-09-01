Rails.application.routes.draw do

  match 'new_action', :to => 'foreman_theme/hosts#new_action'

end
