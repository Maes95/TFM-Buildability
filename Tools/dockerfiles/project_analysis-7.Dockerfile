# Pull base image.
FROM openjdk:7

RUN apt-get update
RUN apt-get -y install build-essential

# Install Maven

RUN apt -y install maven

# Install Defects4J

RUN echo Y | perl -MCPAN -e 'install DBI'
RUN git clone https://github.com/rjust/defects4j
RUN ./defects4j/init.sh
ENV PATH="/defects4j/framework/bin:${PATH}"

# Install conda
RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-5.3.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

ENV PATH /opt/conda/bin:$PATH

RUN /opt/conda/bin/conda install jupyter -y --quiet 

# Download projects

WORKDIR /home/bugs/

RUN mkdir projects/
RUN defects4j checkout -p Lang -v 1b -w projects/Lang/
RUN defects4j checkout -p Math -v 1b -w projects/Math/
RUN defects4j checkout -p Closure -v 1b -w projects/Closure/
RUN defects4j checkout -p Time -v 1b -w projects/Time/

# Copy source files

COPY py/ py/

# Copy config files

COPY configFiles/ configFiles/

# Set up Nootebook script
RUN echo "/opt/conda/bin/jupyter notebook --notebook-dir=/home/bugs/analysis/_notebooks --ip='0.0.0.0' --port=8888 --no-browser --allow-root &" >  runJupyterNotebook.sh 
RUN chmod +x runJupyterNotebook.sh
EXPOSE 8888

CMD ["bash"]

# BUILD docker build -f dockerfiles/project_analysis-7.Dockerfile -t maes95/project_analysis:java-7 .
# RUN docker run --rm -it -p 8888:8888 -v $PWD/analysis:/home/bugs/analysis maes95/project_analysis:java-7 bash 