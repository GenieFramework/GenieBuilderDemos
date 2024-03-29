module App
using StatsBase: mean, std, var
using GenieFramework
@genietools

function statistics(x)
  mean(x), std(x), var(x)
end

@app begin
  @out m::Float32 = 0.0
  @out s::Float32  = 0.0
  @out v::Float32  = 0.0
  @in N = 0
  @out hist = PlotData()
  @onchange N begin
    x_rand = randn(N)
    m, s, v = statistics(x_rand)
    hist = PlotData(x=x_rand, plot=StipplePlotly.Charts.PLOT_TYPE_HISTOGRAM)
  end
end

meta = Dict("og:title" => "Histogram plot", "og:description" => "Plot a histogram of a vector of random numbers.", "og:image" => "/preview.jpg")
layout = DEFAULT_LAYOUT(meta=meta)
@page("/", "app.jl.html", layout)
end
