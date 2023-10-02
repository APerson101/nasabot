from typing import Union
import subprocess
from run import (
  GetAnswer, 
   initialize )
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


def launch_flutter_app():
    server_ip_address = "3.95.131.62"

    # Replace "path/to/your/flutter/app" with the actual path to your Flutter app directory
    flutter_app_directory = "../nasabot/flutterapp"

    # Change to the Flutter app directory
    subprocess.run(["cd", flutter_app_directory], shell=True)

    # Build the Flutter app for release
    subprocess.run(["flutter", "build", "web", "--release"])

    # Install and run the Flutter app on a connected device
    subprocess.run(["flutter", "run", "--release", "-d", "chrome"])
    
@app.on_event("startup")
async def startup_event():
    print("FastAPI application starting up")
    initialize()
    launch_flutter_app()



@app.post("/request/")
async def get_answer(item:dict):
    question=item['question']
    id=item['user_id']
    answer=GetAnswer(question, id)
    return {'answer':answer}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)