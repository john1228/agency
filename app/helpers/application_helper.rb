#encoding: utf-8
module ApplicationHelper
  def edit_helper(record)
    if record.new_record?
      "新增"
    else
      "编辑"
    end
  end
end