import React from "react";
import { render } from "@testing-library/react";
import App from "../components/App";

it("renders the App", () => {
  render(<App />);

  expect(true).toBe(true);
});
