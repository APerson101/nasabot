from typing import Union
from run import (
  GetAnswer, 
   initialize )
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.on_event("startup")
async def startup_event():
    print("FastAPI application starting up")
    initialize()



@app.post("/request/")
async def get_answer(item:dict):
    question=item['question']
    id=item['user_id']
    answer=GetAnswer(question, id)
    return {'answer':answer}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)