# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pattern do
    pattern_type "MyString"
    start_time "2014-06-12 20:22:05"
    end_time "2014-06-12 20:22:05"
    score 1.5
  end
end
