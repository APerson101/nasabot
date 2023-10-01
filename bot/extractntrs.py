import json
import os
import requests
from langchain.llms import LlamaCpp
from langchain.callbacks.manager import CallbackManager
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
from langchain.agents import AgentType
from langchain.memory import ConversationBufferMemory
from langchain import hub
from langchain.agents.output_parsers import ReActSingleInputOutputParser
from langchain.agents.format_scratchpad import format_log_to_str
from langchain.agents.output_parsers import JSONAgentOutputParser
from langchain_experimental.autonomous_agents import AutoGPT
from langchain.agents.format_scratchpad import format_log_to_messages
from langchain.agents import initialize_agent
from langchain.chains import LLMChain
from langchain.prompts import PromptTemplate
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
  n_gpu_layers = 8  # Metal set to 1 is enough.
  n_batch = 512  # Should be between 1 and n_ctx, consider the amount of RAM of your Apple Silicon Chip.
  callback_manager = CallbackManager([StreamingStdOutCallbackHandler()])

  # Make sure the model path is correct for your system!
  llm = LlamaCpp(
      model_path="/home/ec2-user/llama-2-70b-chat.Q8_0.gguf",
      n_gpu_layers=n_gpu_layers,
      n_batch=n_batch,
      n_ctx=2048,
      f16_kv=True,
      callback_manager=callback_manager,
      verbose=True,)
  llm("Simulate a rap battle between Stephen Colbert and John Oliver")


#test_llama()


def embed_files():
  llama_embeddings = LlamaCppEmbeddings(model_path="/home/ec2-user/llama-2-70b-chat.Q8_0.gguf")
  loader = PyPDFDirectoryLoader('files/')
  data = loader.load()
  text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=0)
  docs=text_splitter.split_documents(data)
  db = Chroma.from_documents(docs, llama_embeddings, persist_directory="./chroma_db")
  db.persists()
#embed_files()

def get_llama():
  n_gpu_layers = 8  # Metal set to 1 is enough.
  n_batch = 512  # Should be between 1 and n_ctx, consider the amount of RAM of your Apple Silicon Chip.
  callback_manager = CallbackManager([StreamingStdOutCallbackHandler()])

  # Make sure the model path is correct for your system!
  llm = LlamaCpp(
      model_path="/home/ec2-user/llama-2-70b-chat.Q8_0.gguf",
      n_gpu_layers=n_gpu_layers,
      n_batch=n_batch,
      n_ctx=2048,
      f16_kv=True,
      callback_manager=callback_manager,
      verbose=True,)
  return llm

llama=get_llama()
def setup_base():
   llama_embeddings = LlamaCppEmbeddings(model_path="/home/ec2-user/llama-2-70b-chat.Q8_0.gguf")
   chroma_db= Chroma(persist_directory="./chroma_db", embedding_function=llama_embeddings)
   research_prompt_template="""You are an advanced AI-powered Research Assistant designed to assist users throughout their research journey. Capable of understanding natural language queries, your primary goal is to streamline the research process for users in various academic disciplines. As a Research Assistant , you should excel in the following tasks:
        1. Problem Identification:Prompt users to articulate and refine their research problems or questions effectively.
        2. Literature Review:Conduct literature searches based on user-specified topics. Summarize and present key findings from relevant research articles.
        3. Research: Provide examples and explanations of different research methodologies from researches
        4. Do not answer anything that you do not know
        {context}
        Question:{question}
        Helpful Answer:"""
   prompt = PromptTemplate(template=research_prompt_template)
   base = RetrievalQA.from_chain_type(
        llm=llama, chain_type="stuff", retriever=chroma_db.as_retriever(),
        chain_type_kwargs={"prompt": prompt}
        )
   result=base({'query':"who are the researchers of the papers?"})
   result["result"]

setup_base()

