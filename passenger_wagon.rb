# -------------------------- Класс PassengerWagon (пассажирский вагон )---------------------------
=begin
    Добавить атрибут общего кол-ва мест (задается при создании вагона)    total number of seats
    Добавить метод, который "занимает места" в вагоне (по одному за раз)
    Добавить метод, который возвращает кол-во занятых мест в вагоне
    Добавить метод, возвращающий кол-во свободных мест в вагоне.          number of free seats
=end
require_relative 'wagon'

class PassengerWagon < Wagon
  
  attr_reader :reg_number,  :type_wagon, :subtype
  attr_reader :total_seats, :free_seats

  def initialize(reg_number,subtype = "INI")
    super(reg_number,"пассажирский")
    if subtype == "INI"
      @subtype = subtype_wagon?
    else 
      as_subtype_wagon(subtype)
    end
    @total_seats
    @free_seats = @total_seats
  end

  def type_wagon
    "пассажирский"
  end

  def take_a_seat
    raise 'All seats taken!' if @free_seats.zero?
    @free_seats -= 1
  end

  def refund_a_seat
    raise 'All seats taken!' if @free_seats.zero?
    @free_seats += 1
  end

  def occupied_seats
    @total_seats - @free_seats
  end

  # ------------------------------  Назначить вид вагона -----------------------------------------
  def as_subtype_wagon(type)                          
    set_subtype_wagon(type) #if type.nil?
  end

# ------------------------------ Ввести с консоли вид вагона --------------------------------------
  def subtype_wagon?                                  
    set_subtype_wagon("INI") 
  end

=begin --------------------------------------------------------------------------------------------
  
  К методам privete отнесены методы определения вида вагона в зависимости от типа вагона.

=end 

  private

    attr_writer :subtype, :total_seats

    def set_subtype_wagon(type)

      subtype = [:СВ,:КП,:ПЛ,:РС,:ПБ]
      wagon_subtype  = [
                        { _type: :СВ, _seats: 18, _name: "мягкий" },
                        { _type: :КП, _seats: 36, _name: "купейный" },
                        { _type: :ПЛ, _seats: 54, _name: "плакартный" },
                        { _type: :РС, _seats: 15, _name: "ресторан" }, 
                        { _type: :ПБ, _seats: 5,  _name: "почтовый" } ]

      if subtype.include?(type) == false
        begin 
          print "Вид вагона (СВ - 0, КП - 1, ПЛ - 2,  РС - 3, ПБ - 4): "
          num = gets.chomp.to_i
          raise "Вид вагона должен быть - [0 .. 4]!" unless (0..4).include? num
          type = subtype[num]
          rescue  => e
            puts "#{e.class}: #{e.message}"
            print "Продолжить ввод (0 - нет, 1 - да): "
            retry if gets.chomp.to_i == 1
          end
        end        

      @total_seats = wagon_subtype.find{ |a| a[:_type] == type }[:_seats]
      @subtype = wagon_subtype.find{ |a| a[:_type] == type }[:_name]

    end
end

  # private

  # def validate_free_seats!
  #   raise 'All seats taken!' if @free_seats.zero?
  # end

  #wagon_subtype.each_with_index {|wg, ind| puts "#{wg} => #{ind}" }
  #wagon_subtype.find {|wg| wg[:_type] == type }

      #arr = [{"id"=>"1", "name"=>"Alan"}, {"id"=>"2", "name"=>"Ben"}, {"id"=>"3", "name"=>"Carl"},
      #      {"id"=>"4", "name"=>"Danny"}, {"id"=>"5", "name"=>"Eva"}]
      #
      #arr.find{ |a| a["id"] == "4" }["name"]