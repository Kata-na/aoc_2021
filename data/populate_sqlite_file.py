from sqlite3 import Connection as SQLite3Connection
from sqlalchemy import event
from sqlalchemy.engine import Engine
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from create_sqlitedb_file import Datatable_01, Datatable_02

from datatable import fread
import numpy as np

# app
app = Flask(__name__)
# config
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///aocDB.file"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = 0

# configure sqlite3 to enforce foreign key contraints
@event.listens_for(Engine, "connect")
def _set_sqlite_pragma(dbapi_connection, connection_record):
    if isinstance(dbapi_connection, SQLite3Connection):
        cursor = dbapi_connection.cursor()
        cursor.execute("PRAGMA foreign_keys=ON;")
        cursor.close()


db = SQLAlchemy(app)

m = fread('./data/dt_01.txt').to_list()[0]
for  val in m:
    new_input = Datatable_01(depth=int(val))
    db.session.add(new_input)
    db.session.commit()

#DATA 02
m = np.array(fread('./data/dt_02.txt').to_list())
mdir = np.array(m[0])
num = m[1].astype(int)

# create table
i = 0
for  val, dir in zip(num, mdir):
    i += 1
    new_input = Datatable_02(move_dir=dir, move_size=int(val))
    db.session.add(new_input)
    db.session.commit()
    if i == len(mdir): break # Investigate why dtat gets duplicated

