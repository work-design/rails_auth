class DeviceAccount < Account
  include Auth::Model::Account::DeviceAccount
end unless defined? DeviceAccount
