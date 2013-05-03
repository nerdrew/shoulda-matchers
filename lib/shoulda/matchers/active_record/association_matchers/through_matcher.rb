module Shoulda # :nodoc:
  module Matchers
    module ActiveRecord # :nodoc:
      module AssociationMatchers
        class ThroughMatcher
          def initialize(through, name)
            @through = through
            @name = name
            @missing_option = ''
          end

          def description
            " through #{@through}"
          end

          def matches?(subject)
            @subject = subject
            @through.nil? || (through_association_exists? && through_association_correct?)
          end

          def missing_option
            @missing_option
          end

          def model_class
            @subject.class
          end

          def through_association_exists?
            if through_reflection.nil?
              @missing_option = "#{model_class.name} does not have any relationship to #{@through}"
              false
            else
              true
            end
          end

          def through_reflection
            @through_reflection ||= model_class.reflect_on_association(@through)
          end

          def through_association_correct?
            if @through == reflection.options[:through]
              true
            else
              @missing_option = "Expected #{model_class.name} to have #{@name} through #{@through}, " +
                "but got it through #{reflection.options[:through]}"
              false
            end
          end

          def reflection
            @reflection ||= model_class.reflect_on_association(@name)
          end
        end
      end
    end
  end
end