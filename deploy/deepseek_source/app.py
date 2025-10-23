import gradio as gr
import logging
from transformers import pipeline

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(name)s %(message)s",
)
logger = logging.getLogger("deepseek_gradio")

# Load the model
logger.info("Loading DeepSeek Coder model...")
generator = pipeline("text-generation", model="deepseek-ai/deepseek-coder-1.3b-instruct", device_map="auto")
logger.info("Model loaded successfully.")

def safe_generate(prompt):
    try:
        logger.info("Generating code for prompt: %s", prompt)
        # Generate code
        outputs = generator(prompt, max_length=512, num_return_sequences=1, temperature=0.7)
        generated_text = outputs[0]['generated_text']
        # Remove the prompt from the output if it's included
        if generated_text.startswith(prompt):
            generated_text = generated_text[len(prompt):].strip()
        return generated_text
    except Exception as e:
        logger.error(f"Error during inference: {e}", exc_info=True)
        return f"Error: {e}"

iface = gr.Interface(
    fn=safe_generate,
    inputs=[gr.Textbox(label="Code Prompt", placeholder="Enter your code generation prompt here...")],
    outputs=[gr.Textbox(label="Generated Code")],
    title="DeepSeek Coder Demo",
    description="Generate code using DeepSeek Coder model."
)

if __name__ == "__main__":
    logger.info("Starting Gradio app on 0.0.0.0:8000")
    iface.launch(server_name="0.0.0.0", server_port=8000)
