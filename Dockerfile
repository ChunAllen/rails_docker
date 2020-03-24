FROM ruby:2.6.0-slim

# install rails dependencies
RUN apt-get update -qq \
  && apt-get install -y \
  # Needed for certain gems
  build-essential \
  # Needed for postgres gem
  libpq-dev \
  # Others
  nodejs \
  vim-tiny \   
  # The following are used to trim down the size of the image by removing unneeded data
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf \
  /var/lib/apt \
  /var/lib/dpkg \
  /var/lib/cache \
  /var/lib/log

# Changes localtime to Singapore
RUN cp /usr/share/zoneinfo/Asia/Singapore /etc/localtime

# create a folder /myapp in the docker container and go into that folder
RUN mkdir /rails_docker

WORKDIR /rails_docker

# Copy the Gemfile and Gemfile.lock from app root directory into the /myapp/ folder in the docker container
COPY Gemfile /rails_docker/Gemfile

COPY Gemfile.lock /rails_docker/Gemfile.lock

# Run bundle install to install gems inside the gemfile
RUN bundle install

ADD . /rails_docker

CMD bash -c "rm -f tmp/pids/server.pid && rails s -p 3000 -b '0.0.0.0'"