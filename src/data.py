from typing import List
from . import ospyata as osmata
from .ospyata import OspyataException
import pathlib
import json

class Data:
    def __init__(self, data_file_path: str):
        self.data_path = data_file_path
        self.db_api = osmata.Osmata
    
    def read_from_db_file(self):
        if not pathlib.PurePath.exists(pathlib.Path(self.data_path)):
            f = open(self.data_path, 'x')
            f.close()
        fp = open(self.data_path, 'r')
        try:
            db = json.load(fp)
        except Exception as e:
            return f"Internal database is corrupt. Please see internal.omio file in {self.db_path}"
        else:
            _is_valid = self.db_api.validate_omio(db)
            errors = {}
            if not _is_valid:
                return f"Internal database is corrupt. Please see internal.omio file in {self.db_path}"
            else:
                for key in db.keys():
                    name = key
                    url = db[name]["URL"]
                    categories = db[name]["Categories"]
                    try:
                        self.db_api.push(name, url, categories)
                    except OspyataException as e:
                        errors[name] = e
            
            if errors.keys().length > 0:
                return errors
            
            return None
    
    def save_db(self):
        fp = open(self.data_path, 'w') # Rewriting the data file as the data is updated.
        fp.write(self.db_api.dumpOmio())
        fp.close()
    
    def add_data(self, name: str, url: str, categories: List[str]):
        try:
            self.db_api.push(name=name, url=url, categories=categories)
        except OspyataException as e:
            return "The enetered data is present in records."
        
        self.save_db()
        _errors = self.read_from_db_file()
        if _errors != None:
            return _errors
        return None
    
    def search_by_name(self, name: str):
        if name not in self.db_api.db.keys():
            return False
        else:
            data_name =  {
                "Name": name,
                "URL": self.db_api.db["URL"],
                "Categories": self.db_api.db["Categories"]
            }
            return data_name
    
    def del_data(self, name: str):
        _is_found = self.search_by_name(name)
        if _is_found == False:
            return f"Records with {name} not found"
        
        self.db_api.pop(name=name)
        self.save_db()
        _errors = self.read_from_db_file()
        if _errors != None:
            return _errors
    
    def get_all(self):
        return self.db_api.db