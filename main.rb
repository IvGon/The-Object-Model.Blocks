=begin ********************************************************************************************
Алгоритм работы:
В задаче сформированы справочники станций, маршрутов, поездов и вагонов.
Просмотр справочников - через команды меню: "st ls, rt ls, tr ls, wg ls".

Порядок создания новых объектов:
1. Добавить в справочник новые станции - station+/station-.
2. Создать новый маршрут - route+/route-.
3. Формирование маршрута - в маршрут добавить/удалить станцию - st add/st del/st show/st clear.
3. Создать поезд - train.
4. Формирование состава: создать вагон и добавить в состав поезда - "car"/ "car+".
                          удалить вагон из состава - "car-".
4. Назначить маршрут поезду       - "set route".
5. Информация о созданном поезде  - "info".
6. Управление поездом:
                      скорость/увеличить/уменьшить        - speed/speed up/speed down
                      принять/отправить поезд на станции  - st in/ st out.
                      прицепить/отцепить вагон к поезду   . car+/car- - 
7. Показать список поездов на станции - "st show" (Station.all)
8. Купить/вернуть билет - "ticket+ / ticket+"
9. Загрузить/разгрузить вагон - "cargo+ / cargo-"
=end 

require_relative 'instance_counter'
require_relative 'station'
require_relative 'route'
require_relative 'manufacturer'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'validate'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'interface.rb'

#********** main ******** main ****** main ******  main *********  main **************

spr_station = Station.all                                    # Справочник станций
spr_route = Route.all                                        # Справочник маршрутов
spr_train = Train.all                                        # Справочник поездов
park_wagon = Wagon.all                                       # Подвижной состав

#require_relative 'test_bd'
name_station  = ["Харьков","Белгород","Курск","Орел","Тула","Москва"]
name_station1 = ["Харьков","Лозовая","Запорожье","Синельниково","Новоалексеевка","Симферополь"]
number_train  = ["19", "20", "81", "82","67", "68"]
list_wagons   = [:ПБ, :ПЛ, :КП, :СВ,:РС,:СВ,:КП, :ПЛ, :ПЛ, :ПЛ]

num_wagon = 12345600

# ---------------------------- Сформируем список станций ------------------------------------
name_st = name_station + name_station1
name_st = name_st.uniq
name_st = name_st.sort

name_st.each do |name|   
  station = Station.new(name)
  #spr_station << station
end

# ---------------------------- Сформируем список маршрутов ------------------------------------

route = Route.new("19","Харьков","Москва")                      # Создадим объект Маршрут
route.station = name_station
#spr_route << route

route = Route.new("20","Москва","Харьков")                      
route.station = name_station.reverse
#spr_route << route

route = Route.new("81","Харьков","Симферополь")                 
route.station = name_station1
#spr_route << route

route = Route.new("82","Симферополь","Харьков")                  
route.station = name_station1.reverse                             
#spr_route << route

route = Route.new("67","Москва", "Симферополь")                  
route.station = name_station.reverse + name_station1
route.station = route.station.uniq                                # удаляет все повторяющиеся элементы 
#spr_route << route

route = Route.new("68","Симферополь","Москва")                    
route.station = name_station1.reverse + name_station
route.station = route.station.uniq
#spr_route << route

# ----------------------------- Справочник маршрутов поездов -------------------------------------
spr_route.each do |route|                                         

  print (route.name.ljust  25) + (route.to_s.ljust 27) + "\n"
  route.station.each_with_index do |st,i|  
    20.times { print " " } if i%4 == 0
    print "#{(st.ljust 15)}  "
    print "\n" if (i+1)%4 == 0
  end
  print "\n" 
end
puts

# ----------------------------- Наполним справочник поездов -------------------------------------
number_train.each do |number|   
  train = PassengerTrain.new(number,10)
  # ---------------------------- Сформируем состав из вагонов ------------------------------------
  list_wagons.each do |ind|                                 
    num_wagon += 1 
    wagon = PassengerWagon.new(num_wagon.to_s,ind)
    #wagon.as_subtype_wagon(ind)
    train.wagons << wagon
    wagon.attach_wagon_to_train(train)
    #park_wagon << wagon
  end
  
  route = spr_route.find { |item| item.name.include?(number.to_s) }

  train.assign_train_route(route)
  station = route.station[0]
  st_obj = spr_station.find { |item| item.name == station }
  #st_obj.train_arrival(train)
  #spr_train << train
end

# ----------------------------- Справочник станций ----------------------------------------------
puts
spr_station.each do |station|                                 
  print "#{station} #{station.name} \n"
end
puts

# ----------------------------- Справочник поездов ----------------------------------------------
spr_train.each do |train|    

  print (train.number.ljust  7) + (train.to_s.ljust 34) + (train.route.to_s.ljust 29)
  print (train.type.ljust 15)  +  (train.train_curent_station.to_s.ljust 15) + "\n"
end
puts

# ----------------------------- Справочник вагонов ----------------------------------------------
park_wagon.each do |wagon|     
  
  print "#{(wagon.reg_number.ljust 7)} #{(wagon.type_wagon.ljust 14)} "\
        "#{(wagon.subtype.ljust 10)} #{(wagon.location.ljust 15)}\n"
end
puts

#---------------------------- Интерфейс -----------------------------------------------------------
interface = Interface.new
interface.menu(spr_station,spr_route,spr_train,park_wagon)
