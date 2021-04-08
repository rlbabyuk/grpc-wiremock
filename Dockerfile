FROM gradle:6.8.3-jdk11 as cache
RUN apt-get update
RUN apt-get -y install nginx openssl curl vim
RUN mkdir -p /home/gradle/cache_home
RUN mkdir -p /proto
RUN touch /proto/any.proto
ENV GRADLE_USER_HOME /home/gradle/cache_home
COPY build.gradle /home/gradle/java-code/
WORKDIR /home/gradle/java-code
RUN gradle build -i --no-daemon || return 0

FROM gradle:6.8.3-jdk11 as runner
COPY --from=cache /home/gradle/cache_home /home/gradle/.gradle
COPY . /usr/src/java-code/
WORKDIR /usr/src/java-code
RUN apt-get nginx
EXPOSE 8888 50000 443
ENTRYPOINT ["gradle", "bootRun", "-i"]