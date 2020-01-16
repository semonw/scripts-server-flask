#!/usr/bin/python
# -*- coding: UTF-8 -*-

import datetime
import logging
import os
import subprocess
import time

import pytz
from flask import Flask, redirect, request
from flask_socketio import SocketIO

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)
app = Flask(__name__)
socketio = SocketIO(app)


@app.route('/')
def default_output():
    indexfiles = ['index.html', 'index.htm', 'index.php']
    for idx in indexfiles:
        if os.path.exists(os.path.join('static', idx)):
            app.send_static_file(idx)
    logger.error('不存在index.html文件，请检查部署路径。')
    return "Hello, Flask. No Index.html found."


script_all = os.path.join('scripts', 'callMac_all.sh')
script_li = os.path.join('scripts', 'callMac_li.sh')
script_wang = os.path.join('scripts', 'callMac_wang.sh')


def execScripts(script_path):
    if not os.path.exists(script_path):
        logger.error("script not exist!")
        return 'script not exist!'
    else:
        logger.info("开始执行脚本 %s" % script_path)
        starttime = datetime.datetime.now()
        p = subprocess.Popen(script_path, shell=False, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        while p.poll() is None:
            # 注意: 需要脚本里面实时的将stdout进行flush， 否则输出将出现延迟
            line = p.stdout.readline()
            line = line.strip()
            if line:
                # 通过ws进行广播
                broadcasting(line)

        endtime = datetime.datetime.now()
        logger.info("脚本执行完成，总计花费时间 %d 秒." % (endtime - starttime).seconds)
        if p.returncode == 0:
            logger.info("success, subprocess returncode %d" % p.returncode)
            return {
                'status': 200
            }
        else:
            logger.info("failure, subprocess returncode %d" % p.returncode)
            return {
                'status': 500
            }


@app.route('/clock/<name>')
def onclock(name):
    if name == 'all':
        logger.info("clocking all")
        return execScripts(script_all)
    elif name == 'li':
        logger.info("clocking li")
        return execScripts(script_li)
    elif name == 'wang':
        logger.info("clocking wang")
        return execScripts(script_wang)
    else:
        return redirect('/')


@app.route('/list')
def list_history():
    baseDir = os.path.join('static', 'logs')
    if not os.path.exists(baseDir):
        logger.error('logs dir not exist.')
        return {
            'message': 'log dir not exist',
            'data': [],
            'total': 0,
            'status': 404
        }

    dirItems = os.listdir(baseDir)
    dirs = []
    for i in range(0, len(dirItems)):
        if os.path.isdir(os.path.join(baseDir, dirItems[i])):
            dirs.append(os.path.join(baseDir, dirItems[i]))

    logDirsInfo = []
    for dir in dirs:
        mtime = os.path.getmtime(dir)
        dirName = os.path.basename(dir)
        mtime_str = timestamp2timestr(mtime)
        utc_time = timestamp2utc(mtime)
        logDirsInfo.append({
            'timestmap': mtime,
            'name': dirName,
            'time': mtime_str,
            'count': count_file_in_dir(dir),
            'utc': utc_time
        })

    logDirsInfo = sorted(logDirsInfo, key=lambda k: k['timestmap'], reverse=True)
    return {
        'message': 'ok',
        'data': logDirsInfo,
        'total': len(logDirsInfo),
        'status': 200
    }


def count_file_in_dir(dir):
    if not os.path.exists(dir) or not os.path.isdir(dir):
        return 0
    else:
        files = os.listdir(dir)
        count = 0
        for f in files:
            if os.path.isfile(os.path.join(dir, f)):
                count += 1
        return count


def timestamp2timestr(timestamp):
    timeStruct = time.localtime(timestamp)
    return time.strftime('%Y-%m-%d %H:%M:%S', timeStruct)


# 转成UTC时间
def timestamp2utc(local_ts):
    utc_format = '%Y-%m-%dT%H:%MZ'
    local_tz = pytz.timezone('Asia/Chongqing')
    local_format = "%Y-%m-%d %H:%M"
    time_str = time.strftime(local_format, time.localtime(local_ts))
    dt = datetime.datetime.strptime(time_str, local_format)
    local_dt = local_tz.localize(dt, is_dst=None)
    utc_dt = local_dt.astimezone(pytz.utc)
    return utc_dt.strftime(utc_format)


@app.route('/push')
def publish_result():
    """广播消息
    发送消息：http://127.0.0.1:5000/push?msg=a
    """
    event_name = 'message'
    data = request.args.get("msg")
    broadcasted_data = {'data': data}
    logger.info("publish msg==>", broadcasted_data)
    socketio.emit(event_name, broadcasted_data, broadcast=True)
    return 'send msg successful!'


@socketio.on('connect')
def connected_msg():
    """客户端连接"""
    logger.info('客户端连接！')


@socketio.on('disconnect')
def disconnect_msg():
    """客户端离开"""
    logger.info('客户端断开连接！')


@socketio.on('heartbeat')
def handle_heartbeat():
    socketio.emit('heartbeat', 'heartbeat')


def broadcasting(data):
    logger.info("Broadcasting %s" % data)
    socketio.emit('message', data, broadcast=True)


if __name__ == '__main__':
    host = '0.0.0.0'
    port = 5000
    logger.info("listening http://%s:%d" % (host, port))
    socketio.run(app, '0.0.0.0', 5000)
