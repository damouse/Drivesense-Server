# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :score do
    score 1.5
    scoreAccels 1.5
    scoreBreaks 1.5
    scoreLaneChanges 1.5
    scoreTurns 1.5
  end
end
