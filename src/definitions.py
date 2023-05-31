# All global definitions goes here

import os
import pathlib

class Definitions:
  def __init__(self):
    pass
  
  def data_dir(self):
    if os.getenv("XDG_DATA_HOME"):
      return pathlib.PurePath(os.getenv("XDG_DATA_HOME")).joinpath("sitemarker")
    else:
      return pathlib.Path(pathlib.Path.home()).joinpath('.local', 'share', 'sitemarker')
    
  def data_path(self):
    return pathlib.PurePath(self.data_dir()).joinpath('internal.omio')
  
  def config_dir(self):
    if os.getenv("XDG_CONFIG_HOME"):
      return pathlib.PurePath(os.getenv('XDG_CONFIG_HOME')).joinpath('sitemarker')
    else:
      return pathlib.PurePath(pathlib.Path.home()).joinpath('.config', 'sitemarker')


