json.array!(@user_registrations) do |user_registration|
  json.extract! user_registration, :id, :reg_type, :avatar, :name, :gender, :service_id, :client_id, :mobile, :source, :birthday, :address, :remark
  json.url user_registration_url(user_registration, format: :json)
end
