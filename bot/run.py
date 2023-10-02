import json
import glob
import sys
import os
import requests
from chromadb.utils import embedding_functions
from langchain.llms import LlamaCpp
import streamlit as st
from langchain.chains import ConversationalRetrievalChain
from langchain.callbacks.manager import CallbackManager
from langchain.embeddings.sentence_transformer import SentenceTransformerEmbeddings
from langchain.callbacks.streaming_stdout import StreamingStdOutCallbackHandler
from langchain.document_loaders import UnstructuredPDFLoader, OnlinePDFLoader, PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.document_loaders.merge import MergedDataLoader
from langchain.document_loaders import PyPDFDirectoryLoader
from langchain.embeddings import LlamaCppEmbeddings
from langchain.vectorstores import Chroma
from langchain.chains import RetrievalQA
from langchain.tools.render import render_text_description
from langchain.agents import Tool
from langchain.agents import AgentExecutor
from langchain.chains.question_answering import load_qa_chain
from langchain.agents import AgentType
from langchain.prompts import (
    ChatPromptTemplate,
    MessagesPlaceholder,
    SystemMessagePromptTemplate,
    HumanMessagePromptTemplate,
)
from langchain.memory import StreamlitChatMessageHistory
from langchain.memory import ConversationBufferMemory
from langchain import hub
from ctransformers import AutoModelForCausalLM
from langchain.agents.output_parsers import ReActSingleInputOutputParser
from langchain.agents.format_scratchpad import format_log_to_str
from langchain.agents.output_parsers import JSONAgentOutputParser
from langchain_experimental.autonomous_agents import AutoGPT
from langchain.agents.format_scratchpad import format_log_to_messages
from langchain.agents import initialize_agent
from langchain.chains import LLMChain
from langchain.prompts import PromptTemplate
from langchain.embeddings import HuggingFaceEmbeddings
from langchain.memory import ConversationKGMemory

embedding_function = SentenceTransformerEmbeddings(model_name="all-MiniLM-L6-v2")
chroma_db= Chroma(persist_directory="./chroma_db", embedding_function=embedding_function)

def extract_docs():
  file_path="ntrs-public-metadata.json"
  json_file=open(file_path)
  data=json.load(json_file)
  new_dict={}
  for index,item in list(data.items())[:20]:
      new_dict[index]=item
  print(json.dumps(new_dict, indent=2))
  for key, values in new_dict.items():
      if (values.get("disseminated")=="DOCUMENT_AND_METADATA"):
          print('downloadin and saving...')
          response=requests.get(f"https://ntrs.nasa.gov/api/citations/{key}/downloads/{key}.pdf")
          if(response.status_code==200):
              file_name = os.path.join('files', f"{key}.pdf")
              with open(file_name, 'wb') as file:
                  file.write(response.content)
#extract_docs()
def test_llama():

  llm1=  AutoModelForCausalLM.from_pretrained("/home/ec2-user/llama-2-70b-chat.Q8_0.gguf",model_type="llama", gpu_layers=0,
                                              )
  llm1("Simulate a rap battle between Stephen Colbert and John Oliver")
  n_gpu_layers = 8  # Metal set to 1 is enough.
  n_batch = 512  # Should be between 1 and n_ctx, consider the amount of RAM of your Apple Silicon Chip.
  callback_manager = CallbackManager([StreamingStdOutCallbackHandler()])

  # Make sure the model path is correct for your system!

  llm("Simulate a rap battle between Stephen Colbert and John Oliver")


#test_llama()

def embed_files():
 # hf_embeddings = HuggingFaceEmbeddings()
  default_ef = embedding_functions.DefaultEmbeddingFunction()
  embedding_function = SentenceTransformerEmbeddings(model_name="all-MiniLM-L6-v2")
  #llama_embeddings = LlamaCppEmbeddings(model_path="/home/ec2-user/llama-2-70b-chat.Q8_0.gguf")
  pdf_files = glob.glob(os.path.join('files/', '*.pdf'))
  pdfs=[]
  c=0
  #tests=['hello world','how are you', 'i am fine']
  #embedding_fuction.embed_documents(tests)
  for pdf_file in pdf_files:
     if(c==1):
         break
     print(pdf_file)
     loader = PyPDFLoader(pdf_file)
     sub_docs = loader.load()
     for doc in sub_docs:
      doc.metadata["source"] = pdf_file
      pdfs.extend(sub_docs)
     c+=1
  print("--------------------------------------------------------------")
  print("DONE LOADING THEM ALL")
  text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=0)
  docs=text_splitter.split_documents(pdfs)

  #docs=text_splitter.create_documents(tests)
  print("DONE SPLITTING DOCUMENTS")
  db = Chroma.from_documents(docs[:20],embedding_function, persist_directory="./chroma_db")
  print("DONE PERSISTING I GUESS")
