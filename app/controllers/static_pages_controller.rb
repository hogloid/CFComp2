load 'service/controller_logic.rb'
class StaticPagesController < ApplicationController
  include MyMethods
  def home
    if !params[:yourid].nil? && !params[:oppid].nil?
      ret_value=fetch_data params
      if ret_value.nil?
        render text: "getting problem status has failed. maybe such user doesn't exist"
        return
      end
      @only_you_list=ret_value[0]
      @only_opp_list=ret_value[1]
      @both_list=ret_value[2]
    end
  end
  def sandbox
  end
  def receive
    url="/static_pages/home?yourid=#{params[:you][:id]}&oppid=#{params[:opp][:id]}"
    url+=params[:button][:sorting_base] if !params[:button].nil?
    redirect_to url
  end
end
