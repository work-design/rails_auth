class DeviceAccount < Account
  include RailsAuth::Account::DeviceAccount
end unless defined? DeviceAccount
