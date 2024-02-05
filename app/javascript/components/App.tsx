import React from "react";
import GreenTea from "./GreenTea";
import BlackTea from "./BlackTea";
import { Routes, Route } from "react-router-dom";

export default function App() {
  return (
    <Routes>
      <Route path="green-tea" element={<GreenTea />} />
      <Route path="black-tea" element={<BlackTea />} />
    </Routes>
  );
}
