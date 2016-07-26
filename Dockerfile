FROM ubuntu:xenial
MAINTAINER Ryan Baumann <ryan.baumann@gmail.com>

# Install dependencies
RUN apt-get update && \
  apt-get install -y build-essential python-dev python-pip \
  libtesseract3 tesseract-ocr-eng libleptonica-dev liblept5 \
  libxml2-dev libxslt1-dev libz-dev git \
  redis-server && \
  apt-get build-dep -y python-scipy

RUN git clone https://github.com/OpenPhilology/nidaba.git && cd nidaba && git checkout a797357896d0bf7c85e3fc026163404bb20e43d9
WORKDIR nidaba
RUN pip install .
RUN mkdir -p /usr/etc/nidaba/
COPY celery.yaml /usr/etc/nidaba/celery.yaml
COPY nidaba.yaml /usr/etc/nidaba/nidaba.yaml
RUN python setup.py download
RUN python setup.py nosetests
RUN pip install kraken
RUN nidaba plugins

EXPOSE 8080
COPY startup.sh /nidaba/startup.sh
CMD ["sh","/nidaba/startup.sh"]
