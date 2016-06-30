FROM ruby:2.3.0
MAINTAINER Sebastian Schkudlara "sebastian.schkudlara@vizzuality.com"

RUN apt-get update -qq && apt-get install -y build-essential

RUN mkdir /rw_layerspec

RUN gem install bundler --no-ri --no-rdoc

WORKDIR /rw_layerspec
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --without development doc --jobs=4

ADD . /rw_layerspec

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 3030

ENTRYPOINT ["./entrypoint.sh"]
