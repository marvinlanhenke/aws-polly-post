import axios from "axios";

const BASE_URL = import.meta.env.VITE_API_URL;

const api = axios.create({
  baseURL: BASE_URL,
  headers: {
    "Content-Type": "application/json",
  },
});

export interface PostFormData {
  text: string;
  voice: string;
}

export interface GetPostData {
  id: string;
  status: string;
  text: string;
  url: string;
  voice: string;
  createdAt: string;
}

export const createPost = (data: PostFormData) => api.post("/v1/posts", data);
export const getPosts = () => api.get("/v1/posts");
