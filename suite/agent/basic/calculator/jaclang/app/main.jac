"""Full-stack calculator app entry point."""

import from server.compute { Compute, ListHistory, ClearHistory }

cl {
    import from client.App { app as CalculatorApp }

    def:pub app -> JsxElement {
        return
            <CalculatorApp />;
    }
}
