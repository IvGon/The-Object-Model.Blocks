=begin
**********************************************************************
Класс Station (Станция):
    Имеет название, которое указывается при ее создании
    Может принимать поезда (по одному за раз)
    Может возвращать список всех поездов на станции, находящиеся в текущий момент
    Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
    Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, 
    находящихся на станции).
**********************************************************************

У класса Station:

    написать метод, который принимает блок и проходит по всем поездам на станции, передавая каждый поезд в блок.
=end

class Station
  
  require_relative 'instance_counter'
  include InstanceCounter

  @@stations = []

  attr_reader :name                   # <----------------------------- Название станции
  attr_accessor :trains               # <----------------------------- Список поездов на станции

#------------------------------------ список Obj станций ------------------------------------------------
  def self.all
    @@stations
  end 

# ----- Проблема: -------------------------------------------------------------------------------------------------
#
# При создании Object с проверкой аргументов в initialize(*аргументы):
#      если аргументы не прошли проверку, создается не валидный Object. В результате накапливается мусор.
#
# Метод self.new_if_valid(*args) - попытка прервать создание не валидного Object, если аргументы не прошли проверку,

  def self.new_if_valid(*args)
    
    @errors = InitializationInvalidError.new
    raise "Неверные аргументы!" if self.validate(*args) == false
    rescue 
      @errors.add(args[0], "Неверные аргументы!") 
      raise @errors.all.to_s
      nil
    else 
        self.new(*args)
  end

  def self.validate(*args)
      raise "Неверное название станции!" if ( args[0].empty? || args[0].length < 1 )
    rescue  
      @errors.add(args[0], "Неверное название станции - #{args[0]}!") 
      false
    else
      true
  end
# ----- Проблема: ---------------------------------------------------------------------------------------

# --------------------------------- # Cоздать станцию ----------------------------------------------------
  def initialize(name_station)                                    
      @name = name_station
      @trains = []
      @@stations.push(self)
      register_instance
  end

# -------------------------------------------------------------------------------------------------------

  def errors
    return {} unless defined?(self)
    @errors
  end
# -------------------------------------------------------------------------------------------------------
  
# --------------------------------- прибытие поезда на станцию -------------------------------------------
  def train_arrival(train)   
    trains << train
    train.arrive_at_the_station(self) # -------------------------> принять поезд на станцию (class_train)
  end

# ---------------------------------- отправление поезда со станции ---------------------------------------
  def train_departure(train)                                      
    if trains.include?(train)
       train.leave_the_station(self)  # -------------------------> отправить поезд со станции (class_train)
       trains.delete(train)
    else
       puts "Нет такого поезда на станции!"
    end
  end

# --------------------------------------------- поиск Obj станции по названию ----------------
  def find_obj(name)
    @@stations.find{|station| station.name == name}
  end  
  
# ---------------------------------- показать список поездов на станции ------------------------------------
  def list_of_trains(type)                                              
    num = 0
    raise 'На станции #{self.name} нет поездов!' if trains.empty?
    trains.each do |train| 
      if train.type == type
        print "#{"№".center 7} #{"Тип поезда".center 16} #{"Маршрут".center 28} "\
              "#{"Станция".center 15} #{"Вагонов".center 7} #{"ObjTrain".center 32}\n" if num == 0

        print "#{ (train.number.center 7)} #{ (train.type.center 14) } "
        if train.route.nil?
          print "#{ (train.route.to_s.center 27) } "
        else
            print "#{ (train.route.name.to_s.center 27) } "
        end
        print "#{ (train.train_curent_station.to_s.center 15) } "\
              "#{ (train.num_of_cars.to_s.center 7) } #{ (train.to_s.center 32) } \n"  
        num +=1
      end
    end
    return num
    rescue StandardError => e
      puts e.message
  end
  
# ---------------------------------- возвращает список поездов на станции по типу -------------------------
  #возвращает список поездов на станции по типу
  def list_of_trains_by_type(type)
    trains.select{ |train| train.type == type }.size
  end

# ----------------------------------------------------------------------------------------------------------

  def valid?
    raise "Неудача!" unless validate!(self)
    true
  rescue
    false
  end

  protected

    def validate!(object) 
      raise "Не определен attr_reader :name" unless object.methods.include? :name               # => true
      raise "Не определен instance_variables!" if object.instance_variables.size <2             #[:@name, :@trains]
      raise "Не определено название станции!" if object.instance_variable_get(:@name).size == 0 
      raise "Название станции менее 1 символа!" if object.instance_variable_get(:@name).size < 1 
    rescue Exception => e
      puts "e.message " + e.message  
      false
    else
      true
    end
end

class InitializationInvalidError < StandardError

  attr_accessor :all

  def initialize
    @all = {}
  end

  def add(name, msg)
    (@all[name] ||= []) << msg
  end

  def full_messages
    @all.map do |e|
      "#{e.first.capitalize} #{e.last.join(' & ')}. "
    end.join
  end
end

#station = Station.new("Харьков") 