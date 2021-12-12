=begin
     Чтобы проверить данные внутри класса, создадим соответствующий класс Validator.
     Например, для класса Train мы должны создать TrainValidator.
     Экземпляр класса является валидным, если валидным является его валидатор:
       example.obj_valid = true if validator.valid = true

     Проблема: *****************************************************************
         класс Train порождает классы PassengerTrain и CargoTrain.
         для класса Train создается класс TrainValidato. 
         Что делать для PassengerTrain и CargoTrain: создавать PassengerTrainValidator и CargoTrainValidator?????
=end

module Validation

  def obj_valid?

    # Имена всех классов в Ruby — константы в «глобальном» пространстве имен, то есть члены класса Object.
    # Динамическое создание экземпляра класса, заданного своим именем:
    #    для Class Train (self.class.name) создаем Class TrainValidator

    valid_class = Object.const_get("#{self.class.name}Validator")   # ------ Содать  класс PassengerTrainValidator
    #puts "valid_class.class "  + valid_class.class.to_s
    @validator = valid_class.new(self)                              # ------ Содать Obj-валидатор класса PassengerTrainValidator
    #puts  "@validator " + @validator.to_s                          
    @validator.valid? 
  end

# ------- ???????????????????????????????????????????????????? <- debug
  def attr_validate(*args)
      obj_valid?  unless defined?(@validator)
      validate(@validator.class.validators.find { |item| item[0] == args[0] })
      return @errors.messages.empty?
    end 
# ------- ???????????????????????????????????????????????????? <- debug

  def errors
    return @validator.errors.messages  if defined?(@validator)
  end
end

class ValidationErrors
  attr_accessor :messages 

  def initialize
    @messages = {} 
  end

  def add(name, msg)
    (@messages[name] ||= []) << msg
  end
end

module Validate
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    attr_reader :object, :errors

    def initialize(object)
      @object = object
      @errors = ValidationErrors.new
    end

    def valid?                                                # возвращает true/false = есть/нет ошибки в eroors{}
      
      self.class.validators.each { |condition|  validate(condition) }
      @errors.messages.empty? 
    end

    private

    def validate(args)
      #puts "validate(args) args "  + args.to_s
      action = args[1]
      case
      when action.key?(:empty)    
        empty_validator(*args)

      when action.key?(:type)   
        type_validator(*args)
        
      when action.key?(:option)  
        option_validator(*args)
      end
    end

    def empty_validator(attribute, condition)
      #puts "name " + attribute.to_s                      
      #puts "options " + condition.to_s
      #puts condition[:option]                            
      raise unless condition[:empty].call(@object)
    rescue
      @errors.add(attribute, condition[:msg])               # ---------------------------- Hash of errors
    end

    def option_validator(attribute, condition)
      # puts "option_validator " + attribute.to_s
      # puts "@errors " + @errors.to_s
      # puts "option_condition " + condition.to_s
      # puts "@object " + @object.to_s                      # --- @object #<PassengerTrain:0x0055ddec87c330>
      # puts condition[:option].to_s                        # --- <Proc:0x0055ddec8090b0@/home/igon/work/my_project/The Object Model_3/validate.rb:168>
      raise unless condition[:option].call(@object)
    rescue
       @errors.add(attribute, condition[:msg]) 
    end

    def type_validator(attribute, condition)                 # ------- number, {:type=>Regexp}                       type
      #puts "attribute " + attribute.to_s                    # ------- number_cars                                   type
      #puts "options_type " + options.to_s                   # ------- options {:type=>Regexp}                       {:type=>String}
      #puts "@object " + @object.to_s                        # ------- @object #<PassengerTrain:0x0055bc85cdd5b0>
      #puts options[:type]                                   # ------- Regexp                                        String
      #puts @object.send(name)                               # ------- 19     < = PassengerTrain.number              пассажирский
      #return if @object.send(name).is_a?(options[:type])    # ------- PassengerTrain.send(number).is_a?(Regexp)
      #                                                      # =>                           19   является Regexp   пассажирский  String 
      #raise unless @object.send(attribute).is_a?(condition[:type])

      return if @object.send(attribute).is_a?(condition[:type])
    #rescue
      #puts "type_validator " + @errors.to_s 
      @errors.add(attribute, "должен быть #{condition[:type].attribute}")  #
    end
  end

  module ClassMethods

    def validates(*condition)                                 # ---- Формирование требований для аттрибутов
      create_validation(condition)
    end

    def validators                                            # ---- Валидаторы
      @validators
    end

    private

    def create_validation(condition)
      @validators = [] unless defined?(@validators)
      @validators << condition                                # ---- Массив требований к аттрибутам  - Валидаторы
    end
  end
end
