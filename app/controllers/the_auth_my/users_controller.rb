class TheAuthMy::UsersController < TheAuthMy::BaseController
  before_action :set_user

  def show
    respond_to do |format|
      format.js
      format.html
      format.json { render json: @user }
    end
  end

  def edit
  end

  def update
    @user.assign_attributes user_params

    flash[:notice] = 'User was successfully updated.'

    if @user.email_changed?
      logout
      flash[:notice] = 'Your Email changed, please login again!'
      UserMailer.email_confirm(@user.id).deliver_later
    end

    respond_to do |format|
      if @user.save
        format.js
        format.html { redirect_to my_user_url }
        format.json {
          render json: { user: @user.as_json, filename: url_for(@user.avatar) }
        }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to people_url }
      format.json { head :no_content }
    end
  end

  private
  def set_user
    @user = current_user
  end

  def user_params
    params.fetch(:user, {}).permit(:email, :name, :mobile, :avatar)
  end

end
