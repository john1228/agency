class Retention < ActiveRecord::Base
  default_scope { order(report_date: :desc) }
end