#embed_files()

 
def get_llama(): 
  llm=  AutoModelForCausalLM.from_pretrained("/home/ec2-user/llama-2-70b-chat.Q8_0.gguf", 
                                             model_type="llama",  
                                             gpu_layers=0,) 
  return llm 
def initialize(): 
  n_batch = 512 
  callback_manager = CallbackManager([StreamingStdOutCallbackHandler()]) 
 
  # Make sure the model path is correct for your system! 
  llm = LlamaCpp( 
      model_path="/home/ec2-user/llama-2-70b-chat.Q8_0.gguf", 
      n_gpu_layers=1, 
      n_batch=n_batch, 
      n_ctx=1500, 
      f16_kv=True, 
      callback_manager=callback_manager, 
      verbose=True,) 
  return llm 
    
    
llama=initialize()
def setup_base(): 
  #  llama_embeddings = LlamaCppEmbeddings(model_path="/home/ec2-user/llama-2-70b-chat.Q8_0.gguf") 
   chroma_db= Chroma(persist_directory="./chroma_db", embedding_function=embedding_function) 
   messages=[ 
      SystemMessagePromptTemplate.from_template( 
         '''You are an advanced AI-powered Research Assistant designed to assist users throughout their research journey in the context of the conversation.You are Capable of understanding natural language queries, your primary goal is to streamline the research process for users in various academic disciplines. As a Research Assistant , you should excel in the following tasks:\n 
        "1. Problem Identification:Prompt users to articulate and refine their research problems or questions effectively.\n" 
        2. Literature Review:Conduct literature searches based on user-specified topics. Summarize and present key findings from relevant research articles.\n 
        3. Research: Provide examples and explanations of different research methodologies from researches\n 
        4. Do not answer anything that you do not know'''), 
        MessagesPlaceholder(variable_name="chat_history"), 
        HumanMessagePromptTemplate.from_template("{question}")] 
  
   prompt = ChatPromptTemplate(messages=messages) 
   #base = RetrievalQA.from_chain_type( 
     #   llm=llama, retriever=chroma_db.as_retriever(), 
    #    chain_type_kwargs={"prompt": prompt} 
   #     ) 
  # result=base({'query':"who are the researchers of the papers?"}) 
  # result["result"] 

   memory2 = ConversationBufferMemory(memory_key="chat_history",return_messages=True) 
   conversation = ConversationalRetrievalChain.from_llm( 
      llm=llama,verbose=True,memory=memory2, retriever=chroma_db.as_retriever()) 
   conversation("What is The value of Routh's discriminant?") 


def GetAnswer(question:str,  id:str):
  print(f"question asked is {question}")
  history = get_history_from_id(id=id, question=question)
  print(f"history is {history.messages}")
  memory = ConversationBufferMemory(memory_key="chat_history", 
                                    chat_memory=history, 
                                    return_messages=True, 
                                    output_key='answer')
  conversation = ConversationalRetrievalChain.from_llm(
      llm=llama,verbose=True,memory=memory, retriever=chroma_db.as_retriever())
  result=conversation(question)
 # print(f"answer is {result}")
  return history.messages
  #return result['answer']

def get_history_from_id(id:str, question:str):


   history = SQLChatMessageHistory(
    session_id=id,
    connection_string='sqlite:///sqlite.db')
   return history


def GetUserHistory(id:str):
   history = SQLChatMessageHistory(session_id=id, connection_string='sqlite:///sqlite.db')
   if len(history.messages) == 0:
      return []
   return [msg.content for msg in history.messages]
                                                     