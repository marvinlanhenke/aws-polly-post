import React from "react";
import { PostForm } from "./components/PostForm";
import { PostList } from "./components/PostList";

const App: React.FC = () => {
  return (
    <div className="flex flex-col min-h-screen bg-gray-200 font-sans">
      <header className="flex justify-center bg-teal-900 text-white p-4">
        <h1 className="text-2xl">AWS Polly Post</h1>
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
