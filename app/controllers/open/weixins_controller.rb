class WeixinsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_weixin_legality

  def show
    render :text => params[:echostr]
  end

  def new

  end

  def create

    if params[:xml][:MsgType] == "text"
      render 'news', :formats => :xml
    end


  end

  private

  def check_weixin_legality
    array = ['qincai', params[:timestamp], params[:nonce]].sort
    render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end


end
