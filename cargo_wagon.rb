# -------------------------- Класс CargoWagon (грузовой вагон )---------------------------------
=begin
Для грузовых вагонов:
    Добавить атрибут общего объема (задается при создании вагона)
    Добавить метод, которые "занимает объем" в вагоне (объем указывается в качестве параметра метода)
    Добавить метод, который возвращает занятый объем
    Добавить метод, который возвращает оставшийся (доступный) объем
=end
require_relative 'wagon'

class CargoWagon  < Wagon

  attr_reader :full_volume, :occupied_volume, :free_volume
  
  def initialize(reg_number,full_volume)
    type_wagon = "грузовой"
    super(reg_number,type_wagon,full_volume)
  end

  def free_volume
    full_volume - occupied_volume 
  end

  def full_volume
    self.capacity
  end

  def occupied_volume
    self.loading
  end

  def take_volume(volume)
    raise 'Свободного  места нет!' if free_volume.zero?
    self.loading += volume
  end

  def unload_volume(volume)
    occupied_volume -= volume if occupied_volume.zero?
    self.loading -= volume
  end
end
