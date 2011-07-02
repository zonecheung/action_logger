class ActionLog < ActiveRecord::Base
  serialize :request_parameters
end
