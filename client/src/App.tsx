import React from "react";
import { PostForm } from "./components/PostForm";
import { PostList } from "./components/PostList";
import { MicrophoneIcon } from "@heroicons/react/16/solid";

const App: React.FC = () => {
  return (
    <div className="flex flex-col min-h-screen bg-gray-200 font-sans">
      <header className="flex justify-center bg-teal-900 text-white p-4">
        <div className="flex justify-center items-center space-x-2">
          <MicrophoneIcon className="w-8 h-8" />
          <h1 className="text-2xl font-semibold">AWS Polly Post</h1>
        </div>
      </header>
      <main className="flex-grow py-6 mx-4">
        <PostForm />
        <PostList />
      </main>
      <footer className="text-gray-900 text-center p-4 text-xs">
        &copy; {new Date().getFullYear()} PollyPost
      </footer>
    </div>
  );
};

export default App;
