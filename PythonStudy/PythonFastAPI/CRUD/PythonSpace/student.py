from fastapi import FastAPI
import pymysql

app = FastAPI()

def connect():
    conn = pymysql.connect(
        host='127.0.0.1',
        user='root',
        password='qwer1234',
        db='education',
        charset='utf8'
    )
    return conn

@app.get("/select")
async def select():
    conn = connect()
    curs = conn.cursor()
    
    sql = "select scode, sname, sdept, sphone, saddress from student"
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    print(rows)
    return {'results':rows}

    # 결과 값을 Dictionary로 변환
    # result = []
    # for row in rows:
    #     tempDict = {
    #         'code' : row[0],
    #         'name' : row[1],
    #         'dept' : row[2],
    #         'phone' : row[3],
    #     }
    #     result.append(tempDict)
    
    # result = [{'code' : row[0], 'name' : row[1], 'dept' : row[2], 'phone' : row[3]} for row in rows]
    
    # return {'results' : result}

@app.get("/insert")
async def insert(code: str=None, name: str=None, dept : str=None, phone: str=None, address: str=None):
    conn = connect()
    curs = conn.cursor()
    
    try:
        sql = "insert into student(scode, sname, sdept, sphone, saddress) values (%s, %s, %s, %s, %s)"
        curs.execute(sql,(code, name, dept, phone, address))
        conn.commit()
        conn.close()
        return {'results' : 'OK'}
    except Exception as e:
        conn.close()
        print("Error :", e)
        return {'results' : 'Error'}
    
@app.get("/update")
async def update(code: str=None, name: str=None, dept : str=None, phone: str=None, address: str=None):
    conn = connect()
    curs = conn.cursor()

    try:
        sql = "update student set sname=%s, sdept=%s, sphone=%s, saddress=%s where scode=%s"
        curs.execute(sql,(name, dept, phone, address, code))
        conn.commit()
        conn.close()
        return {'results' : 'OK'}
    except Exception as e:
        conn.close()
        print("Error :", e)
        return {'results' : 'Error'}
    
@app.get("/delete")
async def delete(code: str=None):
    conn = connect()
    curs = conn.cursor()

    try:
        sql = "delete from student where scode=%s"
        curs.execute(sql,(code))
        conn.commit()
        conn.close()
        return {'results' : 'OK'}
    except Exception as e:
        conn.close()
        print("Error :", e)
        return {'results' : 'Error'}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)