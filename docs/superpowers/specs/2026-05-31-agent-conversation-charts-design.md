# Agent Conversation Charts Design

## Goal

Allow the public `/agent` page to display charts inside assistant messages when the user explicitly asks for a chart.

## User Experience

- Normal ERP questions continue to return text answers and generated SQL only.
- When the user explicitly requests a chart, the assistant may include one chart below its written answer.
- If the answer data cannot be represented safely as a supported chart, the assistant returns the text answer without a chart.
- The chart is rendered inside the assistant conversation bubble and remains responsive on desktop and mobile.

## Architecture

The API adds a `present_erp_answer` function tool. DeepSeek uses `query_erp_database` for one read-only query and then submits the final answer through `present_erp_answer`.

The final answer tool accepts:

- `answer`: concise written answer.
- `chart`: optional declarative chart specification.

The chart specification contains:

- `type`: one approved renderer identifier.
- `title`: chart heading.
- `xKey`: row property used for category or horizontal values.
- `series`: value keys with display labels.
- `data`: chart rows derived by the API from the same SQL result.

The model selects chart keys but does not provide trusted chart values. The API validates the final chart specification, extracts chart rows from the database result, and returns the safe chart payload to the browser. It never accepts raw JSX, JavaScript, HTML, or arbitrary Recharts configuration from the model.

## Supported Charts

The safe renderer supports common Recharts visualizations:

- `bar`
- `line`
- `area`
- `pie`
- `scatter`
- `radar`

Each type maps to a fixed React component template. The model may choose among these approved identifiers but cannot generate executable UI code.

## Data Rules

- Charts appear only when the user explicitly asks for a chart.
- A chart must use the same SQL result used for the answer.
- The agent cannot run an additional query only for chart generation.
- Existing SQL restrictions continue to block writes, user tables, role tables, auth schemas, and system schemas.
- Chart rows are capped and validated before returning to the browser.
- Unsupported or malformed chart specifications are omitted while the text answer remains available.

## Frontend

Create a focused chart renderer component for assistant messages. The component receives a validated chart specification and maps its `type` to a fixed Recharts visualization. It uses a responsive container and a compact card so charts fit naturally inside the conversation.

## Testing

- Unit-test chart specification validation for valid charts, malformed rows, unsupported types, oversized inputs, and absent charts.
- Run the existing ERP agent SQL guard tests.
- Run lint and build.
- Use `playwright-cli show` and submit an explicit chart request in `/agent`; confirm the chart renders in the assistant conversation.
- Submit a normal non-chart question; confirm no chart renders.
