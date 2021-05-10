FROM adoptopenjdk:maven-openjdk8 as builder

RUN curl -L -o /tmp/elasticjob-lite-console.tgz https://github.com/apache/shardingsphere-elasticjob/archive/refs/tags/2.1.5.tar.gz && \
    mkdir -p /opt && \
    cd /opt/ && tar -zxf /tmp/elasticjob-lite-console.tgz && \
    mv /opt/shardingsphere-elasticjob-2.1.5 /opt/shardingsphere-elasticjob && \
    cd /opt/shardingsphere-elasticjob/elastic-job-lite/elastic-job-lite-console && \
    mvn package -DskipTests && \
    cd /opt/shardingsphere-elasticjob/elastic-job-lite/elastic-job-lite-console/target && \
    tar zxf elastic-job-lite-console-2.1.5.tar.gz
    mv /opt/shardingsphere-elasticjob/elastic-job-lite/elastic-job-lite-console/target/elastic-job-lite-console-2.1.5 /opt/elastic-job-lite-console

FROM adoptopenjdk:8-jre-hotspot
LABEL maintainer="Nick Fan <nickfan81@gmail.com>"

WORKDIR /opt/elastic-job-lite-console
VOLUME /opt/elastic-job-lite-console/conf
VOLUME /opt/elastic-job-lite-console/logs
VOLUME /root/.elastic-job-console

EXPOSE 8899/TCP

COPY --from=builder /opt/elastic-job-lite-console /opt/elastic-job-lite-console
ENTRYPOINT java -classpath /opt/elastic-job-lite-console/lib/*:. \
com.dangdang.ddframe.job.lite.console.ConsoleBootstrap 8899

