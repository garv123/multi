Rails.application.config.middleware.use OmniAuth::Builder do
  provider :cobot, ENV['CLIENT_ID'], ENV['CLIENT_SECRET'], scope: 'checkin checkin_tokens read read_charges read_invoices read_payment_records read_user signin write write_charges write_payment_records write_invoices'
end
