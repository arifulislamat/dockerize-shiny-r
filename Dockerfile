# Use the Rocker Shiny image as the base
FROM rocker/shiny

# Create a directory for the Shiny app within the container
RUN mkdir /home/shiny-app

# Install necessary R packages for the Shiny app
RUN R -e "install.packages(c('dplyr', 'ggplot2', 'gapminder'))"

# Copy the Shiny app code into the container
COPY Cytof2.R /home/shiny-app/app.R

# Expose port 8082 for the Shiny app
EXPOSE 8082

# Command to run the Shiny app when the container starts
CMD Rscript /home/shiny-app/app.R

