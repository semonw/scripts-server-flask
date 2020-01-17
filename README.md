###Remote Scripting
一个可以远程执行脚本的服务器，并且可以将日志通过websocket导出。


###How to start with uwsgi
uwsgi --http :5000 --gevent 1000 --http-websockets --master --processes 4 --threads 2 --wsgi-file app.py --callable app --stats 127.0.0.1:5001 --stats-http
