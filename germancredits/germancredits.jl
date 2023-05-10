module GermanCredits
export good_bad_credits_stats, credit_age_amount, credit_no_by_age

using DataFrames, Dates, OrderedCollections

function good_bad_credits_stats(data::DataFrame)
    good_credits_count = data[data.Good_Rating.==true, [:Good_Rating]] |> nrow
    bad_credits_count = data[data.Good_Rating.==false, [:Good_Rating]] |> nrow
    good_credits_amount = data[data.Good_Rating.==true, [:Amount]] |> Array |> sum
    bad_credits_amount = data[data.Good_Rating.==false, [:Amount]] |> Array |> sum

    (; good_credits_count, bad_credits_count, good_credits_amount, bad_credits_amount)
end

function credit_age_amount(data::DataFrame; good_rating::Bool)
    data[data.Good_Rating.==good_rating, [:Age, :Amount]]
end

function credit_no_by_age(data::DataFrame; good_rating::Bool)
    age_stats::LittleDict{Int,Int} = LittleDict()
    for x in 20:10:90
        age_stats[x] = data[(data.Age.∈[x:x+10]).&(data.Good_Rating.==good_rating), [:Good_Rating]] |> nrow
    end
    age_stats
end
end
