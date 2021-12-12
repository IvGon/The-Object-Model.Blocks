=begin
**********************************************************************************************
Класс Route (Маршрут):
   Имеет название, начальную и конечную станцию, а также список промежуточных станций. 
   Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
    Может добавлять промежуточную станцию в список
    Может удалять промежуточную станцию из списка
    Может выводить список всех станций по-порядку от начальной до конечной
***********************************************************************************************
=end

class Route
  
  require_relative 'instance_counter'
  include InstanceCounter
 

  attr_reader :name
  attr_accessor :station

  @@list_routes = []

# ------------------------------------- Создать маршрут ---------------------------------------------

  def initialize(cod_route,begin_station,end_station)                     #------ Создать маршрут
    if validate!(cod_route, begin_station,  end_station)
      @name = cod_route.to_s + ":" + begin_station + "-" + end_station    #------ Название маршрута
      @station = [begin_station, end_station]        
      register_instance           
      @@list_routes.push(self)
    end
  end
  
#------------------------------------ список Obj станций ------------------------------------------------
  def self.all
    @@list_routes
  end 

  # --------------------------------- добавить станцию в маршрут --------------------------------------
  def add_station(name_st, prev_st)		                       
    
    raise "Нет такой станции #{prev_st} в списке! Для продолжения - 'exit'" unless station.include?(prev_st)
    @station.insert(@station.index(prev_st) +1, name_st)
  end

  # -------------------------------- удалить станцию из списка ---------------------------------------------

  def del_station(name_st)			                             
    
    raise "Нет такой станции #{name_st} в списке! Для продолжения - 'exit'" unless station.include?(name_st)
    raise "Попытка удалить начало маршрута!Для продолжения - 'exit'" if name_st == station.first
    raise "Попытка удалить конечную станцию маршрута!!Для продолжения - 'exit'" if name_st == station.last
    station.delete(name_st)
  end
  
  # -------------------------------- очистить маршрут ---------------------------------------------

  def clear_stations				                                  
    beg_st = @station.first
    end_st = @stationх.last
    @station.clear
    @station << beg_st << end_st
  end

  # ------------------------------- показать станции в маршруте -----------------------------------

  def show_stations				                                  
    @station.each { |name_st| print "#{name_st} " }
  end

  # ------------------------------- информация о маршруте ------------------------------------ 

  def info
    puts "Название маршрута   - #{@name}"               # название маршрута
    puts "Количество станций  - #{@station.size}"             # число станций в маршруте  
    puts "Начальная станция   - #{@station[0]}"               # начальная станция
    puts "Конечная станция    - #{@station[-1]}"              # конечная станция
    print "Состав маршрута     "
    @station.each { |name_st| print "- #{name_st}" }          # список станций на маршруте
    puts ">"
  end

  def valid?
    raise "Неудача!" unless validate!(@name,@station.first,@station.last)
    true
  rescue
    false
  end

  protected

  def validate!(*args)
      raise "Неверный номер маршрута! To exit type 'exit'" if args[0].empty?
      raise "Маршрут не может иметь меньше 2-х станций! To exit type 'exit'" if args[1].empty? || args[2].empty?
    rescue Exception => e
      puts "e.message " + e.message
      false
    else
      true
  end
end
