## Vector database/OpenAI experiment

The code in this repository is a combination of the following:

* Based on the Petal Pro boilerplate code (Petal Pro 1.6.2)
* This [article](https://www.timescale.com/blog/postgresql-as-a-vector-database-create-store-and-query-openai-embeddings-with-pgvector/) on how to use `pgvector`, python and OpenAI 
* This example [OpenAI code](https://petal.build/recipes/open-ai) written in Elixir

## Prerequisites

Requires the [pgvector](https://github.com/pgvector/pgvector) Postgres extension. I had to follow the instructions for Windows to build and install the extension.

## Getting started

Once the `pgvector` extension is installed, run `mix setup`. This will download dependencies, compile the code and run the migrations. There are two migrations that are relevant to `pgvector`:

* `create_vector_extension` enables the `pgvector` extension for the database
* `create_embeddings` creates a table called `embeddings` that includes a `:vector` field

`priv/repo/seeds.exs` has been updated to parse `priv/repo/blog_data_and_embeddings.csv` which is used to update the `embeddings` table.

`blog_data_and_embeddings.csv` was generated from the Jupyter Notebook that's used in the blog [article](https://www.timescale.com/blog/postgresql-as-a-vector-database-create-store-and-query-openai-embeddings-with-pgvector/). It contains data about Timescale and vector data (that was created by OpenAI). To see what this data looks like, go to:

```
http://localhost:4000/embeddings
```

Now your ready to interact with the chat bot:

```
http://localhost:4000/recipes/open-ai/examples/open-ai-prompt
```

Type in a question. It's just like using ChatGPT. If you ask a question about Timescale, then it will include custom data from the embedded knowledge base.

## How does it work?

To see more detail about the process, see the original [article](https://www.timescale.com/blog/postgresql-as-a-vector-database-create-store-and-query-openai-embeddings-with-pgvector/). But here's the gist of how it works:

* Starting with your knowledge base, you make an OpenAI call to generate vector data for each document
* Store vector data in a vector database (in our case postgres with the `pgvector` extension)
* Use OpenAI to generate vector data for a search phrase
* Use the vector database to compare the search phrase vector data with the knowledge base vector data
* Return the top 3 documents
* Generate a LLM response by generating a prompt that includes your search phrase and the contents of the top three documents

![](screenshot.png)