from sqlite3 import Connection as SQLite3Connection
from sqlalchemy import event
from sqlalchemy.engine import Engine
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

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
class Datatable_01(db.Model):
    __tablename__ = "aoc_data_01"
    id = db.Column(db.Integer, primary_key=True)
    depth = db.Column(db.Integer)

class Datatable_02(db.Model):
    __tablename__ = "aoc_data_02"
    id = db.Column(db.Integer, primary_key=True)
    move_dir = db.Column(db.String(50))
    move_size = db.Column(db.Integer)

if __name__ == "__main__":
    app.run(debug=True)

# console: python -> from data.create_sqlitedb_file import db -> db.create_all() -> quit()