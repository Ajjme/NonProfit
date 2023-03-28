fontFormat = dict(family="sans-serif",
                  size=22,)
fig = Stacked_bar_graph
#,#px.bar(x=[14238,37120,35714,19682,24423,5564,36714,22794,314,12794,11794,36794],
             #y=["Malaysia","Singapore","Australia","Thailand","Indonesia","Filiphine","Country 1", "Country 2", "Country 3", "Country 4", "Country 5", "China"],
             #color=["Malaysia","Singapore","Australia","Thailand","Indonesia","Philippines","Country 1", "Country 2", "Country 3", "Country 4", "Country 5", "China"],
             orientation="h",
            # color_discrete_sequence=["orange",color_pallete2[3],color_pallete2[3],color_pallete2[3],color_pallete2[3],color_pallete2[3],color_pallete2[3],color_pallete2[3],color_pallete2[3],color_pallete2[3],color_pallete2[3],color_pallete2[3]]
#)
fig.update_layout({
  'plot_bgcolor': 'white',
  'paper_bgcolor': 'white',
})

fig.update_layout(title = 'Comparison on Entry Level Pharmacist Salary Across Countries'
)

fig.update_xaxes(title_text='')
fig.update_yaxes(title_text='Yearly Salary (USD)')
fig.update_layout(yaxis={'categoryorder':'total ascending'})
fig.update_layout(font=fontFormat)
fig.update_yaxes(ticksuffix = "  ")
fig.update_layout(width=1024,height=768)
fig.update_layout(legend_orientation="h")

fig.show()