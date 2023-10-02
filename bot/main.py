from typing import Union
import subprocess
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
from run import (
  GetAnswer, 
  GetUserHistory,
   initialize )
from fastapi import FastAPI, Request

app = FastAPI()

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Adjust this to your frontend's URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
# class QuestionInput(BaseModel):
#     user_id: int
#     question: str


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

    # launch_flutter_app()



@app.post("/request")
async def get_answer(item:Request):
    item = await item.json()
    print(item)
    question=item['question']
    id=item['user_id']
    answer=GetAnswer(question, id)
    return {'answer':answer}
@app.get("/history/{username}")
async def get_history(username:str):
    return {'history':GetUserHistory(username)}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)