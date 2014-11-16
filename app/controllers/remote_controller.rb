class TripsCoordinatesController < ApplicationController 
  #receive the device's "polled" IP address, power levels, and UDID
  def device_log
    body = request.body.read()
    json = JSON.parse(body)

    device = DeviceLog.find_by_udid(json['udid'])
    if not device
      device = DeviceLog.create(udid: json['udid'])
    end
 
    device.ip_address = json['ip_address']
    device.power = json['power']

    if device.save 
        render json: {status: :created, message: 'log created successfully'}
    else
        render json: {status: :unprocessable_entity, errors: device.errors}
    end
  end

  def index
    @devices = DeviceLog.all
  end
end