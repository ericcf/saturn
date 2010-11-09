SATURN_BASE_ROUTE_SCOPE = case Rails.env
when "production"
  "/saturn"
else
  ""
end
