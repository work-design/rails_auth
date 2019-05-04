class Auth::Admin::AccountsController < Auth::Admin::BaseController
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  def index
    q_params = {}
    q_params.merge! params.permit(:user_id)
    @accounts = Account.default_where(q_params).order(id: :desc).page(params[:page])
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)

    respond_to do |format|
      if @account.save
        format.html.phone
        format.html { redirect_to admin_accounts_url }
        format.js { redirect_back fallback_location: admin_accounts_url }
        format.json { render :show }
      else
        format.html.phone { render :new }
        format.html { render :new }
        format.js { redirect_back fallback_location: admin_accounts_url }
        format.json { render :show }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    @account.assign_attributes(account_params)

    respond_to do |format|
      if @account.save
        format.html.phone
        format.html { redirect_to admin_accounts_url }
        format.js { redirect_back fallback_location: admin_accounts_url }
        format.json { render :show }
      else
        format.html.phone { render :edit }
        format.html { render :edit }
        format.js { redirect_back fallback_location: admin_accounts_url }
        format.json { render :show }
      end
    end
  end

  def destroy
    @account.destroy
    redirect_to admin_accounts_url
  end

  private
  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    params.fetch(:account, {}).permit(
      :user_id,
      :type,
      :identity,
      :confirmed,
      :primary
    )
  end

end
