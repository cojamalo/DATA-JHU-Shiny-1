# DATA-JHU-Shiny-1
The following files were submitted for the third project of John Hopkins University's Developing Data Products course hosted by Coursera

Completion Date: Jun 21, 2017

Please view https://cojamalo.shinyapps.io/oil-composition-viewer/ to use the Shiny App.

Please view https://cojamalo.github.io/DATA-JHU-Shiny-1/pitch.html to properly view the completed presentation.

Project Assignment:

This peer assessed assignment has two parts. First, you will create a Shiny application and deploy it on Rstudio's servers. Second, you will use Slidify or Rstudio Presenter to prepare a reproducible pitch presentation about your application.


Documentation
Welcome to the Oil Fatty Acid Composition Viewer and Mixing Simulator!

Overview

This app uses the fatty acid concentration data supplied with the caret pacakge and allows the user to compare the fatty acid concentrations of six different oil types from the data's measurements.

Usage

The app will generate different plots using ggplot2 dependent on what selection the user makes from the 'Compare Type', 'Plot Type', 'Oil Types', and 'Order Fatty Acids by Concentration of' inputs.
Compare Type

Options: Separated, Mixed

If the user selects 'Separated' and multiple oil types are selected, the plots will use facetting to compare the fatty acid concentrations. This setting allows the user to see the differences and similarities in the concentration of fatty acids for each selected oil type. If the user selects 'Mixed', the resulting plots will represent the concentration of a hypothetical 1:1 mix between the oils selected.

Plot Type

Options: Density Plot, Box Plot

There are two plot types available to explore the distributuions of fatty acid concentrations in the selected oils. The density plot portrays a compositional 'fingerprint' of the oil by showing the probabiility density of the concentrations of each fatty acid type. The box plot shows the distribution of fatty acid concentrations in the oil using the familiar box-and-whisker format

Oil Types

Options: pumpkin, sunflower, peanut, olive, soybean, rapeseed

This option allows the user to select which oils to include in the plot.

Order Fatty Acids by Concentration in

Options: (which options are available is dependent on which oil types are selected)

This option only appears if the 'Box Plot' is selected for the 'Plot Type' input. The selected oil for this setting will determine how the fatty acids concentrations are ordered on the x-axis in the plot and will not change the values of the concentrations. For instance, if olive oil is selected, then the fatty acids in the plot will be arranged by the fatty acid with the lowest concentration to the fatty acid with the highest concentration assuming a typical distribution for olive oil.

Project coded by Connor Lenio - released into the public domain for educational purposes in 2017.
