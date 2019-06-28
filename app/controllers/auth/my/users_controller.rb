class Auth::My::UsersController < Auth::My::BaseController
  before_action :set_user

  def show
  end

  def edit
  end

  def update
    @user.assign_attributes user_params
  
    flash[:notice] = 'User was successfully updated.'
  
    if @user.email_changed?
      logout
      flash[:notice] = 'Your Email changed, please login again!'
      UserMailer.email_confirm(@user.email).deliver_later
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
    redirect_to api_me_url
  end

  private
  def set_user
    @user = current_user
  end

  def user_params
    params.fetch(:user, {}).permit(
      :name,
      :email,
      :avatar,
      :mobile,
      :locale,
      :nation,
      :timezone
    )
  end

end
