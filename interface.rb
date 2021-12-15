class Interface
#def initialize(spr_station,spr_route,spr_train,park_wagon)

#end

  include Validation
  #include Validate
  NUMBER_FORMAT = /^\d{3}-?[а-яА-Я]{2}$/i

  def find_train
      print "Номер поезда (ЦЦЦ-Пс): "
      num_train = gets.chomp.to_s
      train = Train.all.find{ |item| item.number == num_train }
      #puts "Нет такого поезда!" if train.nil?
      return train
  end

  def menu(spr_station,spr_route,spr_train,park_wagon)

   train = spr_train[0]
   station = spr_station.find { |item| item.name == "Харьков"} 
   route = train.route unless train.nil?
   cmd = "cmd"

   until cmd == "stop" do

    case cmd
    # --------------------- Просмотр справочников стаций, маршрутов, поездов --------------------------------- 

    when "wg ls"              # справочник вагонов
      print "#{"№".center 7} #{"Тип вагона".center 14} #{("Всего".center 6)} #{("Занято".center 6)} "\
            "#{("Свободно".center 6)} #{"Локация".center 15} #{"Obj".center 25}\n" 

     
      Wagon.all.each { |wagon| print "#{(wagon.reg_number.center 7)} #{(wagon.type_wagon.ljust 14)} "\
                                      "#{(wagon.capacity.to_s.center 6)} #{(wagon.loading.to_s.center 6)} "\
                                      "#{(wagon.location.center 15)} #{wagon.to_s}\n"}               
      puts  

    when "tr ls"              # ---------------------------------------- справочник поездов

      print "#{"№".center 7} #{"Тип поезда".center 16} #{"Маршрут".center 28} "\
            "#{"Станция".center 15} #{"Вагонов".center 7} #{"ObjTrain".center 32}\n" 

      Train.all.each do |train| 
        print "#{ (train.number.center 7)} #{ (train.type.center 14) } "
        if train.route.nil?
            print "#{ (train.route.to_s.center 27) } "
        else
            print "#{ (train.route.name.to_s.center 27) } "
        end
        print "#{ (train.train_curent_station.to_s.center 15) } "\
              "#{ (train.num_of_cars.to_s.center 7) } #{ (train.to_s.center 32) } \n" 
      end

    when "tr all"

      tr_block = proc { |tr| puts "Поезд № #{tr.number}  #{tr.type} #{tr.num_of_cars}" }
      wg_block = proc { |w,i|  puts "#{(i+1).to_s.rjust 12} #{w.reg_number}  #{w.type_wagon} #{w.capacity} #{w.loading}" }
      
      Station.all.each do |station| 
        puts "Станция - #{station.name} \n" 
        
        station.trains.each do |train| 
          tr_block.call(train)
          
          train.wagons_on_train(&wg_block)
        end
      end

    when "st ls"              # ---------------------------------------- справочник станций
      print " Obj_Станция       Название станции\n"
      Station.all.each { |station| print "#{station} #{station.name}  \n" }

    when "rt ls"              # ---------------------------------------- справочник vмаршрутов
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

    # -------------------------------------------------------------------------------------------------------------
    when "station+"      #--------------- создать новую станцию и внести в справочник станций
      begin
        print "Название станци: "
        name_st = gets.chomp.to_s
        st_obj = spr_station.find { |item| item.name == name_st} 
        st_obj = Station.new_if_valid(name_st) if st_obj.nil?
        raise "Неудачная попытка создания станции!" unless st_obj.valid?

      rescue StandardError => e
        puts e.message
        print "Продолжить ввод (0 - нет, 1 - да): "
        retry if gets.chomp.to_i == 1
      else
        puts "Станция #{name_st} успешно создана!"
      end

    when "station-"   # ---------------- создать новую станцию и внести в справочник станций
      begin
        print "Название станци: "
        name_st = gets.chomp.to_s
        st_obj = spr_station.find { |item| item.name == name_st} 
        raise "Нет такой станции   #{name_st}!" if st_obj.nil?
        spr_station.delete(st_obj)
      
      rescue StandardError => e
        puts e.message
        print "Продолжить ввод (0 - нет, 1 - да): "
        retry if gets.chomp.to_i == 1
      else
        puts "Станция #{name_st} успешно удалена!"
      end

    when "route+"  # -------------------------------  создать новый маршрут -------------
      begin
        print "Код маршрута: "
        cod = gets.chomp.to_s

        print "Начальная станци маршрута: "
        beg_st = gets.chomp.to_s
        st_obj = Station.new_if_valid(beg_st) if spr_station.find { |item| item.name == beg_st}.nil?
        raise "Не удалось определить начальную станцию маршрута!" if st_obj.nil?

        print "Конечная станци маршрута: "
        end_st = gets.chomp.to_s
        st_obj = Station.new_if_valid(end_st) if spr_station.find { |item| item.name == end_st}.nil?
        raise "Не удалось определить конечную станцию маршрута!" if st_obj.nil?
        route = Route.new(cod,beg_st, end_st)
        raise "Неудачная попытка создания маршрута!" unless route.valid?

      rescue StandardError => e
        puts e.message
        print "Продолжить ввод (0 - нет, 1 - да): "
        retry if gets.chomp.to_i == 1
      else
        puts "Маршрут № #{cod} от #{beg_st} до #{end_st} успешно создан!"
        puts route
      end

    # ----------------------------- добавить станцию в маршрут ------------------------
    
    when "st add"
      work_st = route.station                   # <-------указатель на массив станций
    
      print "Добавить станцию в маршруте: "     # <-------добавляемая станция
      new_st = gets.chomp.to_s
      
      if work_st.include?(new_st)
        puts "Такая станция есть в списке!"
      else
        print "Вставить после станции: "        # <-------предыдущая станция
        prev_st = gets.chomp.to_s
        if work_st.include?(prev_st)
        
          if work_st.index(prev_st) == work_st.size-1
            puts "Эта станция за конечной станцией!" 
          else
            route.add_station(new_st,prev_st)   # <------- добавить станцию
          end     
        else 
          puts "Нет такой станции в списке!" 
        end         
      end    

    # ----------------------------- удалить станцию из маршрута ------------------------
    when "st del"
      print "Удалить станцию: "
      new_st = gets.chomp.to_s
      puts "Ошибка при удалении станции #{new_st}" if route.del_station(new_st) == nil
    
    # ----------------------------- очистить маршрут -----------------------------------
    when "st clear"
      puts "Ошибка при удалении станций" if route.clear_station == nil
    
    # ----------------------------- показать станции из маршрута ------------------------
    when "rt show"
      route.show_stations

    # -----------------------------

    when "train" # ---------------------------------- создать новый состав ---------------
      begin
        print "Номер поезда (ЦЦЦ-Пс): "
        num_train = gets.chomp.to_s
        raise ArgumentError, "Номер не может быть пустым!" if num_train == ""
        #raise ArgumentError, "Неверный формат номера поезда: #{num_train} !" if num_train !~ NUMBER_FORMAT 

        print "Тип поезда (1 - грузовой, 2 - пассажирский): "
        type = gets.chomp.to_i
        raise ArgumentError, "Тип поезда должен быть - 1 или 2!" unless [1,2].include? type

        print "Количество вагонов: "
        num_cars = gets.chomp.to_i
        raise ArgumentError, "Маловато вагонов будет!" if num_cars < 1

        train = CargoTrain.new(num_train,num_cars) if type == 1
        train = PassengerTrain.new(num_train,num_cars) if type == 2
        #train = Train.new(num_train,"пасажирский",num_cars)
        raise RuntimeError, "Неудачная попытка создания объекта!" unless train.obj_valid?
      rescue  => e
        if e.class == RuntimeError
          puts "errors: " + train.errors.to_s
        else
          puts "#{e.class}: #{e.message}"
        end
        print "Продолжить ввод (0 - нет, 1 - да): "
        retry if gets.chomp.to_i == 1
      else
        if train.obj_valid?
          puts "Поезд номер #{num_train} успешно создан!"
          puts train
        else
           puts "Неудачная попытка создания объекта!" 
           puts "errors: " + train.errors.to_s
        end
      end

    when "tr find" # -------------------------выбрать и установить активным поезд №  --------
      begin
        #object = find_train
        raise "Нет такого поезда!" if (object = find_train).nil?
        rescue StandardError => e
          puts e.message
        else
          train = object
          train.info      
      end
      
    when "car" #----------------------------------- создать новый вагон ----------------------
      begin
        print "Номер вагона: "
        num_wagon = gets.chomp.to_s
        
        print "Тип вагона: (0 - грузовой, 1 - пассажирский): "
        type = gets.chomp.to_i
        raise "Недопустимый выбор: (0,1) !" unless [0,1].include?(type)
        
        if type == 1 
          print "Количество мест в вагоне: "
          capacity = gets.chomp.to_i
          wagon = PassengerWagon.new(num_wagon,capacity)
        else
          print "Емкость вагона: "
          capacity = gets.chomp.to_f
          wagon = CargoWagon.new(num_wagon,capacity) 
        end

        raise "Вагон не создан!" if wagon.nil?
        rescue StandardError => e
          puts e.message
        else 
          puts "Вагон № #{num_wagon} успешно создан!"
      end
    
    when "car+"         # ----------------------------- car+ - прицепить вагон к составу ------
      begin 
        raise "Не определен поезд!" if train.nil?
        train.speed=0     
        print "Номер вагона: "
        num_wagon = gets.chomp.to_s

        next_car = park_wagon.find { |item| item.reg_number == num_wagon} 
        raise "Нет такого вагона #{num_wagon}!" if next_car.nil?
      
        rescue StandardError => e
          puts e.message
          print "Продолжить ввод (0 - нет, 1 - да): "
          retry if gets.chomp.to_i == 1
        else
          if train.add_car(next_car)                       
            next_car.attach_wagon_to_train(train)
            puts "Вагон номер #{num_wagon} успешно прицеплен к поезду № #{num_train}!"
          end
      end

    when "car-"   # ---------------------------------- - отцепить вагон от состава -------------
      begin 
        raise "Не определен поезд!" if train.nil?
        train.speed=0     
        print "Отцепить от поезда вагон № : "
        num_wagon = gets.chomp.to_s

        next_car = park_wagon.find { |item| item.reg_number == num_wagon} 
        raise "Нет такого вагона #{num_wagon}!" if next_car.nil?
      
      rescue StandardError => e
          puts e.message
          print "Продолжить ввод (0 - нет, 1 - да): "
          retry if gets.chomp.to_i == 1
        else
          next_car.unhook_wagon_from_train(train)
          train.del_car(next_car) 
          puts "Вагон номер #{num_wagon} успешно отцеплен от поезда № #{num_train}!"
      end
    
    when "car num"  # --------------------------------- количество вагонов в поезде -------------
      train.number_cars unless train.nil?
      
    # -------------------------- Движение поезда по маршруту ---------------------    
    when "set route"   # -------------------------- route - назначить поезду маршрут --------
      raise "Не определен поезд!" if train.nil?
      train.assign_train_route(route) 

    when "tr stat"    # ----------------------------- текущая станция поезда на маршруте ----------------
      print "Номер поезда: "
      num_train = gets.chomp.to_s

      train_obj = spr_train.find { |item| item.number == num_train} 
      if train_obj.nil?
          puts "Нет такого поезда #{num_train}"
      else  
        train_obj.train_curent_station
      end
  
    when "tr next"   # ----------------------------- поезд вперед на 1 станцию по маршруту ------
      st_obj = spr_station.find { |item| item.name == train.curent_station }
      train.train_forward(st_obj) unless st_obj.nil?
      
    when "tr prev"   # ----------------------------- поезд назад на 1 станцию по маршруту --------
      st_obj = spr_station.find { |item| item.name == train.curent_station }
      train.train_back(st_obj) unless st_obj.nil?
 
    # -------------------------------------------- Движение поездов по станции ---------------------   
    
    when "ticket+" # <------------------------------- купить билет на поезд" --------------------
      begin
        offer_num = []
        print "Купить билет на поезд № : "
        num_train = gets.chomp.to_s
        train_obj = spr_train.find { |item| item.number == num_train} 
        raise "Нет такого поезда!" if train_obj.nil?
      
        rescue  => e
            puts "#{e.class}: #{e.message}"
            print "Продолжить ввод (0 - нет, 1 - да): "
            retry if gets.chomp.to_i == 1
        else
        train_obj.wagons_on_train 
        max = train_obj.num_of_cars
      begin 
        print "Выберите номер вагона: "
        num = gets.chomp.to_i
        raise "Не верный № вагона! Должен быть: 1-#{max.to_s}!" unless (1..max).include? num
        rescue  => e
            puts "#{e.class}: #{e.message}"
            print "Продолжить ввод (0 - нет, 1 - да): "
            retry if gets.chomp.to_i == 1
      end
    
      train_obj.wagons[num-1].take_a_seat    
    end

    when "ticket-" # <------------------------------- вернуть билет на поезд" --------------------
      begin
        print "Вернуть билет на поезд № : "
        num_train = gets.chomp.to_s
        train_obj = spr_train.find { |item| item.number == num_train} 
        raise "Нет такого поезда!" if train_obj.nil?

        rescue  => e
            puts "#{e.class}: #{e.message}"
            print "Продолжить ввод (0 - нет, 1 - да): "
            retry if gets.chomp.to_i == 1
        else
          train_obj.wagons_on_train 
          max = train_obj.num_of_cars           

      begin 
        print "Выберите номер вагона: "
        num = gets.chomp.to_i
        raise "Не верный № вагона! Должен быть: 1-#{max.to_s}!" unless (1..max).include? num
        rescue  => e
            puts "#{e.class}: #{e.message}"
            print "Продолжить ввод (0 - нет, 1 - да): "
            retry if gets.chomp.to_i == 1
      end
      train_obj.wagons[num-1].refund_a_seat   
    end

    when "cargo+" # <------------------------------- загрузить вагон поезда --------------------
      begin
        print "Отправить груз в поезде № : "
        num_train = gets.chomp.to_s
        train_obj = spr_train.find { |item| item.number == num_train} 

        print "Введите объем груза: "
        volume = gets.chomp.to_i
        raise "Объем груза не должен быть < 0 !" if volume < 0
        rescue  => e
            puts "#{e.class}: #{e.message}"
            print "Продолжить ввод (0 - нет, 1 - да): "
            retry if gets.chomp.to_i == 1
        else
          train_obj.wagons_on_train 
          max = train_obj.num_of_cars           

        begin 
          print "Выберите номер вагона: "
          num = gets.chomp.to_i
          raise "Не верный № вагона! Должен быть: 1-#{max.to_s}!" unless (1..max).include? num
        rescue  => e
            puts "#{e.class}: #{e.message}"
            print "Продолжить ввод (0 - нет, 1 - да): "
            retry if gets.chomp.to_i == 1
        end
      train_obj.wagons[num-1].take_volume(volume) 
    end  

    when "cargo-" # <------------------------------- раагрузить вагон поезда --------------------
      begin
        print "Разгрузить вагон в поезде № : "
        num_train = gets.chomp.to_s
        train_obj = spr_train.find { |item| item.number == num_train} 

        print "Введите объем груза: "
        volume = gets.chomp.to_i
        raise "Объем груза не должен быть < 0 !" if volume < 0
        rescue  => e
            puts "#{e.class}: #{e.message}"
            print "Продолжить ввод (0 - нет, 1 - да): "
            retry if gets.chomp.to_i == 1
        else
          train_obj.wagons_on_train 
          max = train_obj.num_of_cars  

        begin 
          print "Выберите номер вагона: "
          num = gets.chomp.to_i
          raise "Не верный № вагона! Должен быть: 1-#{max.to_s}!" unless (1..max).include? num
          rescue  => e
            puts "#{e.class}: #{e.message}"
            print "Продолжить ввод (0 - нет, 1 - да): "
            retry if gets.chomp.to_i == 1
        end
      train_obj.wagons[num-1].unload_volume(volume) 
    end  

    when "st in"  # <------------------------------- принять поезд на станцию -------------------

      print "Принять на станцию поезд № : "
      num_train = gets.chomp.to_s
      # <------------------------- найти поезд по номерув в справочнике поездов
      train_obj = spr_train.find { |item| item.number == num_train} 
      next_station = train_obj.train_next_station
      if train_obj.nil?
          puts "Нет такого поезда #{num_train}"
      else  
        if next_station.nil? == false
          train_obj.speed = 0

          st_obj = spr_station.find { |item| item.name == next_station} 
          st_obj.train_arrival(train_obj) 
        end
      end

    when "st out"   # <------------------------------ отправить поезд со станции по маршруту -------------------

      print "Отправить со станции поезд № : "
      num_train = gets.chomp.to_s
      train_obj = spr_train.detect { |item| item.number == num_train}  

      if train_obj.nil?
        puts "Нет такого поезда #{num_train}"
      else  
        cur_station = train_obj.curent_station

        if cur_station.nil? == false

          train_obj.speed = 80  
          # <----------------------- станция отправления = текущая станция остановки поезда ----------------------
          st_obj = spr_station.find { |item| item.name == cur_station} 
          st_obj.train_departure(train_obj) if st_obj.nil? == false
        end                                     
      end

    when "st show"     # <------------------------------ показать поезда на станции -----------------------------
      
      print "Показать поезда на станции : "
      name_station = gets.chomp.to_s
      st_obj = spr_station.find { |item| item.name == name_station} 
      
      print "Тип вагона: (0 - грузовой, 1 - пассажирский): "
      type = gets.chomp.to_i

      type_train = "грузовой" if type == 0 
      type_train = "пассажирский" if type == 1

      if st_obj.nil?
        puts "Нет такой станции  #{st_obj.name}!"
      else
    #    st_obj.list_of_trains(type_train)
    # - Номер поезда, тип, кол-во вагонов
          block = proc do |tr| 
            puts "#{tr.number}  #{tr.type} #{tr.num_of_cars}" if tr.type == type_train
          end
          st_obj.list_of_trains_on_station(name_station,&block)
      end

    # -------------------------- Скорость движения поезда -------------------------    

    when "tr up"  # <------------------------------- набирать скорость поезда ------
      print "Набрать скорость поезда: "
      speed = gets.chomp.to_f
      train.speed = speed
    
    when "tr down"  # <----------------------------- снизить скорость поезда -------
      print "Снизить скорость поезда до: "
      speed = gets.chomp.to_f
      train.speed = speed
    
    when "speed"   # <--------------------------- speed - определить скорость поезда
      puts train.speed
  
    # -------------------------- Информация о поезде --------------------------------
    when "info"
      train.info
     
    # -------------------------- Меню команд ---------------------------------------
    when "cmd"
      puts
      puts "Для продолжения работы введите команду:\n\n"
      puts "-------------- Справочники --------------------------"
      puts "wg ls     - справочник вагонов"
      puts "tr ls     - справочник поездов"
      puts "st ls     - справочник станций"
      puts "rt ls     - справочник маршрутов"
      puts "tr all    - справочник поездов по станциям"
      puts "------- Формирование маршрута поезда ------------------"
      puts "station+  - создать станцию"
      puts "station-  - удалить станцию"
      puts "route+    - создать маршрут"
      puts "st add    - вставить станцию в маршрут"
      puts "st del    - удалить станцию из маршрута"
      puts "rt show   - показать станции маршрута"
      puts "set route - назначить поезду маршрут"
      puts "------ Формирование состава --------------------------"
      puts "tr find   - выбрать и установить активным поезд № "
      puts "train     - создать новый состав"
      puts "car       - создать вагон"
      puts "car+      - прицепить вагон к составу"
      puts "car-      - отцепить вагон от состава"
      puts "set route - назначить поезду маршрут"
      puts "info      - показать информацию о поезде"
      puts "------- Движение поездов по станции ------------------"
      puts "ticket+/- - купить/вернуть билет на поезд" 
      puts "cargo+/-  - загрузить/выгрузить вагон поезда"
      puts "st in     - принять поезд на станцию"
      puts "st out    - отправить поезд со станции по маршруту"
      puts "st show   - показать список поездов на станции"
      puts "------- Движение поезда по  маршруту ------------------"
#      puts "tr next   - поезд вперед на 1 станцию по маршруту"
#      puts "tr prev   - поезд назад на 1 станцию по маршруту"
      puts "tr up     - набрать скорость"
      puts "tr down   - тормозить (сбрасывать скорость до нуля)"
      puts "speed     - возвратить текущую скорость" 
      puts "-----------------------------------------------------"
      puts "cmd       - вывод меню команд на экран" 
      puts "stop      - завершить работу"
      puts "---------------------------------------\n\n"
  
    when "stop"         #stop - завершение работы
      break
  
    else
      puts "Неудачная команда?"
    end

    print "cmd> "
    cmd = gets.chomp.to_s     # Выбор команды
  
   end           # end of until CMD
  end
end