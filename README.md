###Remote Scripting
一个可以远程执行脚本的服务器，并且可以将日志通过websocket导出。


###How to start with uwsgi
uwsgi --http :5000 --gevent 1000 --http-websockets --master --processes 4 --threads 2 --wsgi-file app.py --callable app --stats 127.0.0.1:5001 --stats-http
在windows上无法安装uwsgi

###在windows上部署
gunicorn -w 4 -b 0.0.0.0:5000 app:app
在多个worker下时，sessionId无法共享会导致问题

gunicorn -w 1 --threads 4 -b 0.0.0.0:5000 app:app

使用gevent来分发
Gunicorn with gevent async worker
gunicorn server:app -k gevent --worker-connections 1000


使用gevent自带的websocket
使用之前需要pip install gevent
gunicorn -k geventwebsocket.gunicorn.workers.GeventWebSocketWorker -w 1 app:app

gunicorn -k geventwebsocket.gunicorn.workers.GeventWebSocketWorker -w 1 --threads 4 -b 0.0.0.0:5000 app:app

###参考链接
* socket.io https://flask-socketio.readthedocs.io/en/latest
* gunicorn https://docs.gunicorn.org/en/stable/design.html
* flask https://dormousehole.readthedocs.io/en/latest