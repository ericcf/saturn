RadiologyScheduler::Application.routes.draw do
  devise_for :users
  devise_for :admins

  resources :people, :except => [:new, :create, :destroy] do
    member do
      get "schedule"
    end
  end

  resources :sections, :except => :show do
    resources :memberships, :only => [:index, :new]

    resources :shift_tags, :only => [:index, :new, :create] do
      collection do
        get "search"
      end
    end

    resources :shifts, :except => [:show, :edit, :update]

    resources :vacation_requests
  end

  controller :schedules do
    scope "/schedules" do
      match "call", :to => "schedules#weekly_call", :via => "get",
        :as => :weekly_call_schedule
      match "duty", :to => "schedules#daily_duty_roster", :via => "get",
        :as => :daily_duty_schedule
    end

    scope "/sections" do
      scope :path => "/:section_id/schedule(/:year/:month/:day)" do
        get "" => "schedules#show_weekly_section",
          :as => :weekly_section_schedule
        get "edit" => "schedules#edit_weekly_section",
          :as => :edit_weekly_section_schedule
        post "" => "schedules#create_weekly_section",
          :as => :create_weekly_section_schedule
        put "" => "schedules#update_weekly_section",
          :as => :update_weekly_section_schedule
      end
    end
  end

  controller :reports do
    scope "/sections" do
      scope :path => "/:section_id/reports" do
        get "shift_totals", :as => :section_shift_totals
        scope "/people" do
          scope :path => "/:person_id" do
            match "shift_totals", :to => "reports#section_person_shift_totals",
              :via => "get", :as => :section_person_shift_totals 
          end
        end
      end
    end
  end

  root :to => "schedules#weekly_call"
end
