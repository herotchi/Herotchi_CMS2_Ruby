class Admin::ApplicationController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :authenticate_admin_manager!
  layout "admin/layouts/application"
end
