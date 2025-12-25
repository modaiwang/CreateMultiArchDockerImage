# 第一阶段：使用多架构支持的JDK镜像（推荐选择）
# 关键：使用 --platform=$TARGETPLATFORM 参数，让构建器自动拉取ARM64基础镜像
FROM --platform=$TARGETPLATFORM ibm-semeru-runtimes:open-8-jre-focal AS builder

# 设置工作目录
WORKDIR /app

# 复制应用程序JAR包
COPY sync-tool-1.0-SNAPSHOT.jar sync-tool-1.0-SNAPSHOT.jar
COPY testCase/test.png /data/testCase/test.png

ENV APP_ENV="--spring.profiles.active=prod"
ENV JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=8098 -server -Xms512m -Xmx1024m -XX:+UseG1GC -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/dumps/oom_dump.hprof"

# 设置容器启动时默认执行的命令
ENTRYPOINT ["sh", "-c","java $JAVA_OPTS -jar /sync-tool-1.0-SNAPSHOT.jar $APP_ENV"]