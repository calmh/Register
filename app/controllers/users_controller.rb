class UsersController < ApplicationController
  before_filter :require_administrator
  before_filter :require_users_permission, :only => [ :destroy, :new, :create, :index ]
end
