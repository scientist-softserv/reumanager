FROM phusion/passenger-ruby23:0.9.20

RUN apt-get update -qq && apt-get install -y build-essential nodejs npm pv libsasl2-dev libpq-dev postgresql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN rm /etc/nginx/sites-enabled/default
COPY ops/webapp.conf /etc/nginx/sites-enabled/webapp.conf
COPY ops/env.conf /etc/nginx/main.d/env.conf

ENV APP_HOME /home/app/webapp
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
  BUNDLE_JOBS=4

ADD Gemfile* $APP_HOME/
RUN bundle check || bundle install



COPY . $APP_HOME
RUN chown -R app $APP_HOME

# Asset complie and migrate if prod, otherwise just start nginx
ADD ops/nginx.sh /etc/service/nginx/run
RUN chmod +x /etc/service/nginx/run
RUN rm -f /etc/service/nginx/down

CMD ["/sbin/my_init"]
