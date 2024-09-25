from fastapi import FastAPI
import pymysql

app = FastAPI()

def connect():
    conn = pymysql.connect(
        host='127.0.0.1',
        user='root',
        password='qwer1234',
        db='todolist',
        charset='utf8'
    )
    return conn

@app.get("/select")
async def select():
    conn = connect()
    curs = conn.cursor()
    
    sql = "select seq, task, imagepath, task_date from todolist"
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    print(rows)
    return {'results':rows}

@app.get("/insert")
async def insert(task: str=None, imagepath: str=None, task_date: str=None):
    conn = connect()
    curs = conn.cursor()
    
    try:
        sql = "insert into todolist(task, imagepath, task_date) values (%s, %s, %s)"
        curs.execute(sql,(task, imagepath, task_date))
        conn.commit()
        conn.close()
        return {'results' : 'OK'}
    except Exception as e:
        conn.close()
        print("Error :", e)
        return {'results' : 'Error'}
    
@app.get("/delete")
async def delete(seq: int=None):
    conn = connect()
    curs = conn.cursor()

    try:
        sql = "delete from todolist where seq=%s"
        curs.execute(sql,(seq))
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