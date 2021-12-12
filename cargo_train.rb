# ----------------------------------------- класс грузовой поезд ----------------------------

class CargoTrain < Train
  
  def initialize(number, num_of_cars)

    super(number, type="грузовой", num_of_cars)
  end 

  def type
    "грузовой"
  end  

  def wagons_on_train

    raise 'Состав поезда не сформирован!' if @wagons.empty?
    print "Поезд № #{(self.number.center 15)}\n "\
          "#{("№".center 5)} #{("Вид".center 14)} "\
          "#{("Всего".center 6)} #{("Занято".center 6)} #{("Свободно".center 6)} "\
          "#{("Тип вагона".center 14)} #{("Рег.номер".center 10)} \n" 

    wagons.each_with_index do |wagon,i| 
          print "#{(i+1).to_s.rjust 5} #{(wagon.subtype.center 14)} "\
                "#{(wagon.full_volume.to_s.ljust 6)} #{(wagon.occupied_volume.to_s.ljust 6)} #{(wagon.free_volume.to_s.ljust 6)} "\
                "#{(wagon.type_wagon.center 14)} #{(wagon.reg_number.center 10)} \n"
    end
    rescue StandardError => e
      puts e.message
    end

end
