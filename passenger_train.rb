# ----------------------------------------- класс пассажирский поезд -----------------------

class  PassengerTrain < Train 
  
  def initialize(number, num_of_cars)
    
      super(number, type="пассажирский", num_of_cars)
  end

  def wagons_on_train       

    raise 'Состав поезда не сформирован!' if @wagons.empty?

    print "Поезд № #{(self.number.center 15)}\n "\
          "#{("№".center 5)} "\
          "#{("Всего".center 6)} #{("Занято".center 6)} #{("Свободно".center 6)} "\
          "#{("Тип вагона".center 14)} #{("Рег.номер".center 10)} \n" 
   
    block = proc do |wagon,i|
      print "#{(i+1).to_s.rjust 5} #{(wagon.total_seats.to_s.center 6)} "\
           "#{(wagon.occupied_seats.to_s.center 6)} #{(wagon.free_seats.to_s.center 6)} #{(wagon.type_wagon.center 14)} #{(wagon.reg_number.center 10)} \n" 
    end 
    super(&block)  

    rescue StandardError => e
      puts e.message
  end
end

