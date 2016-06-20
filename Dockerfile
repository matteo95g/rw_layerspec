FROM ruby:2.3.0
MAINTAINER Sebastian Schkudlara "sebastian.schkudlara@vizzuality.com"

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /rw_layerspec

WORKDIR /rw_layerspec
# Copy the Gemfile and Gemfile.lock into the image and install gems before the project is copied,
# this is to avoid do bundle install every time some project file change.
COPY Gemfile /rw_layerspec/Gemfile
COPY Gemfile.lock /rw_layerspec/Gemfile.lock
RUN bundle install

ADD . /rw_layerspec

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 3030

ENTRYPOINT ["./entrypoint.sh"]
