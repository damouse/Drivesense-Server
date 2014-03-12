class ChangeCoordinateNames < ActiveRecord::Migration
  def change
  	rename_column :coordinates, :lat, :latitude
  	rename_column :coordinates, :lon, :longitude
  end
end
