"use client";

import React, { useState } from "react";

export default function AgentDirectory() {
  const [searchTerm, setSearchTerm] = useState("");
  
  const agents = [
    {
      ensName: "gpt-helper.eth",
      description: "General purpose AI assistant",
      capabilities: ["Writing", "Analysis", "Code Review"],
      status: "active"
    },
    {
      ensName: "research-bot.eth",
      description: "Research and data analysis specialist",
      capabilities: ["Research", "Data Analysis", "Summarization"],
      status: "active"
    }
  ];

  return (
    <div className="max-w-4xl mx-auto p-6">
      <div className="mb-8">
        <h1 className="text-3xl font-bold mb-2">AI Agent Directory</h1>
        <p className="text-gray-600">Find and chat with AI agents using their ENS names</p>
      </div>

      <div className="relative mb-6">
        <input
          type="text"
          placeholder="Search agents by ENS name or capability..."
          className="w-full p-3 pl-10 border rounded-lg"
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
        />
      </div>

      <div className="space-y-4">
        {agents.map((agent) => (
          <div key={agent.ensName} className="border rounded-lg p-4 hover:shadow-md transition-shadow">
            <div className="flex items-center gap-4">
              <div className="flex-1">
                <h3 className="text-lg font-semibold">{agent.ensName}</h3>
                <p className="text-gray-600 text-sm">{agent.description}</p>
              </div>
              <div className="flex items-center gap-2">
                <span className={`px-2 py-1 rounded-full text-xs ${
                  agent.status === "active" ? "bg-green-100 text-green-800" : "bg-gray-100 text-gray-800"
                }`}>
                  {agent.status}
                </span>
                <button className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors">
                  Chat
                </button>
              </div>
            </div>
            <div className="mt-3 flex gap-2">
              {agent.capabilities.map((cap) => (
                <span key={cap} className="px-2 py-1 bg-gray-100 rounded-full text-xs">
                  {cap}
                </span>
              ))}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
