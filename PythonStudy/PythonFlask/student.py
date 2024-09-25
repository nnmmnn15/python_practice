# -*- coding : utf-8 -*-        // utf-8 을 사용했다는 표시
"""
author      : mincheol
Description : MySQL의 Python Database와 CRUD on Web
Usage1      : http://127.0.0.1:5000/select
Usage2      : http://127.0.0.1:5000/insert?code=a001&name=james&dept=math&phone=001&address=seoul
Usage3      : http://127.0.0.1:5000/update?code=a001&name=jay&dept=kor&phone=001&address=seoul
Usage4      : http://127.0.0.1:5000/delete?code=a001
"""

from flask import Flask, jsonify, request
import pymysql
import json

app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False  # for utf8


def connection():
    # MySQL Connection
    conn = pymysql.connect(
        host="127.0.0.1",
        user="root",
        password="qwer1234",
        db="education",
        charset="utf8"
    )
    return conn

@app.route("/select")
def select():
    conn = connection()
    curs = conn.cursor()

    # sql 문장
    sql = "select * from student"
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    print(type(rows))
    print(rows)

    # json 만들기
    result = json.dumps(rows, ensure_ascii=False).encode('utf8')
    print(result)
    return result
    # return jsonify([{'result' : result}])

@app.route("/insert")
def insert():
    # url에 있는 정보를 가져옴
    # 127.0.0.1:5000/insert?code=asf&name=kim&....
    code = request.args.get("code")
    name = request.args.get("name")
    dept = request.args.get("dept")
    phone = request.args.get("phone")
    address = request.args.get("address")

    conn = connection()
    curs = conn.cursor()

    sql = "insert into student(scode, sname, sdept, sphone, saddress) values(%s,%s,%s,%s,%s)"
    curs.execute(sql,(code, name, dept, phone, address))
    conn.commit()
    return jsonify([{'result' : 'OK'}])

@app.route("/update")
def update():
    code = request.args.get("code")
    name = request.args.get("name")
    dept = request.args.get("dept")
    phone = request.args.get("phone")
    address = request.args.get("address")

    conn = connection()
    curs = conn.cursor()
    sql = "update student set sname = %s, sdept = %s, sphone = %s, saddress = %s where scode = %s"

    curs.execute(sql,(name, dept, phone, address, code))
    conn.commit()
    return jsonify([{'result' : 'OK'}])

@app.route("/delete")
def delete():
    code = request.args.get("code")

    conn = connection()
    curs = conn.cursor()
    sql = "delete from student where scode = %s"

    curs.execute(sql,(code))
    conn.commit()
    return jsonify([{'result' : 'OK'}])

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=True)