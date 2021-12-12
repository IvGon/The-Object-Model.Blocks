# ----------------------------------------- класс пассажирский поезд -----------------------

class  PassengerTrain < Train 
  
  def initialize(number, num_of_cars)
    
  
      super(number, type="пассажирский", num_of_cars)
  end

  def type
    "пассажирский"
  end

  def wagons_on_train       
  # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ------------------Добавить аргумент вид вагона: выборка по виду вагона

    raise 'Состав поезда не сформирован!' if @wagons.empty?
    print "Поезд № #{(self.number.center 15)}\n "\
          "#{("№".center 5)} #{("Вид".center 14)} "\
          "#{("Всего".center 6)} #{("Занято".center 6)} #{("Свободно".center 6)} "\
          "#{("Тип вагона".center 14)} #{("Рег.номер".center 10)} \n" 
   
    wagons.each_with_index { |wagon,i|  print "#{(i+1).to_s.center 5} #{(wagon.subtype.center 14)} #{(wagon.total_seats.to_s.center 6)} "\
            "#{(wagon.occupied_seats.to_s.center 6)} #{(wagon.free_seats.to_s.center 6)} #{(wagon.type_wagon.center 14)} #{(wagon.reg_number.center 10)} \n" }
    rescue StandardError => e
      puts e.message
    end
  end

