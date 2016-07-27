require 'rails_helper'

RSpec.describe ServiceSetting, type: :model do
  let!(:services) {
    services = []
    services << ServiceSetting.create(name: 'api-gateway', token: '123456789', url: 'http://localhost:8000')
    services << ServiceSetting.create(name: 'ServiceSetting data two')
    services << ServiceSetting.create(name: 'ServiceSetting data one')
    services
  }

  let!(:service_first)  { services[0] }
  let!(:service_second) { services[1] }
  let!(:service_third)  { services[2] }

  it 'Is valid' do
    expect(service_first).to            be_valid
    expect(service_first.token).to      be_present
    expect(service_first.url).to        be_present
    expect(service_first.updated_at).to be_present
    expect(service_first.created_at).to be_present
  end

  it 'Do not allow to create service without name' do
    service_reject = ServiceSetting.new(token: '')

    service_reject.valid?
    expect {service_reject.save!}.to raise_error(Mongoid::Errors::Validations)
  end

  it 'Do not allow to create service with name douplications' do
    expect(service_first).to be_valid
    service_reject = ServiceSetting.new(name: 'api-gateway')

    service_reject.valid?
    expect {service_reject.save!}.to raise_error(Mongoid::Errors::Validations)
  end
end
