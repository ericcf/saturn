Saturn::Application.routes.draw do

  resources :conferences, :only => [:index, :show]

  resources :physicians, :only => :index do
    collection do
      get "search"
    end
    member do
      get "schedule"
    end
    resource :physician_alias, :only => [:new, :create, :edit, :update]
  end

  resources :sections, :except => :show do
    resource :weekly_schedules
    resources :memberships, :only => :index do
      collection do
        get "manage"
        get "manage_new"
      end
    end
    resources :shift_tags, :only => [:index, :new, :create] do
      collection do
        get "search"
      end
    end
    resources :shifts, :except => [:show, :edit, :update]
    resource :rules, :only => [:show, :edit, :update]
    resources :vacation_requests, :except => :destroy do
      member do
        post "approve"
      end
    end
    resources :meeting_requests, :except => :destroy do
      member do
        post "approve"
      end
    end
    resource :admins, :only => [:show, :update]
    resource :reports, :only => :index do
      collection do
        get "search_shift_totals"
        post "shift_totals_report"
        scope "shifts/:shift_id/" do
          match "totals_by_day" => "reports#shift_totals_by_day"
        end
      end
    end
  end

  controller :schedules do
    scope "/schedules" do
      match "call", :to => "schedules#weekly_call", :via => "get",
        :as => :weekly_call_schedule
    end

    scope "/sections" do
      scope :path => "/:section_id/schedule(/:year/:month/:day)" do
        get "/" => "schedules#show_weekly_section",
          :as => :weekly_section_schedule
        get "edit" => "schedules#edit_weekly_section",
          :as => :edit_weekly_section_schedule
        post "/" => "schedules#create_weekly_section",
          :as => :create_weekly_section_schedule
        put "/" => "schedules#update_weekly_section",
          :as => :update_weekly_section_schedule
      end
    end
  end

  resources :rotations, :except => :show
  controller :residents do
    scope "/schedules/residents" do
      get "rotations", :as => :resident_rotations
    end
  end

  controller :reports do
    scope "/sections" do
      scope :path => "/:section_id/reports" do
        get "shift_totals", :as => :section_shift_totals
        scope "/people" do
          scope :path => "/:physician_id" do
            match "shift_totals", :to => "reports#section_physician_shift_totals",
              :via => "get", :as => :section_physician_shift_totals 
          end
        end
      end
    end
  end

  match "admin", :to => "admin#index", :via => "get"
  scope "/admin" do
    resources :site_statistics, :only => :index
  end

  root :to => "physicians#search"
end
