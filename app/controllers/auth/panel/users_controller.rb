module Auth
  class Panel::UsersController < Panel::BaseController
    before_action :set_user, only: [:show, :edit, :update, :edit_user_tags, :destroy]

    def index
      q_params = {
        'created_at-desc': 2
      }
      q_params.merge! user_filter_params

      @models = User.with_attached_avatar.includes(:oauth_users, :accounts).default_where(q_params).page(params[:page])
    end

    def panel
    end

    def new
      @user = User.new
      @user.accounts.build
    end

    def create
      @user = User.new(user_params)

      unless @user.join(params)
        render :new, locals: { model: @user }, status: :unprocessable_entity
      end
    end

    def edit_user_tags
      @user_tags = UserTag.default_where(default_params).page(params[:page])
    end

    def mock
      @user = User.find_or_initialize_by(user_uuid: params[:account])

      if @user.persisted?
        login_as @user
        render :create and return
      else
        if @user.join(user_params)
          login_as @user
          render :create and return
        end
      end
    end

    private
    def set_user
      @user = User.find(params[:id])
    end

    def user_filter_params
      q = params.permit(
        :id,
        'name-like',
        'accounts.identity',
        'last_login_at-desc'
      )
      q.merge! super if defined? super
      q
    end

    def user_permit_params
      [
        :name,
        :avatar,
        :password,
        :disabled,
        user_tag_ids: [],
        accounts_attributes: {}
      ]
    end

  end
end
