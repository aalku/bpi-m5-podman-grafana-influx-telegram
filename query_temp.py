# sudo apt install python3-full

import json
import datetime
import sys
import os

try:

  hours = 72

  f = open(os.getenv("FAN_LOG", "/var/log2/fan-controller/fan-controller.log"), "r")
  try:
      lines = f.readlines()
  finally:
      f.close()


  f = open(os.getenv("FAN_STATUS", "/var/run/fan-controller/fan-status.json"), "r")
  try:
    lines2 = f.readlines()
  finally:
    f.close()

  data = []

  start = datetime.datetime.now() - datetime.timedelta(hours=hours)

  def json_serialize(obj):
    if isinstance(obj, datetime.datetime):
        return obj.isoformat()
    raise TypeError ("Type %s not serializable" % type(obj))

  for l in (lines + lines2):
    try:
        d = json.loads(l)
        dt = datetime.datetime.fromisoformat(d["updated-ts"])
        if dt >= start:
            temp = d["temp-c"]
            fan = int(100 if bool(d["state"]) else 0)
            data.append({"ts":dt, "fan":fan, "temp":temp})
    except:
        None

  print (json.dumps(data, default=json_serialize))
except Exception as e:
  print(e, file=sys.stderr)
