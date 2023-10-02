from typing import Union
from fastapi.events import StartupEvent
from run import (
  GetAnswer, 
   initialize )
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


async def startup_event():
    print("FastAPI application starting up")
    initialize()

# Register the startup event
app.add_event_handler(StartupEvent, startup_event)


@app.post("/request/")
async def get_answer(item:dict):
    question=item['question']
    id=item['user_id']
    answer=GetAnswer(question, id)
    return {'answer':answer}