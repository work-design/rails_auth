module Auth
  class DeviceAccount < Account
    include Model::Account::DeviceAccount
  end
end unless defined? Auth::DeviceAccount
