import React, { FormEvent, useState } from "react";
import { createPost, PostFormData } from "../api/api";

export const PostForm: React.FC = () => {
  const [text, setText] = useState<string>("");
  const [voice, setVoice] = useState<string>("Joanna");
  const [error, setError] = useState<string>("");
  const [success, setSuccess] = useState<string>("");

  const handleSubmit = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    setSuccess("");
    setError("");

    const data: PostFormData = {
      text,
      voice,
    };

    try {
      await createPost(data);
      setSuccess("Post added successfully!");
      setTimeout(() => setSuccess(""), 1000);
    } catch (err: any) {
      console.error(err);
      setError("Failed to create post. Please try again");
      setTimeout(() => setError(""), 1000);
    }
  };

  return (
    <>
      {success && (
        <div className="bg-green-100 text-green-700 p-3 rounded mb-4">
          {success}
        </div>
      )}

      {error && (
        <div className="bg-red-100 text-red-700 p-3 rounded mb-4">{error}</div>
      )}

      <form
        onSubmit={handleSubmit}
        className="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4"
      >
        <div className="mb-4">
          <textarea
            id="text"
            value={text}
            onChange={(e) => setText(e.target.value)}
            className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
            placeholder="Enter your post..."
            rows={3}
            required
          />
        </div>
        <div className="mb-6">
          <label className="block text-gray-700 text-sm mb-2" htmlFor="voice">
            Select a Voice:
          </label>
          <select
            id="voice"
            value={voice}
            onChange={(e) => setVoice(e.target.value)}
            className="block appearance-none w-full bg-white border border-gray-400 hover:border-gray-500 px-4 py-2 pr-8 rounded shadow leading-tight focus:outline-none focus:shadow-outline"
            required
          >
            <option value="Joanna">Joanna</option>
            <option value="Joey">Joey</option>
          </select>
        </div>
        <div className="flex items-center justify-between">
          <button
            type="submit"
            className="bg-teal-500 hover:bg-teal-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline disabled:bg-gray-200"
            disabled={text.trim() === ""}
          >
            Create Post
          </button>
        </div>
      </form>
    </>
  );
};
