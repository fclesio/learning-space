# Base image
FROM python:3.6

MAINTAINER Flavio Clesio <flavio.clesio@gmail.com>

# Updating repository sources
RUN apt-get update

# Pick up some TF dependencies
RUN apt-get install -y software-properties-common
RUN apt-get install -y curl
RUN apt-get install -y unzip
RUN apt-get install -y build-essential
RUN apt-get install -y libfreetype6-dev
RUN apt-get install -y libhdf5-serial-dev
RUN apt-get install -y libpng-dev
RUN apt-get install -y libzmq3-dev
RUN apt-get install -y pkg-config
RUN apt-get install -y vim
RUN apt-get install wget
RUN apt-get -y install python3-pip
RUN apt-get install -y htop

RUN apt-get install -y postgresql

RUN apt-get install -y libpq-dev 
RUN apt-get install -y postgresql-client 
RUN apt-get install -y postgresql-client-common



#OPENCV dependencies
# https://stackoverflow.com/questions/47113029/importerror-libsm-so-6-cannot-open-shared-object-file-no-such-file-or-directo
RUN apt-get install -y libsm6 libxext6
RUN apt-get install -y libfontconfig1 libxrender1

RUN pip3 install --upgrade pip

COPY requirements.txt /tmp/

RUN pip install --requirement /tmp/requirements.txt

COPY . /tmp/

RUN pip3 install --upgrade jupyter_core jupyter_client
RUN pip3 install http://download.pytorch.org/whl/cpu/torch-0.4.1-cp36-cp36m-linux_x86_64.whl 
RUN pip3 install torchvision
RUN python3 -m ipykernel.kernelspec


# For Redis
EXPOSE 6379

# For Jupyter notebook
EXPOSE 9999

#For TensorBoard
EXPOSE 6006

# Running jupyter notebook
# --NotebookApp.token ='demo' is the password
CMD ["jupyter", "notebook", "--no-browser", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token='demo'"]
