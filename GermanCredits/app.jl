using GenieFramework, CSV, DataFrames, OrderedCollections
include("germancredits.jl")
using .GermanCredits
@genietools

const data = CSV.File("german_credits.csv") |> DataFrame

@handlers begin
    @out good_credits_count = 0
    @out bad_credits_count = 0
    @out good_credits_amount = 0
    @out bad_credits_amount = 0
    @out filtered_data = DataFrame()
    @out age_stats = LittleDict()
    @in age_range::RangeData{Int} = RangeData(18:90)
    @out credit_data = DataTable(data)
    @out credit_data_pagination = DataTablePagination(rows_per_page=100)
    @out age_slots = ["20-30", "30-40", "40-50", "50-60", "60-70", "70-80", "80-90"]
    @out good_bad_plot_layout = PlotLayout(barmode="group", showlegend=false)
    @out good_bad_plot = PlotData[]
    @out age_amount_plot_layout = PlotLayout(showlegend=true)
    @out age_amount_plot = PlotData[]

    @onchange age_range begin
        filtered_data = data[(age_range.range.start.<=data[!, :Age].<=age_range.range.stop), :]

        good_credits_count, bad_credits_count, good_credits_amount, bad_credits_amount = good_bad_credits_stats(filtered_data)

        credit_data = DataTable(filtered_data)

        good_bad_plot = [
            PlotData(
                x=age_slots,
                y=collect(values(credit_no_by_age(filtered_data; good_rating=true))),
                name="Good credits",
                plot=StipplePlotly.Charts.PLOT_TYPE_BAR,
                marker=PlotDataMarker(color="#72C8A9")
            ),
            PlotData(
                x=age_slots,
                y=collect(values(credit_no_by_age(filtered_data; good_rating=false))),
                name="Bad credits",
                plot=StipplePlotly.Charts.PLOT_TYPE_BAR,
                marker=PlotDataMarker(color="#BD5631")
            )
        ]

        dgood = credit_age_amount(filtered_data; good_rating=true)
        dbad = credit_age_amount(filtered_data; good_rating=false)
        age_amount_plot = [
            PlotData(
                x=dgood.Age,
                y=dgood.Amount,
                name="Good credits",
                mode="markers",
                marker=PlotDataMarker(size=18, opacity=0.4, color="#72C8A9", symbol="circle")
            ),
            PlotData(
                x=dbad.Age,
                y=dbad.Amount,
                name="Bad credits",
                mode="markers",
                marker=PlotDataMarker(size=18, opacity=0.4, color="#BD5631", symbol="cross")
            )
        ]
    end
end

meta = Dict("og:title" => "German Credits", "og:description" => "Dashboard with statistics for the German Credits dfataset.", "og:image" => "/preview.png")
layout = DEFAULT_LAYOUT(meta=meta)
@page("/", "app.jl.html", layout)
# @page("/", "ui_lowcode.jl")


