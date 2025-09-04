class Admin::ContactsController < ApplicationController
  before_action :set_contact, only: %i[ show status_update ]
  def index
    @q = Contact.ransack(params[:q])
    @contacts = @q.result.page(params[:page]).per(ContactConstants::ADMIN_PAGENATE_LIST_LIMIT)
  end

  def show
  end

  def status_update
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params.expect(:id))
    end
end
