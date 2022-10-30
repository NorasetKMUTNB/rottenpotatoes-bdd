# ruby in Dockerhub
FROM ruby:2.6.6

RUN apt-get update -qq && apt-get -y install \
    build-essential nodejs sqlite3 libsqlite3-dev

WORKDIR /app/bdd-cucumber
# Gemfile to /app
COPY Gemfile ./	

RUN gem install bundler:2.0.0.pre.3 && bundle install
# RUN gem install bundler && bundle install

# dot1 my dir, dot2 docker
COPY . .

# terminal windows to in docker
CMD ["/bin/bash","-c","bash"]
