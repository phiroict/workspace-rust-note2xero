FROM archlinux
RUN mkdir -p /app
EXPOSE 8000
WORKDIR /app
ADD noted2xero_web .
RUN chmod +x noted2xero_web
CMD ./noted2xero_web