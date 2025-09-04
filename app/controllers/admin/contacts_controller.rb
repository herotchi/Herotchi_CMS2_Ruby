class Admin::ContactsController < ApplicationController
  before_action :set_contact, only: %i[ show update ]
  def index
    @q = Contact.ransack(params[:q])
    @contacts = @q.result.page(params[:page]).per(ContactConstants::ADMIN_PAGENATE_LIST_LIMIT)
  end

  def show
  end

  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to [ :admin, @contact ], notice: t("flash.actions.update.success", resource: Contact.model_name.human) }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params.expect(:id))
    end

    def contact_params
      params.expect(contact: [ :status ])
    end
end
