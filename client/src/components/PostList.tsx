import React, { useEffect, useState } from "react";
import { GetPostData, getPosts } from "../api/api";
import { ArrowPathIcon } from "@heroicons/react/16/solid";

export const PostList: React.FC = () => {
  const [loading, setLoading] = useState<boolean>(true);
  const [posts, setPosts] = useState<GetPostData[]>([]);
  const [error, setError] = useState<string>("");

  useEffect(() => {
    fetchPosts();
  }, []);

  const fetchPosts = async () => {
    try {
      setLoading(true);
      setError("");
      const response = await getPosts();
      const items: GetPostData[] = response.data.items;
      items.sort(
        (a, b) =>
          new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime(),
      );
      setPosts(items);
    } catch (err: any) {
      console.error(err);
      setError(err);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <p className="text-center">Loading...</p>;
  if (error) return <p className="text-center text-red-500">{error}</p>;

  return (
    <div className="overflow-x-auto mx-10">
      <ArrowPathIcon
        onClick={() => fetchPosts()}
        className="w-12 h-12 my-2 bg-teal-500 hover:bg-teal-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline hover:cursor-pointer hover:shadow-md"
      >
        Reload
      </ArrowPathIcon>
      <table className="min-w-full bg-white border border-gray-200">
        <thead>
          <tr>
            <th className="px-6 py-3 border-b text-left text-sm font-medium text-gray-700 uppercase tracking-wider">
              #
            </th>
            <th className="px-6 py-3 border-b text-left text-sm font-medium text-gray-700 uppercase tracking-wider">
              Status
            </th>
            <th className="px-6 py-3 border-b text-left text-sm font-medium text-gray-700 uppercase tracking-wider">
              Voice
            </th>
            <th className="px-6 py-3 border-b text-left text-sm font-medium text-gray-700 uppercase tracking-wider">
              Post
            </th>
            <th className="px-6 py-3 border-b text-left text-sm font-medium text-gray-700 uppercase tracking-wider">
              Audio File
            </th>
            <th className="px-6 py-3 border-b text-left text-sm font-medium text-gray-700 uppercase tracking-wider">
              Created At
            </th>
          </tr>
        </thead>
        <tbody>
          {posts.length > 0 ? (
            posts.map((post, index) => (
              <tr key={post.id} className="hover:bg-gray-100">
                <td className="px-6 py-4 whitespace-nowrap border-b">
                  {index + 1}
                </td>
                <td className="px-6 py-4 whitespace-nowrap border-b">
                  <span
                    className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${
                      post.status === "UPDATED"
                        ? "bg-green-100 text-green-800"
                        : post.status === "PROCESSING"
                          ? "bg-yellow-100 text-yellow-800"
                          : "bg-red-100 text-red-800"
                    }`}
                  >
                    {post.status}
                  </span>
                </td>
                <td className="px-6 py-4 whitespace-nowrap border-b">
                  {post.voice}
                </td>
                <td className="px-6 py-4 whitespace-nowrap border-b">
                  {post.text}
                </td>
                <td className="px-6 py-4 whitespace-nowrap border-b">
                  {post.status === "UPDATED" ? (
                    <div className="text-center">
                      <audio controls className="w-full mt-2">
                        <source src={post.url} type="audio/mpeg" />
                        Your browser does not support the audio element
                      </audio>
                      <a
                        href={post.url}
                        download={`post-${post.id}.mp3`}
                        className="text-blue-500 hover:underline"
                      >
                        Download Audio
                      </a>
                    </div>
                  ) : (
                    <span className="text-gray-500">N/A</span>
                  )}
                </td>
                <td>{post.createdAt}</td>
              </tr>
            ))
          ) : (
            <tr>
              <td
                className="px-6 py-4 whitespace-nowrap border-b text-center text-gray-500"
                colSpan={6}
              >
                No posts available.
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
};
