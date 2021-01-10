module Auth
  class DeviceAccount < Account
    include Model::Account::DeviceAccount
  end unless defined? Auth::DeviceAccount
end
