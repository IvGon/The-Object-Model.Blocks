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

  attr_reader :reg_number,  :type_wagon, :subtype
  attr_reader :full_volume, :free_volume 
  
  def initialize(reg_number,subtype = "INI")
    super(reg_number,"грузовой")
    if subtype == "INI"
      @subtype = subtype_wagon?
    else 
      as_subtype_wagon(subtype)
    end
    @free_volume = @full_volume
  end

   def type_wagon
    "грузовой"
  end

  def take_volume(volume)
    raise 'All seats taken!' if @free_volume.zero?
    @free_volume -= volume
  end

  def unload_volume(volume)
    raise 'All seats taken!' if @free_volume.zero?
    @free_volume += volume
  end

  def occupied_volume
    @full_volume - @free_volume 
  end

  # ------------------------------  Назначить вид вагона -----------------------------------------
  def as_subtype_wagon(type)                          
    set_subtype_wagon(type) if subtype.nil?
  end

# ------------------------------ Ввести с консоли вид вагона --------------------------------------
  def subtype_wagon?                                  
    set_subtype_wagon("INI") 
  end

=begin --------------------------------------------------------------------------------------------
  
  К методам privete отнесены методы определения вида вагона в зависимости от типа вагона.

=end 

  private

    attr_writer :subtype, :full_volume

    def set_subtype_wagon(type)

      subtype = [:КВ,:ПЛ,:ПВ,:ЦС,:ТС]
      wagon_subtype  = [
                        { _type: :КВ, _volume: 18, _name: "крытый" },
                        { _type: :ПЛ, _volume: 36, _name: "платформа" },
                        { _type: :ПВ, _volume: 54, _name: "полувагон" },
                        { _type: :ЦС, _volume: 54, _name: "цистерна" }, 
                        { _type: :ТС, _volume: 54, _name: "рефрижератор"}]

      if subtype.include?(type) == false
        begin 
          print "Вид вагона (КВ - 0, ПЛ - 1, ПВ - 2,  ЦС - 3, ТС - 4): "
          num = gets.chomp.to_i
          raise "Вид вагона должен быть - [0 .. 4]!" unless (0..4).include? num
          type = subtype[num]
          rescue  => e
            puts "#{e.class}: #{e.message}"
            print "Продолжить ввод (0 - нет, 1 - да): "
            retry if gets.chomp.to_i == 1
          end
        end  
      @full_volume = wagon_subtype.find{ |a| a[:_type] == type }[:_volume]
      @subtype = wagon_subtype.find{ |a| a[:_type] == type }[:_name]
    end
end