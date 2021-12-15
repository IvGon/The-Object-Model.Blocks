# -------------------------- Класс PassengerWagon (пассажирский вагон )---------------------------
=begin
    Добавить атрибут общего кол-ва мест (задается при создании вагона)    total number of seats
    Добавить метод, который "занимает места" в вагоне (по одному за раз)
    Добавить метод, который возвращает кол-во занятых мест в вагоне
    Добавить метод, возвращающий кол-во свободных мест в вагоне.          number of free seats
=end
require_relative 'wagon'

class PassengerWagon < Wagon
  
  attr_reader :total_seats, :free_seats, :occupied_seats

  def initialize(reg_number,total_seats)
    type = "пассажирский"
    super(reg_number,type,total_seats)
  end

  def total_seats
    self.capacity
  end

  def occupied_seats
    self.loading
  end


  def free_seats
    total_seats - occupied_seats
  end

  def take_a_seat
    raise 'Свободных мест нет' if free_seats.zero?
    #occupied_seats =1 #+= 1
    self.loading +=1
  end

  def refund_a_seat
    raise 'Занятых мест нет!' if occupied_seats.zero?
    self.loading -= 1 
  end
end
