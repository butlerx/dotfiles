require("parrot").setup({
    providers = {
        pplx = {
            api_key = os.getenv("PERPLEXITY_API_KEY"),
        },
        openai = {},
        github = {
            api_key = os.getenv("GITHUB_TOKEN"),
        },
    },
})
