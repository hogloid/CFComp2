class StaticPagesController < ApplicationController
  def home
    @user_id=params[:userid]
    @user=User.new
  end
  def receive
    redirect_to "/static_pages/home/?userid=#{params[:user][:id]}"
#    home
#    render action: :home
#    render text: params[:user][:id]
  end
end
