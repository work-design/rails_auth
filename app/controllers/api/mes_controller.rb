class Api::MesController < Api::TheAuthController


  def show
    render json: current_user.as_json
  end

  def edit
  end

  def update
    if @me.update(me_params)
      redirect_to @me, notice: 'Me was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @me.destroy
    redirect_to mes_url, notice: 'Me was successfully destroyed.'
  end


end
