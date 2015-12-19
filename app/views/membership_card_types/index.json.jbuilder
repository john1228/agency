json.array!(@membership_card_type) do |membership_card_abstract|
  json.extract! membership_card_abstract, :id, :name, :service_id, :client_id, :card_type, :price, :count, :days, :has_valid_extend_information, :valid_days, :latest_delay_days
  json.url membership_card_abstract_url(membership_card_abstract, format: :json)
end
