import gradio as gr
import logging

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(name)s %(message)s",
)
logger = logging.getLogger("deepseek_gradio")

def safe_generate(*args, **kwargs):
    try:
        # Replace with your actual model inference code
        logger.info("Model inference called with args: %s, kwargs: %s", args, kwargs)
        return "Hello from DeepSeek!"
    except Exception as e:
        logger.error(f"Error during inference: {e}", exc_info=True)
        return f"Error: {e}"

iface = gr.Interface(
    fn=safe_generate,
    inputs=[gr.Textbox(label="Input")],
    outputs=[gr.Textbox(label="Output")],
    title="DeepSeek Demo",
    description="A demo Gradio app with error handling and logging."
)

if __name__ == "__main__":
    logger.info("Starting Gradio app on 0.0.0.0:7860")
    iface.launch(server_name="0.0.0.0", server_port=7860)
