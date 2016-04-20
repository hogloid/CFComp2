class StaticPagesController < ApplicationController
  def get_contest_name id
    var = @contests['result'].find{ |item| item['id']==id }
    if var.nil?
      nil
    else
      var['name']
    end
  end
  def get_solved_num id, index
    var = @problem_status['result']['problemStatistics'].find { |item|
      item['contestId']==id && item['index']==index}
    if var.nil?
      nil
    else
      var['solvedCount']
    end
  end
    
    
  def get_list_by_id id
    @status = ActiveSupport::JSON.decode(HTTParty.
      get("http://www.codeforces.com/api/user.status?handle=#{id}&from=1&count=114514").
      body)
    @status['result'].map{ |item|
      if item['verdict']=="OK"
        {contestId: item['problem']['contestId'], name: item['problem']['name'],
        index: item['problem']['index'],
        source: get_contest_name(item['problem']['contestId']),
        solved_num: get_solved_num(item['problem']['contestId'], item['problem']['index'])
        }
      else
        nil
      end
    }.uniq.compact.delete_if{ |item| item[:source]==nil }
      
  end

  def home
    require 'httparty'
    @your_id = params[:yourid]
    @opp_id  = params[:oppid]
    if !@your_id.nil? && !@your_id.empty?
      @contests = ActiveSupport::JSON.decode(HTTParty.
        get("http://www.codeforces.com/api/contest.list?gym=false").
        body)
      @problem_status = ActiveSupport::JSON.decode(HTTParty.
        get("http://www.codeforces.com/api/problemset.problems").
        body)

      @your_ac_list = get_list_by_id @your_id
      @opp_ac_list  = get_list_by_id @opp_id
      @only_you_list= @your_ac_list - @opp_ac_list
      @only_opp_list= @opp_ac_list - @your_ac_list
      @both_list    = @your_ac_list & @opp_ac_list
    end
  end
  def receive
    redirect_to "/static_pages/home?yourid=#{params[:you][:id]}&oppid=#{params[:opp][:id]}"
  end
end