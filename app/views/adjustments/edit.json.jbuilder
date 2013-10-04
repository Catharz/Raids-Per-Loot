json.adjustment do
  json.extract! @adjustment, :adjustable_id, :adjustable_type, :adjustment_date, :adjustment_type, :amount,
                :created_at, :id, :reason, :updated_at
end