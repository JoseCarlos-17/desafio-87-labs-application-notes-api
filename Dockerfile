FROM ruby:3.3.1-slim

WORKDIR /rails

ENV RAILS_ENV=development

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      libsqlite3-dev \
      nodejs \
    && rm -rf /var/lib/apt/lists

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000
CMD ["bash", "-c", "rails db:migrate && rails s -b 0.0.0.0"]