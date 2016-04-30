module MyMethods  
  def get_contest_name id
    var = @@contests['result'].find{ |item| item['id']==id }
    if var.nil?
      nil
    else
      var['name']
    end
  end
  def get_solved_num id, index
    var = @@problem_status['result']['problemStatistics'].find { |item|
      item['contestId']==id && item['index']==index}
    if var.nil?
      nil
    else
      var['solvedCount']
    end
  end

  def sort_list_by_solved_num list
    list.sort { |a, b| a[:solved_num] <=> b[:solved_num] }
  end
  def sort_list_by_date list
    list.sort { |a, b| a[:contestId] <=> b[:contestId] }
  end

  def get_list_by_id id
    status = ActiveSupport::JSON.decode(HTTParty.
      get("http://www.codeforces.com/api/user.status?handle=#{id}&from=1&count=114514").
      body)
    if status['status']=="FAILED"
      return nil
    end
    status['result'].map{ |item|
      if item['verdict']=="OK"
        {contestId: item['problem']['contestId'], name: item['problem']['name'],
        index: item['problem']['index'],
        source: get_contest_name(item['problem']['contestId']),
        solved_num: get_solved_num(item['problem']['contestId'], item['problem']['index'])
        }
      else
        nil
      end
    }.uniq.compact.delete_if{ |item| item[:source]==nil || item[:solved_num]==nil }
  end
  def fetch_data params
    your_id = params[:yourid]
    opp_id  = params[:oppid]
    
    @@contests = ActiveSupport::JSON.decode(HTTParty.
        get("http://www.codeforces.com/api/contest.list?gym=false").
        body)
    @@problem_status = ActiveSupport::JSON.decode(HTTParty.
        get("http://www.codeforces.com/api/problemset.problems").
        body)
        
    your_ac_list = get_list_by_id your_id
    opp_ac_list  = get_list_by_id opp_id
    
    if your_ac_list.nil? || opp_ac_list.nil?
      return nil
    end

    @@only_you_list= your_ac_list - opp_ac_list
    @@only_opp_list= opp_ac_list - your_ac_list
    @@both_list    = your_ac_list & opp_ac_list
    if params[:sorting_base]=="solved_num"
      @@only_you_list = sort_list_by_solved_num @@only_you_list
      @@only_opp_list = sort_list_by_solved_num @@only_opp_list
      @@both_list = sort_list_by_solved_num @@both_list
    elsif params[:sorting_base]=="date"
      @@only_you_list = sort_list_by_date @@only_you_list
      @@only_opp_list = sort_list_by_date @@only_opp_list
      @@both_list = sort_list_by_date @@both_list
    end
    [@@only_you_list, @@only_opp_list, @@both_list]
  end
end