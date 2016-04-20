require 'active_resource'
require 'json_formatter'
class CFApi < ActiveResource::Base
  self.site = 'http://www.codeforces.com'
#  self.prefix = '/api'
#  self.element_name = '/user.status'
  self.format = ::JsonFormatter.new(:collection_name)
  def self.find_by_id id
      self.find(:all, from:'/api/user.status', :params => {:handle => id, :from => 1, :count => 1})
  end
end
