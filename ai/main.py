from fastapi import FastAPI, Request, HTTPException
from pydantic import BaseModel
from dotenv import load_dotenv
from pydantic_ai import Agent
from pydantic_core import to_jsonable_python
from pydantic_ai.messages import ModelMessagesTypeAdapter
from pydantic_ai.mcp import MCPServerStdio
from pydantic_ai.models.openai import OpenAIModel
from pydantic_ai.providers.openrouter import OpenRouterProvider
import os
import logfire
# Load environment variables
load_dotenv()
logfire.configure()
logfire.instrument_pydantic_ai()

# Initialize FastAPI app
app = FastAPI()

model = OpenAIModel(
    "openai/gpt-5-mini",
    provider=OpenRouterProvider(api_key=os.getenv("OPENROUTER_API_KEY")),
)
#model = "google-gla:gemini-2.5-flash"
system_prompt =   open("system_prompt.md", "r", encoding="utf-8").read()
print(system_prompt)


mcp_chart = MCPServerStdio(
    "npx", ["-y", "@antv/mcp-server-chart"]
)


mcp_postgres = MCPServerStdio(
    "npx",
      [
        "-y",
        "@modelcontextprotocol/server-postgres",
        "postgresql://admin:112233@localhost:5433/erp2"
      ],
      {}
)

agent = Agent(
    model=model,
    system_prompt=system_prompt,
    toolsets=[ mcp_postgres ,mcp_chart],
    retries=3,
)


@app.post("/chat")
async def chat(request: Request):
    data = await request.json()
    user_prompt = data.get("user_prompt", "")
    message_history = data.get("message_history", [])
    message_history = ModelMessagesTypeAdapter.validate_python(message_history)
    async with agent:
        result = await agent.run(user_prompt, message_history=message_history)
    new_message_history = to_jsonable_python(result.all_messages())

    return {"message": result.output, "message_history": new_message_history}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
