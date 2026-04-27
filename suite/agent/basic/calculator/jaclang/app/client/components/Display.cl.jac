"""Display readout with preview and error states."""

def:pub Display(value: str, preview: str = "", error: str = "") -> JsxElement {
    text = error if error else value;
    color = "#dc2626" if error else "#1f2937";

    return
        <div
            style={{
                "padding": "1rem 1.5rem",
                "background": "#f9fafb",
                "borderRadius": "0.5rem",
                "marginBottom": "1rem"
            }}
        >
            <div
                data-testid="calc-preview"
                style={{
                    "minHeight": "1.25em",
                    "fontSize": "0.875rem",
                    "color": "#6b7280",
                    "textAlign": "right",
                    "fontFamily": "ui-monospace, SFMono-Regular, monospace"
                }}
            >
                {preview}
            </div>
            <div
                data-testid="calc-display"
                style={{
                    "fontSize": "2rem",
                    "fontFamily": "ui-monospace, SFMono-Regular, monospace",
                    "textAlign": "right",
                    "color": color,
                    "minHeight": "1.5em"
                }}
            >
                {text}
            </div>
        </div>;
}
